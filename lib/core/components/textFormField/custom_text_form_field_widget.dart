import 'package:flutter/material.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/extensions/string_extension.dart';

class CustomTextFormFieldWidget extends StatefulWidget {
  const CustomTextFormFieldWidget(
      {Key? key,
      this.autovalidateMode,
      this.onFieldSubmitted,
      this.onSaved,
      this.validate,
      this.decoration,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.textInputAction = TextInputAction.next,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.initialValue,
      this.readOnly = false,
      this.textStyle,
      this.autofocus = false,
      this.maxLine = 1,
      this.minLine = 1,
      this.hintText = "",
      this.onTap})
      : super(key: key);
  final AutovalidateMode? autovalidateMode;
  final Function(String)? onFieldSubmitted;
  final Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final String? Function(String?)? validate;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final bool? obscureText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? initialValue;
  final bool? readOnly;
  final TextStyle? textStyle;
  final bool? autofocus;
  final int? maxLine;
  final int? minLine;
  final String? hintText;
  final VoidCallback? onTap;

  @override
  _CustomTextFormFieldWidgetState createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) {
      if (widget.controller!.text == "") {
        widget.controller!.text = widget.initialValue == "null"
            ? ""
            : widget.initialValue == null
                ? ""
                : widget.initialValue!;
      }
    }
    return TextFormField(
      onTap: widget.onTap,
      cursorColor: AppColors.secondary,
      maxLines: widget.maxLine,
      minLines: widget.minLine,
      autofocus: widget.autofocus!,
      controller: widget.controller,
      obscureText: widget.obscureText!,
      textAlign: TextAlign.start,
      style: widget.textStyle ?? TextStyle().smallStyle,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction!,
      decoration: widget.decoration ?? _inputDecoration(),
      onSaved: widget.onSaved!,
      onChanged: widget.onChanged!,
      initialValue: widget.controller == null ? widget.initialValue! : null,
      validator: widget.validate!,
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      fillColor: AppColors.black.withOpacity(0.1),
      contentPadding: new EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      filled: true,
      errorStyle: TextStyle(color: AppColors.red).smallStyle,
      errorMaxLines: 3,
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppColors.red, width: 1.0)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppColors.red, width: 1.0)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppColors.grey, width: 1.0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.grey, width: 2.0)),
      hintText: widget.hintText!,
      isDense: true,
      hintStyle: TextStyle(color: AppColors.secondary).smallStyle,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppColors.grey, width: 1.0)),
    );
  }
}
