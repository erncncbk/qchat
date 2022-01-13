import 'package:flutter/material.dart';

class HelperService {
  static BoxShadow boxShadow(
      {Color? color, double? blur, double? spread = 0, double? x, double? y}) {
    return BoxShadow(
      color: color!,
      blurRadius: blur!,
      spreadRadius: spread!,
      offset: Offset(x!, y!),
    );
  }

  Widget loadingCircleForFB() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
      color: Colors.white.withOpacity(0.7),
    );
  }
}
