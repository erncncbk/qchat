import 'package:get_it/get_it.dart';
import 'package:qchat/core/init/services/storage_service.dart';
import 'package:qchat/core/provider/app_state/app_state_provider.dart';

GetIt locator = GetIt.instance;

///Projede kullanılan veya kullanılacak Service, Provider ve Repository'lerin
///proje başlatıldığında ayağa kaldırılmasını sağlar.
void setupLocator() {
  //*Providers
  locator.registerLazySingleton(() => AppStateProvider());

  locator.registerLazySingleton(() => StorageService());
  // locator.registerLazySingleton(() => WidgetService());
}
