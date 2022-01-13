import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qchat/core/components/buttons/custom_elevated_button.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/components/textFormField/custom_text_form_field_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/extensions/context_extension.dart';
import 'package:qchat/core/extensions/string_extension.dart';
import 'package:qchat/core/init/services/helper_service.dart';
import 'package:qchat/core/init/utils/utils.dart';
import 'package:qchat/view/home/chat/chat_page.dart';

class SearchChatListPage extends StatefulWidget {
  const SearchChatListPage({Key? key}) : super(key: key);

  @override
  _SearchChatListPageState createState() => _SearchChatListPageState();
}

class _SearchChatListPageState extends State<SearchChatListPage> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  bool isFound = true;
  final TextEditingController _search = TextEditingController();
  FocusNode? _searchFocus;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future onSearch() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
          isFound = true;
        });
      } else {
        setState(() {
          isFound = false;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? HelperService().loadingCircleForFB()
          : Column(
              children: [
                SizedBox(
                  height: context.veryhighValue,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextFormFieldWidget(
                    autofocus: true,
                    hintText: "Search",
                    initialValue: "",
                    controller: _search,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => {},
                    focusNode: _searchFocus,
                    onFieldSubmitted: (p0) {},
                    onSaved: (value) => {},
                    validate: (p0) {},
                    readOnly: false,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                CustomElevatedButton(
                  width: 50,
                  btnColor: AppColors.primary,
                  btnFunction: onSearch,
                  text: "Search",
                ),
                isFound
                    ? userMap != null
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: ListTile(
                              onTap: () {
                                String roomId = chatRoomId(
                                    _auth.currentUser!.uid, userMap!['fbUid']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        myId: _auth.currentUser!.uid,
                                        chatRoomId: roomId,
                                        userMap: userMap)));
                              },
                              title: CustomTextWidget(
                                text: userMap!['name'],
                                textStyle: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w800,
                                ).normalStyle,
                                textAlign: TextAlign.left,
                              ),
                              subtitle: CustomTextWidget(
                                text: userMap!['email'],
                                textStyle: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w400,
                                ).smallStyle,
                                textAlign: TextAlign.left,
                              ),
                              trailing: const Icon(
                                Icons.chat,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Container()
                    : Container(
                        padding: EdgeInsets.all(20),
                        child: CustomTextWidget(
                          text: 'No User Found',
                          textStyle: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w400,
                          ).smallStyle,
                          textAlign: TextAlign.left,
                        ),
                      )
              ],
            ),
    );
  }
}
