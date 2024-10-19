import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Finance/login/Dashboard/finance_dashboard.dart';
import 'package:flutter_application_1/pages/Finance/login/Signup/finance_employee_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import to decode JSON responses


class FinanceLogin extends StatelessWidget {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Login'),
        backgroundColor: const Color(0xFFE1A522),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Finance Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE1A522),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField('User ID', _userIdController, Icons.person),
            const SizedBox(height: 16),
            _buildTextField('Password', _passwordController, Icons.lock,
                isPassword: true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _handleLogin(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE1A522),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  _handleForgotPassword(context);
                },
                child: const Text(
                  'Forgotten password?',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  _handleSignUp(context);
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    final userId = _userIdController.text;
    final password = _passwordController.text;

    // Basic validation
    if (userId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both User ID and Password')),
      );
      return;
    }

    // Call the login API
    final url ='http://192.168.0.194:5000/finance/login'; // Replace with your actual API endpoint
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': userId, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        // Save the token if needed and navigate to the Finance Dashboard
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FinanceDashboard()),
        );
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _handleForgotPassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Forgotten password feature not implemented yet.')),
    );
  }

  void _handleSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FinanceEmployeeLogin()),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE1A522)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFE1A522), width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
