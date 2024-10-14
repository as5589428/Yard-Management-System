import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode

class SignupScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create an Account',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            _buildTextField('Name', _nameController),
            SizedBox(height: 20),
            _buildTextField('User ID', _userIdController),
            SizedBox(height: 20),
            _buildTextField('Password', _passwordController, obscureText: true),
            SizedBox(height: 20),
            _buildTextField('Address', _addressController),
            SizedBox(height: 20),
            _buildTextField('Pincode', _pincodeController),
            SizedBox(height: 30),
            _buildSignupButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final name = _nameController.text;
        final userid = _userIdController.text;
        final password = _passwordController.text;
        final address = _addressController.text;
        final pincode = _pincodeController.text;

        try {
          final response = await http.post(
            Uri.parse('http://192.168.0.194:5000/register'), // Replace with your API URL
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'userid': userid,
              'password': password,
              'address': address,
              'pincode': pincode,
            }),
          );

          if (response.statusCode == 201) { // Check for successful registration (status 201)
            // Signup successful
            _showCustomSnackBar(context, 'Sign Up Successful!', Colors.amber);
            Navigator.pop(context);
          } else {
            final errorResponse = json.decode(response.body);
            _showCustomSnackBar(
              context,
              'Signup failed: ${errorResponse['message'] ?? 'Try again.'}',
              Colors.red,
            );
          }
        } catch (e) {
          _showCustomSnackBar(context, 'Signup failed: ${e.toString()}', Colors.red);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text('SIGN UP'),
    );
  }

  void _showCustomSnackBar(BuildContext context, String message, Color bgColor) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(fontSize: 20)), // Increase font size
      backgroundColor: bgColor,
      duration: Duration(seconds: 3), // Adjust duration as needed
      behavior: SnackBarBehavior.floating, // Makes the SnackBar bigger
      margin: EdgeInsets.all(16), // Add margin for spacing
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
