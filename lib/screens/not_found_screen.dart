import 'package:ein_ecommerce/components/buttons/primary_button.dart';
import 'package:ein_ecommerce/constants/app_colors.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404 Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/error.webp',
              width: 300,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Page not found',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 36),
            PrimaryButton(
              text: 'Go Back',
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: AppColors.primary,
              icon: Icons.arrow_back,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
            ),
          ],
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const Text('Oops! Page not found', style: TextStyle(fontSize: 20)),
      //       const SizedBox(height: 10),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pop(context); // Kembali ke halaman sebelumnya
      //         },
      //         child: const Text('Go Back'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}