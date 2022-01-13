import 'package:qchat/core/constants/app/app_constants.dart';

class CustomValidator {
  String? authUserNameorEmailValidate(String value) {
    return value.isEmpty ? "Please enter username or e-mail" : null;
  }

  String? passwordValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Lütfen şifrenizi girin.";
    } else if (value.length < 6) {
      return "Şifreniz en az 6 karaker uzunluğunda olmalıdır.";
    } else {
      return null;
    }
  }

  String? nickNameValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Lütfen rumuz girin.";
    } else if (value.length < 3) {
      return "Rumuzunuz en az 3 karaker uzunluğunda olmalıdır.";
    } else {
      return null;
    }
  }

  String? emailValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Lütfen e-posta adresinizi girin";
    } else if (!RegExp(ApplicationConstants.instance!.eMailRegEx)
        .hasMatch(value)) {
      return "Lütfen geçerli bir e-posta adresi girin.";
    }
    {
      return null;
    }
  }

  String? codeValidate(String value, String code) {
    if (value == "" || value.isEmpty) {
      return null;
    } else if (value != code) {
      return "Geçersiz doğrulama kodu.";
    } else {
      return null;
    }
  }

  String? newPasswordValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Lütfen yeni şifre girin.";
    } else if (value.length < 6) {
      return "Şifreniz en az 6 karaker uzunluğunda olmalıdır.";
    } else {
      return null;
    }
  }

  String? newPasswordAgaingValidate(String value, String text) {
    if (value == "" || value.isEmpty) {
      return "Şifre tekrar alanı boş bırakılamaz.";
    } else if (value != text) {
      return "Yeni şifre tekrarı ile aynı olmalıdır.";
    } else {
      return null;
    }
  }

  String? currentPasswordValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Lütfen şifrenizi girin.";
    } else {
      return null;
    }
  }

  String? emtyValidate(String value) {
    if (value == "" || value.isEmpty) {
      return "Lütfen boş bırakmayınız.";
    } else {
      return null;
    }
  }
}
