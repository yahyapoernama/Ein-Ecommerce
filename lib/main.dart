import 'package:ein_ecommerce/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:ein_ecommerce/utils/color_helper.dart';
import 'package:ein_ecommerce/routes/app_router.dart';
import 'package:ein_ecommerce/routes/routes.dart';
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
          primarySwatch: createMaterialColor(Colors.grey[900]!),
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: isFirstLaunch ? Routes.onboarding : isLoggedIn ? Routes.home : Routes.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
