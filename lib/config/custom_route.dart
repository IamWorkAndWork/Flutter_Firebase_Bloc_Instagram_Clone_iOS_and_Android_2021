import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print("Route app = ${settings.name}");
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const Scaffold(),
          settings: const RouteSettings(name: '/'),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: const Center(
          child: Text("Sonething went wring!"),
        ),
      ),
    );
  }
}
