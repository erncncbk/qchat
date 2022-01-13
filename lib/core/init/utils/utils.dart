import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String chatRoomId(myID, selectedUserID) {
  String chatID;
  if (myID.hashCode > selectedUserID.hashCode) {
    chatID = '$selectedUserID-$myID';
  } else {
    chatID = '$myID-$selectedUserID';
  }
  return chatID;
}

int countChatListUsers(myID, AsyncSnapshot<QuerySnapshot> snapshot) {
  int resultInt = snapshot.data!.docs.length;
  for (var data in snapshot.data!.docs) {
    if (data['fbUid'] == myID) {
      resultInt--;
    }
  }
  return resultInt;
}
