class ApplicationConstants {
  static ApplicationConstants? _instance;
  static ApplicationConstants? get instance {
    _instance ??= ApplicationConstants._init();
    return _instance;
  }

  ApplicationConstants._init();
  static const COMPANY_NAME = 'quicks';

  String get eMailRegEx =>
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static const CREATOR_WEB_SITE = 'https://erncncbk.github.io/';
}

class Constant {
  static const String userToken = "UserToken";
}
