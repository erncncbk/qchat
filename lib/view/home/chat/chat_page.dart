import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qchat/core/components/buttons/custom_elevated_button.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/extensions/string_extension.dart';
import 'package:qchat/core/init/navigation/navigation_service.dart';
import 'package:qchat/core/init/services/fb_store.dart';
import 'package:qchat/core/provider/app_state/app_state_provider.dart';
import 'package:qchat/view/home/chat/show_image.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic>? userMap;
  final String? chatRoomId;
  final String? myId;

  const ChatPage({Key? key, this.chatRoomId, this.userMap, this.myId})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController? _message = TextEditingController(text: null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ScrollController _controller = ScrollController(initialScrollOffset: 0);
  NavigationService navigation = NavigationService.instance;

  String messageType = 'text';

  // bool enableAnimate = false;
  // bool expandMessage = false;

  File? imageFile;

  final _formKey = GlobalKey<FormState>();

  final accountTypeId = 1;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState');
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          FBCloudStore.instance
              .updateMyChatListValues(widget.myId!, widget.chatRoomId!, true);
          print('AppLifecycleState.resumed');
          break;
        case AppLifecycleState.inactive:
          print('AppLifecycleState.inactive');
          FBCloudStore.instance
              .updateMyChatListValues(widget.myId!, widget.chatRoomId!, false);
          break;
        case AppLifecycleState.paused:
          print('AppLifecycleState.paused');
          FBCloudStore.instance
              .updateMyChatListValues(widget.myId!, widget.chatRoomId!, false);
          break;
        case AppLifecycleState.detached:
          // TODO: Handle this case.
          break;
      }
    });
  }

  @override
  void dispose() {
    FBCloudStore.instance
        .updateMyChatListValues(widget.myId!, widget.chatRoomId!, false);
    WidgetsBinding.instance!.removeObserver(this);
    _controller.dispose();
    _message!.dispose();
    super.dispose();
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) async {
      if (xFile != null) {
        imageFile = File(xFile.path);
        await uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;
    setState(() {
      messageType = 'image';
    });
    await _firestore
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "idTo": widget.userMap!['fbUid'],
      "idFrom": widget.myId,
      "message": "",
      "type": messageType,
      "time": FieldValue.serverTimestamp(),
      "isRead": "false",
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
    print(ref);
    try {
      var uploadTask = await ref.putFile(imageFile!);
      if (status == 1) {
        String imageUrl = await uploadTask.ref.getDownloadURL();
        _firestore
            .collection('chatroom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .doc(fileName)
            .update({"message": imageUrl});
        print(imageUrl);
      }
    } catch (error) {
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = 0;
      print(error);
    }
  }

  Future scrolledEnd() async {
    Timer(
      const Duration(milliseconds: 200),
      () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    FBCloudStore.instance
        .updateMyChatListValues(widget.myId!, widget.chatRoomId!, true);
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider _appStateProvider = Provider.of<AppStateProvider>(context);

    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Form(
          key: _formKey,
          child: !_appStateProvider.getIsExpandedMessage
              ? _body(_appStateProvider, size)
              : _expandedMessage(_appStateProvider, size),
        ));
  }

  Widget _body(AppStateProvider? _appStateProvider, Size size) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _appStateProvider!.setIsTextFieldOnTap(false);
      },
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              // height: size.height / 1.25,
              // width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    scrolledEnd();
                    return ListView.builder(
                      controller: _controller,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic>? data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>?;
                        if (data!['time'] != null) {
                          DateTime dt = (data['time'] as Timestamp).toDate();
                          var d24 = DateFormat('HH:mm')
                              .format(dt); // 31/12/2000, 22:00
                          // var day = DateFormat('EEEE').format(dt);
                          return messages(size, data, context, time: d24);
                        } else {
                          return messages(
                            size,
                            data,
                            context,
                          );
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          bottomMessageTextField(_appStateProvider, size),
        ],
      ),
    );
  }

  Widget _expandedMessage(AppStateProvider? _appStateProvider, Size size) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Center(
        child: Stack(
          children: [
            Positioned(
              top: 30,
              right: 0,
              child: Container(
                width: size.width,
                alignment: Alignment.topCenter,
                child: TextFormField(
                  onTap: () {
                    // scrolledEnd();
                  },
                  autofocus: true,
                  controller: _message,
                  // initialValue: _appStateProvider!.getMessage,
                  onChanged: (value) {
                    _appStateProvider!.setMessage(value);
                  },
                  onSaved: (value) {
                    _appStateProvider!.setMessage(value!);
                  },
                  onFieldSubmitted: (value) {
                    _appStateProvider!.setMessage(value);
                  },
                  style: TextStyle(
                    color: AppColors.black,
                  ).smallStyle,
                  cursorColor: AppColors.black,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                    hintText: _appStateProvider!.getMessage!.isNotEmpty
                        ? _appStateProvider.getMessage
                        : "Mesaj...",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      _appStateProvider.setIsExpandedMessage(false);
                      Timer(
                        const Duration(milliseconds: 100),
                        () => _controller
                            .jumpTo(_controller.position.maxScrollExtent),
                      );
                    },
                    icon: SvgPicture.asset(
                      "shrinkMessage".toSVG,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(
                    child: sendMessageButton(_appStateProvider),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, dynamic data, BuildContext context,
      {String? time}) {
    bool isOwn = data!['idFrom'] == widget.myId ? true : false;
    bool isText = data['type'].toString() == "text";
    bool isAdmin = data['idFrom'].toString() == "Remind";
    bool isUser = data['accountTypeId'] == "1";
    bool isTerapist = data['accountTypeId'] == "2";

    /// Mesajlar görüldüğü zaman isRead=true olur ve badge sıfırlanır.
    if (data is QueryDocumentSnapshot) {
      if (data['idTo'] == widget.myId && data['isread'] == false) {
        if (data.reference != null) {
          FirebaseFirestore.instance
              .runTransaction((Transaction myTransaction) async {
            myTransaction.update(data.reference, {'isread': true});
          });
        }
      }
    }
    // print(isOwn);
    return isText
        ? Container(
            child: isAdmin
                ? isUser
                    ? remindMessageWidget(
                        data['idFrom'], data['message'], time.toString())
                    : remindMessageWidget(
                        data['idFrom'], data['message'], time.toString())
                : isTerapist
                    ? remindMessageWidget(
                        data['idFrom'], data['message'], time.toString())
                    : Container(
                        alignment: isOwn
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        padding: isOwn
                            ? const EdgeInsets.only(left: 30)
                            : const EdgeInsets.only(right: 30),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: isOwn
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: isOwn
                                      ? AppColors.primary
                                      : AppColors.secondary.withOpacity(0.2)),
                              child: CustomTextWidget(
                                text: data['message'],
                                textStyle: TextStyle(
                                  color:
                                      isOwn ? AppColors.white : AppColors.black,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ).smallStyle,
                                textAlign: TextAlign.left,
                              ),

                              // Text(
                              //   data['message'],
                              //   style: const TextStyle(color: Colors.white),
                              // ),
                            ),
                            Container(
                              width: 45,
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    CustomTextWidget(
                                      text: time ?? "",
                                      textStyle: TextStyle(
                                        color: AppColors.secondary,
                                        decoration: TextDecoration.none,
                                      ).minStyle,
                                      textAlign: isOwn
                                          ? TextAlign.right
                                          : TextAlign.left,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.check,
                                      size: 14,
                                      color: AppColors.secondary,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          )

        /// Image
        : Container(
            width: size.width,
            alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowImage(imageUrl: data['message']))),
              child: Stack(
                children: [
                  Container(
                      width: size.width / 2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: data['message'] != ""
                          ? Container(
                              margin: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data['message'],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Container(
                                        width: size.width / 2,
                                        height: size.height / 3.5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary
                                              .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.primary),
                                          backgroundColor: AppColors.white,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(
                              width: size.width / 2,
                              height: size.height / 3.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                                backgroundColor: AppColors.white,
                              ),
                            )),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Text(
                      time ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget bottomMessageTextField(
      AppStateProvider? _appStateProvider, Size size) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: _appStateProvider!.getIsTextFieldOnTap
              ? 8
              :
              // Platform.isIOS
              //     ? 30
              //     :
              20),
      child: Center(
        child: Stack(
          children: [
            TextFormField(
              onTap: () {
                _appStateProvider.setIsTextFieldOnTap(true);
              },
              controller: _message,
              // initialValue: _appStateProvider!.getMessage,
              onChanged: (value) {
                _appStateProvider.setMessage(value);
              },
              onSaved: (value) {
                _appStateProvider.setMessage(value!);
              },
              style: TextStyle(
                color: AppColors.black,
              ).smallStyle,
              cursorColor: Colors.black,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.secondary.withOpacity(0.1),
                contentPadding: const EdgeInsets.only(
                  right: 80,
                  left: 50,
                  bottom: 20,
                  top: 20,
                ),
                hintText: _appStateProvider.getMessage!.isNotEmpty
                    ? _appStateProvider.getMessage
                    : "",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14)),
                // border: InputBorder.none,
              ),
            ),
            Positioned(
                bottom: 5,
                right: 0,
                child: Row(
                  children: [
                    _appStateProvider.getMessage!.isNotEmpty
                        ? sendMessageButton(_appStateProvider)
                        : !_appStateProvider.getIsExtendIconsAnimate
                            ? shrinkViewIcons(_appStateProvider)
                            : extendedViewIcons(_appStateProvider)
                  ],
                )),
            Positioned(
                bottom: 5,
                left: 0,
                child: !_appStateProvider.getIsExpandedMessage
                    ? IconButton(
                        onPressed: () {
                          _appStateProvider.setIsExpandedMessage(true);
                        },
                        icon: SvgPicture.asset(
                          "expandMessage".toSVG,
                          color: AppColors.primary,
                        ))
                    : Container())
          ],
        ),
      ),
    );
  }

  Widget sendMessageButton(AppStateProvider? _appStateProvider) {
    return CustomElevatedButton(
      width: 57,
      height: 36,
      btnBorderColor: Colors.transparent,
      btnColor: Colors.transparent,
      btnFunction: () {
        if (_appStateProvider!.getMessage!.isNotEmpty) {
          setState(() {
            messageType = 'text';
          });
          _handleSubmitted(_appStateProvider, _appStateProvider.getMessage!);
        } else {
          null;
        }
      },
      text: "Gönder",
      textColor: _appStateProvider!.getMessage!.isNotEmpty
          ? AppColors.primary
          : AppColors.primary.withOpacity(0.3),
    );
  }

  Widget remindMessageWidget(String sendby, String message, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          const Divider(
            height: 1,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextWidget(
            text: sendby,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ).smallStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextWidget(
              isTitleCase: false,
              text: message,
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ).smallStyle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextWidget(
            isTitleCase: false,
            text: time.toString(),
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ).smallStyle,
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  Widget shrinkViewIcons(AppStateProvider _appStateProvider) {
    return widget.userMap!['accountTypeId'] != "1"
        ? Row(
            children: [
              IconButton(
                onPressed: () {
                  _appStateProvider.setIsExtendIconsAnimate(true);
                },
                icon: SvgPicture.asset(
                  "extend".toSVG,
                  color: AppColors.primary,
                ),
              ),
            ],
          )
        : sendMessageButton(_appStateProvider);
  }

  Widget extendedViewIcons(AppStateProvider _appStateProvider) {
    return Row(
      children: [
        IconButton(
          onPressed: getImage,
          icon: SvgPicture.asset(
            "galery".toSVG,
            color: AppColors.primary,
          ),
        ),
        IconButton(
          onPressed: () {
            _appStateProvider.setIsExtendIconsAnimate(false);
          },
          icon: SvgPicture.asset(
            "discard".toSVG,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmitted(
      AppStateProvider? _appStateProvider, String text) async {
    try {
      _resetTextField(_appStateProvider);

      await FBCloudStore.instance.sendMessageToChatRoom(widget.chatRoomId,
          widget.myId, widget.userMap!['fbUid'], text, messageType);
      await FBCloudStore.instance.updateUserChatListField(
          widget.userMap!['fbUid'],
          messageType == 'text' ? text : '(Photo)',
          widget.chatRoomId,
          widget.myId,
          widget.userMap!['fbUid']);
      await FBCloudStore.instance.updateUserChatListField(
          widget.myId!,
          messageType == 'text' ? text : '(Photo)',
          widget.chatRoomId,
          widget.myId,
          widget.userMap!['fbUid']);
      _appStateProvider!.setIsExpandedMessage(false);
      _appStateProvider.setIsExtendIconsAnimate(false);
    } catch (e) {
      print('Error user information to database');
      _resetTextField(_appStateProvider);
    }
  }

  void _resetTextField(AppStateProvider? _appStateProvider) {
    _appStateProvider!.setMessage('');
    _message!.text = '';
  }
}
