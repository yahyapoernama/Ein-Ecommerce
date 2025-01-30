import 'package:ein_ecommerce/screens/auth/login_screen.dart';
import 'package:ein_ecommerce/screens/auth/register_screen.dart';
import 'package:ein_ecommerce/screens/home_screen.dart';
import 'package:ein_ecommerce/screens/onboarding_screen.dart';
import 'package:ein_ecommerce/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('appBox');

  final appBox = Hive.box('appBox');
  final isFirstLaunch = appBox.get('isFirstLaunch', defaultValue: true);

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}


class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ein Ecommerce',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Poppins',
      ),
      // home: isFirstLaunch ? const OnboardingScreen() : RegisterScreen(),
      initialRoute: isFirstLaunch ? '/onboarding' : '/login',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/search') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        }
        return null;
      },
    );
  }
}