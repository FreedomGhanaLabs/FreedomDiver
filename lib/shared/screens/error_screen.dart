import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';

class CustomErrorScreen extends StatelessWidget {
  const CustomErrorScreen({required this.errorDetails, super.key});
  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
              const SizedBox(height: 16),
              const Text(
                'Oops! Something went wrong.',
                style: TextStyle(
                  fontSize: headingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: smallWhiteSpace),
              Text(
                errorDetails.exceptionAsString(),
                style: const TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: whiteSpace),
              SimpleButton(
                onPressed: () => Navigator.of(context).pop(),
                title: 'Retry',
                padding: const EdgeInsets.symmetric(
                  vertical: smallWhiteSpace,
                  horizontal: whiteSpace,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
