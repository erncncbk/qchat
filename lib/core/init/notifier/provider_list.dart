import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:qchat/core/init/navigation/navigation_service.dart';
import 'package:qchat/core/provider/app_state/app_state_provider.dart';
import 'package:qchat/locator.dart';

class AppProvider {
  static AppProvider? _instance;
  static AppProvider? get instance {
    _instance ??= AppProvider._init();
    return _instance;
  }

  AppProvider._init();
  List<SingleChildWidget> singleItem = [];
  List<SingleChildWidget> dependItem = [
    ChangeNotifierProvider(create: (context) => locator<AppStateProvider>()),
    Provider.value(value: NavigationService.instance)
  ];
  List<SingleChildWidget> uiChangesItem = [];
}
