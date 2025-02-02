import 'package:ein_ecommerce/screens/cart_screen.dart';
import 'package:ein_ecommerce/screens/chat_screen.dart';
import 'package:ein_ecommerce/screens/dashboard_screen.dart';
import 'package:ein_ecommerce/screens/setting_screen.dart';
import 'package:ein_ecommerce/screens/transaction_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(0), child: Container()),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
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
      bottomNavigationBar: Container(
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
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          fixedColor: Colors.orange[400],
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false, // Sembunyikan label saat item dipilih
          showUnselectedLabels: false, // Sembunyikan label saat item tidak dipilih
          iconSize: 25,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}