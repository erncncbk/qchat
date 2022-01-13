import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBCloudStore {
  static FBCloudStore get instance => FBCloudStore();

  Future<void> updateMyChatListValues(
      String documentID, String chatID, bool isInRoom) async {
    var updateData =
        isInRoom ? {'inRoom': isInRoom, 'badgeCount': 0} : {'inRoom': isInRoom};
    final DocumentReference result = FirebaseFirestore.instance
        .collection('users')
        .doc(documentID)
        .collection('chatlist')
        .doc(chatID);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(result);
      if (!snapshot.exists) {
        transaction.set(result, updateData);
      } else {
        transaction.update(result, updateData);
      }
    });
    int? unReadMSGCount =
        await FBCloudStore.instance.getUnreadMSGCount(documentID);
    if (!kIsWeb) {
      FlutterAppBadger.updateBadgeCount(unReadMSGCount!);
    }
  }

  Future<void> updateUserToken(userID, token) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'FCMToken': token,
    });
  }

  Future<List<DocumentSnapshot>> takeUserInformationFromFBDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('FCMToken', isEqualTo: prefs.get('FCMToken') ?? 'None')
        .get();
    return result.docs;
  }

  Future<int?> getUnreadMSGCount(String peerUserID) async {
    try {
      int? unReadMSGCount = 0;
      QuerySnapshot? userChatList = await FirebaseFirestore.instance
          .collection('users')
          .doc(peerUserID)
          .collection('chatlist')
          .get();
      List<QueryDocumentSnapshot>? chatListDocuments = userChatList.docs;
      for (QueryDocumentSnapshot? snapshot in chatListDocuments) {
        unReadMSGCount = (unReadMSGCount! + snapshot!['badgeCount']) as int?;
      }
      print('unread MSG count is $unReadMSGCount');
      return unReadMSGCount;
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateUserChatListField(String documentID, String lastMessage, chatID,
      myID, selectedUserID) async {
    var userBadgeCount = 0;
    var isRoom = false;
    var data;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(documentID)
        .collection('chatlist')
        .doc(chatID)
        .get();

    if (userDoc.data() != null) {
      data = userDoc.data();
      isRoom = data!['inRoom'];
      if (userDoc != null && documentID != myID && !userDoc['inRoom']) {
        userBadgeCount = userDoc['badgeCount'];
        userBadgeCount++;
      }
    } else {
      userBadgeCount++;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(documentID)
        .collection('chatlist')
        .doc(chatID)
        .set({
      'chatID': chatID,
      'chatWith': documentID == myID ? selectedUserID : myID,
      'lastChat': lastMessage,
      'badgeCount': isRoom ? 0 : userBadgeCount,
      'inRoom': isRoom,
      'time': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future sendMessageToChatRoom(
      chatID, myID, selectedUserID, content, messageType) async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatID)
        .collection('chats')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'idFrom': myID,
      'idTo': selectedUserID,
      'time': FieldValue.serverTimestamp(),
      'message': content,
      'type': messageType,
      'isread': false,
    });
  }
}
