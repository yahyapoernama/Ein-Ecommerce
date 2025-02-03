import 'package:ein_ecommerce/screens/auth/login_screen.dart';
import 'package:ein_ecommerce/screens/auth/register_screen.dart';
import 'package:ein_ecommerce/screens/home_screen.dart';
import 'package:ein_ecommerce/screens/not_found_screen.dart';
import 'package:ein_ecommerce/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen()); // 404 Page
    }
  }
}
