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
  Widget? _bottomNavigationBar;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConnectionBloc, AppConnectionState>(
      listener: (context, state) {
        if (state is ConnectedState) {
          showBottomNavBar();
        } else {
          hideBottomNavBar();
        }
      },
      child: Scaffold(
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
          bottomNavigationBar: _bottomNavigationBar),
    );
  }

  void hideBottomNavBar() {
    setState(() {
      _bottomNavigationBar = null;
    });
  }

  void showBottomNavBar() {
    setState(() {
      _bottomNavigationBar = Container(
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
    });
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
