import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAlertDialog(context, String msg) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(msg),
        );
      });
}
