import 'package:ein_ecommerce/blocs/app_connection_bloc/app_connection_bloc.dart';
import 'package:ein_ecommerce/components/buttons/primary_button.dart';
import 'package:ein_ecommerce/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorScreen extends StatefulWidget {
  final String errorType;

  const ErrorScreen({
    super.key,
    required this.errorType,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/error.webp',
              width: 300,
            ),
            const SizedBox(height: 16),
            Text(
              widget.errorType,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 36),
            PrimaryButton(
              text: 'Retry',
              onPressed: () {
                context.read<AppConnectionBloc>().add(CheckAppConnectionEvent());
              },
              backgroundColor: AppColors.primary,
              icon: Icons.refresh,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
            ),
          ],
        ),
      ),
    );
  }
}
