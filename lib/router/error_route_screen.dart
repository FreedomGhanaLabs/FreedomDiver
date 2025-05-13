import 'package:flutter/material.dart';

class ErrorRouteScreen extends StatelessWidget {
  const ErrorRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go to home page'),
        ),
      ),
    );
  }
}
