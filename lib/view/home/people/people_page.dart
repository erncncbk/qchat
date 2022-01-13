import 'package:flutter/material.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/extensions/string_extension.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: CustomTextWidget(
        text: 'Friends',
        textStyle: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w800,
        ).normalStyle,
        textAlign: TextAlign.center,
      ),
    ));
  }
}
