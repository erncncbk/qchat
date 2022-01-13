import 'package:flutter/material.dart';
import 'package:qchat/core/constants/navigation/navigation_constant.dart';
import 'package:qchat/view/authentication/forgot_password_page.dart';
import 'package:qchat/view/authentication/login_page.dart';
import 'package:qchat/view/authentication/register_page.dart';
import 'package:qchat/view/home/chat/search_chat_list_page.dart';
import 'package:qchat/view/home/home_page.dart';
import 'package:qchat/view/splash/splash_page.dart';

class NavigationRoute {
  static NavigationRoute? _instance;
  static NavigationRoute? get instance {
    _instance ??= NavigationRoute._init();
    return _instance;
  }

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.splashPage:
        return normalNavigate(const SplashPage());
      case NavigationConstants.loginPage:
        return normalNavigate(const LoginPage());
      case NavigationConstants.registerPage:
        return normalNavigate(const RegisterPage());
      case NavigationConstants.homePage:
        return normalNavigate(const HomePage());
      case NavigationConstants.searchChatListPage:
        return normalNavigate(const SearchChatListPage());
      case NavigationConstants.forgotPasswordPage:
        return normalNavigate(const ForgotPasswordPage());
      default:
        return MaterialPageRoute(builder: (context) => const LoginPage());
    }
  }

  MaterialPageRoute normalNavigate(
    Widget widget,
  ) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
