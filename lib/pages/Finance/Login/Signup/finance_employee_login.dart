import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FinanceEmployeeLogin extends StatelessWidget {
  final TextEditingController _empCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Employee Login'),
        backgroundColor: const Color(0xFFE1A522),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Finance Employee Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE1A522),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Employee Code', _empCodeController),
              const SizedBox(height: 16),
              _buildTextField('Name', _nameController),
              const SizedBox(height: 16),
              _buildTextField('Designation', _designationController),
              const SizedBox(height: 16),
              _buildTextField('WhatsApp', _whatsappController),
              const SizedBox(height: 16),
              _buildTextField('Mobile', _mobileController),
              const SizedBox(height: 16),
              _buildTextField('Company Name', _companyNameController),
              const SizedBox(height: 16),
              _buildTextField('Username', _usernameController),
              const SizedBox(height: 16),
              _buildTextField('Password', _passwordController,
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
                    'Submit', // Changed the button text here
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
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    final empCode = _empCodeController.text;
    final name = _nameController.text;
    final designation = _designationController.text;
    final whatsapp = _whatsappController.text;
    final mobile = _mobileController.text;
    final companyName = _companyNameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter User ID and Password')),
      );
      return;
    }

    final url = 'https://yms-backend.onrender.com/finance/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'empCode': empCode,
          'name': name,
          'designation': designation,
          'whatsapp': whatsapp,
          'mobile': mobile,
          'companyName': companyName,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FinanceEmployeeLogin()),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFE1A522), width: 2.0),
        ),
      ),
    );
  }
}
