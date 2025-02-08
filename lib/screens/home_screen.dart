import 'package:ein_ecommerce/blocs/app_connection_bloc/app_connection_bloc.dart';
import 'package:ein_ecommerce/constants/app_colors.dart';
import 'package:ein_ecommerce/screens/cart_screen.dart';
import 'package:ein_ecommerce/screens/chat_screen.dart';
import 'package:ein_ecommerce/screens/dashboard_screen.dart';
import 'package:ein_ecommerce/screens/setting_screen.dart';
import 'package:ein_ecommerce/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Map<String, bool> isFirstInit = {
    'Dashboard': true,
    'Chat': true,
    'Cart': true,
    'Transaction': true,
    'Setting': true,
  };

  void _onItemTapped(int index) {
    if (index == 2 && isFirstInit['Cart'] == true) {
      isFirstInit['Cart'] = false;
      context.read<AppConnectionBloc>().add(InitAppConnectionEvent());
    }
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppConnectionBloc, AppConnectionState>(
      builder: (context, state) => Scaffold(
        body: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: const <Widget>[
                DashboardPage(),
                ChatPage(),
                CartPage(),
                TransactionPage(),
                SettingPage(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: state is ConnectedState
            ? Container(
                child: _buildBottomNavigationBar(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, -3), // Shadow ke atas
          ),
        ],
      ),
      child: BottomNavigationBarTheme(
        data: BottomNavigationBarThemeData(
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          fixedColor: AppColors.primary,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false, // Sembunyikan label saat item dipilih
          showUnselectedLabels: false, // Sembunyikan label saat item tidak dipilih
          iconSize: 25,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.chat, 'Chat', 1),
            _buildNavItem(Icons.shopping_cart, 'Cart', 2),
            _buildNavItem(Icons.list_alt, 'Transaction', 3),
            _buildNavItem(Icons.person, 'Account', 4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedIndex == index ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 4),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
