import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppStateGetterAndSetter with ChangeNotifier {
//* objects
  ///
  ///

  /// User Informations
  String? _token;
  String? _userId;
  String? _accountTypeId;
  String? _userName;
  String? _userEmail;
  String? _appPassword;
  String? _againAppPaswword;
  String? _storageAppPassword;
  /// Chat
  String? _message = "";
  bool _isExtendIconsAnimate = false;
  bool _isExpandedMessage = false;
  Map<String, dynamic>? _userMap;
  String? _chatRoomId;
  bool _isTextFieldOnTap = false;

//* getters
//

  String? get getAppPassword => _appPassword;
  String? get getAgainAppPassword => _againAppPaswword;
  String? get getStorageAppPassword => _storageAppPassword;

  /// User Informations

  String? get getToken => _token;
  String? get getUserId => _userId;
  String? get getAccountTypeId => _accountTypeId;
  String? get getUserName => _userName;
  String? get getUserEmail => _userEmail;

  ///

  /// Chat

  String? get getMessage => _message;
  bool get getIsExtendIconsAnimate => _isExtendIconsAnimate;
  bool get getIsExpandedMessage => _isExpandedMessage;
  Map<String, dynamic>? get getUserMap => _userMap;
  String? get getChatRoomId => _chatRoomId;
  bool get getIsTextFieldOnTap => _isTextFieldOnTap;


//*setters
//



  void setToken(String? message) {
    _token = message;
  }



  void clearToken() {
    _token = null;
  }

  /// Chat
  /// set chat message from textfield
  void setMessage(String value, {bool isNotifier = true}) {
    _message = value;
    if (isNotifier) notifyListeners();
  }

  /// set chat ıcons animate
  void setIsExtendIconsAnimate(bool value, {bool isNotifier = true}) {
    _isExtendIconsAnimate = value;
    if (isNotifier) notifyListeners();
  }

  /// set chat expanded message view
  void setIsExpandedMessage(bool value, {bool isNotifier = true}) {
    _isExpandedMessage = value;
    if (isNotifier) notifyListeners();
  }

  /// set userMap
  void setUserMap(Map<String, dynamic>? value, {bool isNotifier = true}) {
    _userMap = value;
    if (isNotifier) notifyListeners();
  }

  /// set chatRoomId
  void setChatRoomId(String? value, {bool isNotifier = true}) {
    _chatRoomId = value;
    if (isNotifier) notifyListeners();
  }

  /// set chat ıcons animate
  void setIsTextFieldOnTap(bool value, {bool isNotifier = true}) {
    _isTextFieldOnTap = value;
    if (isNotifier) notifyListeners();
  }

  
}
