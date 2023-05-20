import 'package:flutter/material.dart';

import 'splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barterit',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            // Add any other desired text style properties
          ),
          // Define additional text styles as needed
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
