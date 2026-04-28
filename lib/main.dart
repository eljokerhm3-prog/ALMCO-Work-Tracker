import 'package:flutter/material.dart';

void main() {
  runApp(const ALMCOApp());
}

class ALMCOApp extends StatelessWidget {
  const ALMCOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALMCO Work Tracker',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALMCO Work Tracker'),
      ),
      body: const Center(
        child: Text(
          'ALMCO Work Tracker\nApp is working ✅',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
