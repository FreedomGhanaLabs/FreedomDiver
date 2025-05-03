import 'package:flutter/material.dart';
import 'package:freedom_driver/app/view/app.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';

class CustomErrorScreen extends StatelessWidget {
  const CustomErrorScreen({required this.errorDetails, super.key});
  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
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
                  onPressed: () => runApp(const App()),
                  title: 'Restart App',
                  padding: const EdgeInsets.symmetric(
                    vertical: smallWhiteSpace,
                    horizontal: whiteSpace,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
