import 'package:ein_ecommerce/screens/auth/login_screen.dart';
import 'package:ein_ecommerce/screens/auth/register_screen.dart';
import 'package:ein_ecommerce/screens/home_screen.dart';
import 'package:ein_ecommerce/screens/onboarding_screen.dart';
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
      initialRoute: isFirstLaunch ? '/onboarding' : '/register',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        // Tambahkan route lain di sini
      },
    );
  }
}