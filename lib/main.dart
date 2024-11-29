import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/profile/profile_yard_owner.dart';
import 'welcome_screen.dart'; // Import the WelcomeScreen
// import ''; // Import the ProfileYardOwner screen

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
      initialRoute: '/welcome', // Set WelcomeScreen as the initial route
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/profile': (context) => ProfileYardOwner(), // Define ProfileYardOwner route
      },
    );
  }
}
