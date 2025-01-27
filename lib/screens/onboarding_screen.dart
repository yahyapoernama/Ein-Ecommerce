import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Daftar slide onboarding
  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to App',
      'description': 'This is the first slide of the onboarding screen.',
      'image': 'onboarding1.jpg',
    },
    {
      'title': 'Explore Features',
      'description': 'Discover all the amazing features of our app.',
      'image': 'onboarding2.jpg',
    },
    {
      'title': 'Stay Connected',
      'description': 'Connect with friends and family effortlessly.',
      'image': 'onboarding3.jpg',
    },
    {
      'title': 'Get Started',
      'description': 'Ready to start your journey? Let\'s go!',
      'image': 'onboarding4.jpg',
    },
  ];

  // Animasi fade in dari sisi kanan
  Widget _buildSlideAnimation(Widget child) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(_currentPage == _onboardingData.indexOf(_onboardingData[_currentPage]) ? 0 : 100, 0, 0),
      child: AnimatedOpacity(
        opacity: _currentPage == _onboardingData.indexOf(_onboardingData[_currentPage]) ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }

  // Indikator kustom yang bisa diklik
  Widget _buildCustomIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _onboardingData.asMap().entries.map((entry) {
        int index = entry.key;
        return GestureDetector(
          onTap: () {
            // Pindah ke slide yang sesuai saat indikator diklik
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: index == _currentPage ? 24 : 8, // Lebar silinder panjang untuk current index
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index == _currentPage ? Colors.orange[600] : Colors.grey,
              borderRadius: BorderRadius.circular(4), // Sudut melengkung untuk silinder
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Indikator
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: _buildCustomIndicator(),
          ),

          // Konten slide
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildSlideAnimation(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/onboarding/${_onboardingData[index]['image']}',
                        width: 300,
                        height: 300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _onboardingData[index]['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          _onboardingData[index]['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Tombol Previous dan Next
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Previous
                if (_currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange[600],
                      ),
                    ),
                  ),

                // Spacer untuk mengatur jarak
                const Spacer(),

                // Tombol Next atau Finish
                TextButton(
                  onPressed: () async {
                    if (_currentPage < _onboardingData.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Hive.openBox('appBox').then((box) {
                        // Simpan data ke box
                        box.put('isFirstLaunch', false).then((_) {
                          // Pastikan widget masih terpasang sebelum navigasi
                          if (mounted) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          }
                        });
                      });
                    }
                  },
                  child: Text(
                    _currentPage == _onboardingData.length - 1 ? 'Finish' : 'Next',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}