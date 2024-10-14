import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../panels/yard_panel_page.dart';
import '../signup/signup_page.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _yardNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Replace this URL with your backend login endpoint
  final String loginUrl = 'http://192.168.0.194:5000/yardowner/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yard Owner Login"),
        backgroundColor: Colors.green[400],
        elevation: 1,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[300]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 29, 29, 29),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Login to manage your yard",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildTextField(
                  label: "Yard Name",
                  controller: _yardNameController,
                  icon: Icons.home,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Password",
                  controller: _passwordController,
                  icon: Icons.lock,
                  isPassword: true,
                ),
                SizedBox(height: 30),
                _isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Lottie animation
                   
                          SizedBox(height: 10), // Space between animation and text
                          Text(
                            "Loading...",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 2, 96, 204),
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () => _handleLogin(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Handle forgotten password action
                  },
                  child: Text(
                    "Forgotten password?",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
    );
  }

  // Login function
  void _handleLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final yardName = _yardNameController.text.trim();
    final password = _passwordController.text.trim();


    if (yardName.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Please enter both yard name and password', Colors.red);
      setState(() {
        _isLoading = false;
      });
      return;
    }
  

    try {
      // Send login request
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'yardname': yardName,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the token from the response
        final responseData = json.decode(response.body);
        final token = responseData['token'];
// Show a loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: Lottie.asset('assets/car_loading.json')); // Ensure this path is correct
      },
    );
  // Wait for 2 seconds before proceeding
  await Future.delayed(Duration(seconds: 5));
        // Store token securely, then navigate to YardPanelPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => YardPanelPage()),
        );
      } else {
        _showSnackBar(context, 'Login failed. Please check your credentials.', Colors.red);
      }
    } catch (e) {
      _showSnackBar(context, 'An error occurred: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Snackbar to show messages
  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
