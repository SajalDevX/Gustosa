import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../shared/config/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement logout logic here
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'You are successfully logged in.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement any additional functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Home screen button clicked!")),
                );
              },
              child: const Text('Click me'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle logout
  void _logout(BuildContext context) {
    Get.toNamed(AppRoutes.welcomeScreen);
  }
}
