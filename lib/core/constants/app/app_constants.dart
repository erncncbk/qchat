class ApplicationConstants {
  static ApplicationConstants? _instance;
  static ApplicationConstants? get instance {
    _instance ??= ApplicationConstants._init();
    return _instance;
  }

  ApplicationConstants._init();
  static const LANG_ASSET_PATH = 'asset/lang';
  static const IPAD_NAME = 'IPAD';
  static const FONT_FAMILY = 'POPPINS';
  static const COMPANY_NAME = 'HWA';
  // ignore: constant_identifier_names
  static const int RESENDCODETIME = 120;

  String get eMailRegEx =>
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static const APP_WEB_SITE =
      'https://github.com/VB10/flutter-architecture-template';
}

class Constant {
  // gecici image listesi
  static const IMAGE_LIST = [
    'assets/images/building.png',
    'assets/images/modern-business-center.png',
    'assets/images/modern-business-center.png',
    'assets/images/modern-business-center.png',
    'assets/images/modern-business-center.png'
  ];

  static const String userToken = "UserToken";
  static const String userPassword = "UserPassword";

  static const String userSecret = "UserSecret";
  static const String userID = "UserId";
  static const String userName = "UserName";
  static const String userEmail = "UserEmail";
  static const String accountTypeId = "AccountTypeId";

  static const String firstApp = "FirstApp";
}
