import 'package:flutter/material.dart';
import '../login/login_page.dart'; // Import the login page
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding JSON
import 'package:lottie/lottie.dart'; // Import the lottie package

class SignUpPage extends StatelessWidget {
  final _parkingNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController(); // Added password controller

  final String apiUrl = "http://192.168.0.194:5000/yardowner/register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yard Owner Sign-Up"),
        backgroundColor: Colors.lightGreen[400] ?? Colors.lightGreen,
        elevation: 1,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightGreen.shade300, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Register Your Yard",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 5, 10, 5),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Please fill in the details below to create your yard owner account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 105, 103, 103),
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField("Parking Name", _parkingNameController, Icons.local_parking),
                _buildTextField("Contact Person Name", _contactPersonController, Icons.person),
                _buildTextField("State", _stateController, Icons.map),
                _buildTextField("District", _districtController, Icons.location_city),
                _buildTextField("City", _cityController, Icons.location_on),
                _buildTextField("Pincode", _pincodeController, Icons.pin_drop, isNumeric: true),
                _buildTextField("Phone Number", _phoneController, Icons.phone, isNumeric: true),
                _buildTextField("Email", _emailController, Icons.email),
                _buildTextField("Password", _passwordController, Icons.lock, isPassword: true),
                _buildTextField("Address", _addressController, Icons.home, maxLines: 3),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    _registerYardOwner(context); // Call the registration function
                  },
                  child: Text("Verify via OTP"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[400] ?? Colors.lightGreen,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool isNumeric = false, bool isPassword = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        obscureText: isPassword, // Added for password fields
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.lightGreen[400] ?? Colors.lightGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.lightGreen[400] ?? Colors.lightGreen),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.lightGreen[700] ?? Colors.lightGreen, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
      ),
    );
  }

  Future<void> _registerYardOwner(BuildContext context) async {
    // Check if all fields are filled
    if (_parkingNameController.text.isEmpty || 
        _contactPersonController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _districtController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _pincodeController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields!'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit if validation fails
    }

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


    // Prepare the data to be sent to the API
    Map<String, String> requestData = {
      'yardname': _parkingNameController.text.trim(),
      'contact_person': _contactPersonController.text.trim(),
      'state': _stateController.text.trim(),
      'district': _districtController.text.trim(),
      'city': _cityController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'address': _addressController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      // Remove loading indicator
      Navigator.of(context).pop();

      // Handle the response
      if (response.statusCode == 201) {
        // If successful, show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registered successfully! Now you can log in.'),
            backgroundColor: Colors.green, // Green SnackBar for success
          ),
        );

        // Redirect to login page after a short delay
        Future.delayed(Duration(seconds: 0), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to login page
          );
        });
      } else {
        // Extract and log the error message from the response
        String errorMessage;
        try {
          var responseJson = json.decode(response.body);
          errorMessage = responseJson['message'] ?? 'Registration failed! Please try again.';
        } catch (e) {
          errorMessage = 'Registration failed! Please try again.';
        }

        // Show error SnackBar with the actual error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red, // Red SnackBar for failure
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      // Print any exceptions that might have occurred
      print("Exception: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred! Please try again.'),
          backgroundColor: Colors.red, // Red SnackBar for failure
        ),
      );
    }
  }
}
