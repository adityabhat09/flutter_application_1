import 'package:flutter/material.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Removed 'const' here
        title: const Text('Trends'),
      ),
      body: const Center(
        child: Text('Trends Screen Content'),
      ),
    );
  }
}