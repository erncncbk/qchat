import 'package:flutter/material.dart';
import 'package:qchat/core/init/theme/app_theme.dart';

class AppThemeLight extends AppTheme {
  static AppThemeLight? _instance;
  static AppThemeLight? get instance {
    _instance ??= AppThemeLight._init();
    return _instance;
  }

  AppThemeLight._init();
  @override
  ThemeData get theme => ThemeData.light();
}
