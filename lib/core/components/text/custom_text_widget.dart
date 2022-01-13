import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    Key? key,
    this.textAlign = TextAlign.center,
    this.text = "",
    this.isTitleCase = false,
    this.overflow = TextOverflow.visible,
    this.maxLines,
    this.textStyle,
  }) : super(key: key);
  final TextAlign? textAlign;
  final String? text;
  final TextStyle? textStyle;
  final bool? isTitleCase;
  final TextOverflow? overflow;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text!,
      overflow: overflow,
      maxLines: maxLines,
      style: textStyle,
      textAlign: textAlign,
    );
  }
}
