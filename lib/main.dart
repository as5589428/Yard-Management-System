import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Import the welcome screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
      ),
      
      home: WelcomeScreen(), // Use WelcomeScreen as the home widget
    );
  }
}
