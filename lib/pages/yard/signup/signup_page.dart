import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/yard/login/otp_verification_page.dart';
import '../login/login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _parkingNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E88E5),
              Color(0xFF1565C0),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    _buildWelcomeSection(),
                    _buildFormSection(),
                    _buildImageUploadSection(),
                    _buildSubmitButton(context),
                    _buildLoginLink(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Aiyrat',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Register your yard and start managing your parking space efficiently',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputField(
            "Parking Name",
            _parkingNameController,
            Icons.local_parking,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter parking name' : null,
          ),
          _buildInputField(
            "Contact Person",
            _contactPersonController,
            Icons.person,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter contact person name' : null,
          ),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  "State",
                  _stateController,
                  Icons.map,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter state' : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  "District",
                  _districtController,
                  Icons.location_city,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter district' : null,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  "City",
                  _cityController,
                  Icons.location_on,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter city' : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  "Pincode",
                  _pincodeController,
                  Icons.pin_drop,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter pincode' : null,
                ),
              ),
            ],
          ),
          _buildInputField(
            "Phone Number",
            _phoneController,
            Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter phone number' : null,
          ),
          _buildInputField(
            "Email",
            _emailController,
            Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter email' : null,
          ),
          _buildInputField(
            "Password",
            _passwordController,
            Icons.lock,
            isPassword: true,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter password' : null,
          ),
          _buildInputField(
            "Address",
            _addressController,
            Icons.home,
            maxLines: 3,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter address' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload Photo",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _showImageSourceOptions();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: _selectedImage == null
                    ? Icon(Icons.camera_alt, color: Colors.grey, size: 40)
                    : Image.file(_selectedImage!, height: 100, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Upload from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Capture from Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    bool isPassword = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OTPVerificationPage()),
              );
            }
          },
          child: Text(
            'Register',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ", style: TextStyle(color: Colors.white)),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          ),
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
