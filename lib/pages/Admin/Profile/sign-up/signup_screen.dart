import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2196F3), // Blue background color
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/logo-white.jpg', width: 80, height: 80),
                ),
                SizedBox(height: 20),
                Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTextField('Name', _nameController, Icons.person),
                        SizedBox(height: 16),
                        _buildTextField('User ID', _userIdController, Icons.account_circle),
                        SizedBox(height: 16),
                        _buildTextField('Password', _passwordController, Icons.lock, obscureText: true),
                        SizedBox(height: 16),
                        _buildTextField('Address', _addressController, Icons.home),
                        SizedBox(height: 16),
                        _buildTextField('Pincode', _pincodeController, Icons.location_on),
                        SizedBox(height: 24),
                        _buildSignupButton(context),
                      ],
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

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, {bool obscureText = false}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Color(0xFF2196F3)),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.grey, // Border color when not focused
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Color(0xFF2196F3), // Border color when focused
          width: 2.0,
        ),
      ),
    ),
  );
}

  Widget _buildSignupButton(BuildContext context) {
  return SizedBox(
    width: double.infinity, // Makes the button take full width of its parent
    child: ElevatedButton(
      onPressed: () => _handleSignup(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2196F3),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'SIGN UP',
        style: TextStyle(fontSize: 16, color: Colors.white), // Text color set to white
      ),
    ),
  );
}


  void _handleSignup(BuildContext context) async {
    // ... (keep the existing signup logic)
  }

  void _showCustomSnackBar(BuildContext context, String message, Color bgColor) {
    // ... (keep the existing snackbar logic)
  }
}