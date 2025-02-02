import 'package:ein_ecommerce/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:ein_ecommerce/screens/auth/login_screen.dart';
import 'package:ein_ecommerce/screens/auth/register_screen.dart';
import 'package:ein_ecommerce/screens/home_screen.dart';
import 'package:ein_ecommerce/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('appBox');

  final appBox = Hive.box('appBox');
  final isFirstLaunch = appBox.get('isFirstLaunch', defaultValue: true);
  final isLoggedIn = appBox.get('user') != null ? true : false;

  runApp(MyApp(
    isFirstLaunch: isFirstLaunch,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isFirstLaunch,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TransactionBloc()),
      ],
      child: MaterialApp(
        title: 'Ein Ecommerce',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
        ),
        initialRoute: isFirstLaunch ? '/onboarding' : isLoggedIn ? '/home' : '/login',
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
