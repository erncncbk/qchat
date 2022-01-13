import 'package:qchat/core/constants/app/app_constants.dart';
import 'package:qchat/core/provider/app_state/app_state_provider.dart';
import 'package:qchat/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final AppStateProvider? _appStateProvider = locator<AppStateProvider>();

  /// Aydıt belleğindeki uygulama ile ilgili bilgileri temizler.
  /// Token, secret, userFullName, phoneNumber bilgileri temizlenir.
  Future<bool> clearStorageAsync() async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    instances.remove(Constant.userToken);
    _appStateProvider!.clearToken();
    instances.clear();

    return true;
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
