import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/constants/navigation/navigation_constant.dart';
import 'package:qchat/core/extensions/context_extension.dart';
import 'package:qchat/core/extensions/string_extension.dart';
import 'package:qchat/core/init/navigation/navigation_service.dart';
import 'package:qchat/core/init/services/storage_service.dart';
import 'package:qchat/core/provider/app_state/app_state_provider.dart';
import 'package:qchat/locator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final StorageService? _storageService = locator<StorageService>();
  final AppStateProvider? _appStateProvider = locator<AppStateProvider>();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addObserver();
    checkReadOnlyAsync(context);
  }

  Future checkReadOnlyAsync(BuildContext context) async {
    ///Kullanıcı bilgilerini çeker. Sayfa açılışında istekte bulunur
    NavigationService navigation = NavigationService.instance;

    await _storageService!.getTokenAsync().then((value) async {
      if (value != null) {
        /// Set Token
        _appStateProvider!.setToken(value);
        Future.delayed(const Duration(seconds: 2), () {
          navigation.navigateToPageClear(
            path: NavigationConstants.homePage,
          );
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          navigation.navigateToPageClear(
            path: NavigationConstants.loginPage,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        padding: context.paddingZero,
        width: context.width,
        height: context.height,
        // color: AppColors.wasabi,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.white),
        child: Stack(
          children: [
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                child: SvgPicture.asset(
                  "5".toSVG,
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: CustomTextWidget(
                text: 'Q Chat',
                textStyle: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ).extraStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
