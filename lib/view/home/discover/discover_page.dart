import 'package:flutter/material.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/extensions/string_extension.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: CustomTextWidget(
        text: 'Discover',
        textStyle: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w800,
        ).normalStyle,
        textAlign: TextAlign.center,
      ),
    ));
  }
}
