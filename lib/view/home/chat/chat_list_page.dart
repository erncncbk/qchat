import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/constants/navigation/navigation_constant.dart';
import 'package:qchat/core/extensions/context_extension.dart';
import 'package:qchat/core/extensions/string_extension.dart';
import 'package:qchat/core/init/navigation/navigation_service.dart';
import 'package:qchat/core/init/services/fb_auth_service.dart';
import 'package:qchat/core/init/services/helper_service.dart';
import 'package:qchat/core/init/services/storage_service.dart';
import 'package:qchat/core/init/utils/utils.dart';
import 'package:qchat/core/provider/app_state/app_state_provider.dart';
import 'package:qchat/locator.dart';
import 'package:qchat/view/home/chat/chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final StorageService? _storageService = locator<StorageService>();

  NavigationService navigation = NavigationService.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  AppStateProvider? _appStateProvider = locator<AppStateProvider>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FBAuthService? _fbAuthService = FBAuthService();

  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  FocusNode? _searchFocus;
  Map<String, dynamic>? userMap;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body(),
    );
  }

  Future onSearch(String name) async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('users')
        .where("name", isEqualTo: name)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
    print(userMap);
  }

  Widget _body() {
    return Column(
      children: [
        SizedBox(
          height: context.highValue - 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () async {
                  _fbAuthService!.signOut();
                  await _storageService!.clearStorageAsync().then((value) {
                    _appStateProvider!.clearToken();
                    exit(0);
                  });
                },
                icon: Icon(
                  Icons.logout,
                  color: AppColors.primary,
                )),
          ],
        ),
        SizedBox(height: context.lowValue),
        GestureDetector(
          onTap: () {
            navigation.navigateToPage(
                path: NavigationConstants.searchChatListPage);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: AppColors.secondary, width: 1)),
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CustomTextWidget(
                    text: 'Search',
                    textStyle: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w400,
                    ).smallStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
              if (!userSnapshot.hasData) {
                return HelperService().loadingCircleForFB();
              }
              return countChatListUsers(_auth.currentUser!.uid, userSnapshot) >
                      0
                  ? Container(
                      height: 70.toDouble() * userSnapshot.data!.docs.length,
                      child: ListView(
                          children: userSnapshot.data!.docs.map((userData) {
                        if (userData['fbUid'] == _auth.currentUser!.uid) {
                          return Container();
                        } else {
                          return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_auth.currentUser!.uid)
                                  .collection('chatlist')
                                  .where('chatWith',
                                      isEqualTo: userData['fbUid'])
                                  .snapshots(),
                              builder: (context, chatListSnapshot) {
                                return _chatListTile(
                                    userData, chatListSnapshot);
                              });
                        }
                      }).toList()),
                    )
                  : Container(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.forum,
                            color: Colors.grey[700],
                            size: 64,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'There are no users except you.\nPlease use other devices to chat.',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )),
                    );
            }),
      ],
    );
  }

  Widget _chatListTile(QueryDocumentSnapshot<Object?> userData,
      AsyncSnapshot<QuerySnapshot<Object?>> chatListSnapshot) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary,
        // no matter how big it is, it won't overflow
      ),
      title: Text(userData['name']),
      subtitle: Text(
          (chatListSnapshot.hasData && chatListSnapshot.data!.docs.isNotEmpty)
              ? chatListSnapshot.data!.docs[0]['lastChat']
              : '...'),
      trailing: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 4, 4),
          child: (chatListSnapshot.hasData &&
                  chatListSnapshot.data!.docs.isNotEmpty)
              ? Container(
                  width: 60,
                  height: 50,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: CircleAvatar(
                        radius: 9,
                        child: Text(
                          chatListSnapshot.data!.docs[0]['badgeCount'] == null
                              ? ''
                              : ((chatListSnapshot.data!.docs[0]
                                          ['badgeCount'] !=
                                      0
                                  ? '${chatListSnapshot.data!.docs[0]['badgeCount']}'
                                  : '')),
                          style: TextStyle().smallStyle,
                        ),
                        backgroundColor: chatListSnapshot.data!.docs[0]
                                    ['badgeCount'] ==
                                null
                            ? Colors.transparent
                            : (chatListSnapshot.data!.docs[0]['badgeCount'] != 0
                                ? AppColors.appYellow
                                : Colors.transparent),
                        foregroundColor: Colors.white,
                      )),
                )
              : Text('')),
      onTap: () => _moveTochatRoom(
        userData['fbUid'],
      ),
    );
  }

  _badgeWidget(dynamic badgeCount) {
    return CircleAvatar(
      radius: 14,
      child: Text(
        badgeCount == null ? '' : ((badgeCount != 0 ? '$badgeCount' : '')),
        style: const TextStyle(fontSize: 13),
      ),
      backgroundColor: badgeCount == null
          ? Colors.transparent
          : (badgeCount != 0 ? AppColors.primary : Colors.transparent),
      foregroundColor: Colors.white,
    );
  }

  Future _moveTochatRoom(String? fbUid) async {
    await _firestore
        .collection('users')
        .where("fbUid", isEqualTo: fbUid)
        .get()
        .then((value) {
      _appStateProvider!.setUserMap(value.docs[0].data());
    });
    try {
      String roomId = chatRoomId(_auth.currentUser!.uid, fbUid);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatPage(
                chatRoomId: roomId,
                userMap: _appStateProvider!.getUserMap!,
                myId: _auth.currentUser!.uid,
              )));
    } catch (e) {
      print("Something went wrong");
    }
  }
}
