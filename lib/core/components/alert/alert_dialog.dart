import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/extensions/string_extension.dart';

void showAlertDialog(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(content: Text(msg));
      });
}

void showAlertDialogWOptions(
    BuildContext context, String title, String msg, VoidCallback? function) {
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
          CupertinoDialogAction(
            textStyle: TextStyle(color: Colors.red),
            isDefaultAction: true,
            onPressed: function,
            child: Text(
              title,
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      );
    },
  );
}
