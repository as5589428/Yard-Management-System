import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import 'package:lottie/lottie.dart'; // Import Lottie
import '../Dashboard/yard_management_dashboard.dart'; // Your dashboard screen
import '../sign-up/signup_screen.dart'; // Your signup screen
import '../../../../api_Service/shared_preference.dart'; // Import your SharedPreferenceManager

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo-dark.jpg', // Your logo path
                    height: 120,
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Admin Login',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign in to access your account',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildUserIdTF(),
                        SizedBox(height: 20.0),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                        SizedBox(height: 20.0),
                        _buildLoginBtn(),
                        _buildSignupLink(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fullscreen loading animation
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8), // Slightly transparent background
              child: Center(
                child: Lottie.asset(
                  'assets/car_loading.json', // Add your Lottie file here
                  width: 200,
                  height: 200,
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.blue[50],
    );
  }

  Widget _buildUserIdTF() {
    return TextFormField(
      controller: _userIdController,
      keyboardType: TextInputType.text, // Change to text if user ID is alphanumeric
      decoration: InputDecoration(
        hintText: 'User ID',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.person_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your User ID';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordTF() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Forgot password functionality not implemented yet')),
          );
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text('LOGIN', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSignupLink(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupScreen()),
          );
        },
        child: Text(
          "Don't have an account? Sign Up",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userid = _userIdController.text;
      final password = _passwordController.text;

      try {
        final response = await http.post(
          Uri.parse('http://192.168.0.194:5000/login'), // Replace with your API URL
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'userid': userid,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final token = jsonResponse['token'];

          if (token != null) {
            // Save the token and user ID in shared preferences
            await SharedPreferenceManager().saveUserDetails(token, userid);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Successful')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => YardManagementApp()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: Token not received')),
            );
          }
        } else {
          final errorResponse = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${errorResponse['message'] ?? 'Incorrect credentials.'}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
