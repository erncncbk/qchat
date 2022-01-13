import 'package:qchat/core/constants/app/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  /// Aydıt belleğindeki uygulama ile ilgili bilgileri temizler.
  /// Token, secret, userFullName, phoneNumber bilgileri temizlenir.
  Future<void> clearStorageAsync() async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    instances.remove(Constant.userToken);
    instances.clear();
  }

  ///Bellekten Kullanıcı Token bilgilerini alır.
  Future<String?> getTokenAsync() async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    String? stringValue = instances.getString(Constant.userToken);
    return stringValue;
  }

  ///Belleğe Kullanıcı Token bilgilerini atar.
  Future<void> setTokenAsync(String token) async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    instances.setString(Constant.userToken, token);
  }

  ///Kullanıcı Token'ının var olup olmadığını kontrol eder.
  Future<bool> userTokenDoesExist() async {
    String? token = await getTokenAsync();
    return token != null;
  }
}
