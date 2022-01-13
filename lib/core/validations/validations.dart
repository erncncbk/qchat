import 'package:qchat/core/constants/app/app_constants.dart';

class CustomValidator {
  String? passwordValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Please enter password";
    } else if (value.length < 6) {
      return "Your password must be at least 6 characters.";
    } else {
      return null;
    }
  }

  String? nickNameValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Please enter your name";
    } else if (value.length < 3) {
      return "Your name must be at least 3 characters.";
    } else {
      return null;
    }
  }

  String? emailValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Please enter valid e-mail ";
    } else if (!RegExp(ApplicationConstants.instance!.eMailRegEx)
        .hasMatch(value)) {
      return "This email is not valid.";
    }
    {
      return null;
    }
  }
}
