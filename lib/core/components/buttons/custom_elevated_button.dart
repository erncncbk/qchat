import 'package:flutter/material.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/extensions/string_extension.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton(
      {Key? key,
      this.btnFunction,
      this.text,
      this.btnColor,
      this.btnBorderColor,
      this.textColor,
      this.width,
      this.height,
      this.isSmall = false})
      : super(key: key);

  final VoidCallback? btnFunction;
  final String? text;
  final Color? btnColor;
  final Color? btnBorderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool? isSmall;
  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.btnFunction,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              width: widget.width, height: widget.height),
          child: Center(
            child: FittedBox(
                child: !widget.isSmall!
                    ? CustomTextWidget(
                        text: widget.text,
                        textStyle: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none,
                        ).mediumStyle,
                        textAlign: TextAlign.center,
                      )
                    : CustomTextWidget(
                        text: widget.text,
                        textStyle: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ).normalStyle,
                        textAlign: TextAlign.center,
                      )),
          ),
        ),
        style: widget.btnFunction != null
            ? ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                enableFeedback: false,
                onPrimary: Colors.white,
                onSurface: Colors.white,
                elevation: 0,
                primary: widget.btnColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                side: BorderSide(
                  color: widget.btnBorderColor ?? Colors.transparent,
                ))
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return widget.btnColor;
                } else if (states.contains(MaterialState.disabled)) {
                  return AppColors.primary.withOpacity(0.3);
                }
                return null;
              })));
  }
}
