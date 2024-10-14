import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FinanceEmployeeLogin extends StatefulWidget {
  const FinanceEmployeeLogin({Key? key}) : super(key: key);

  @override
  _FinanceEmployeeLoginState createState() => _FinanceEmployeeLoginState();
}

class _FinanceEmployeeLoginState extends State<FinanceEmployeeLogin> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _empCodeController = TextEditingController();
  final _designationController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _mobileController = TextEditingController();
  String? _selectedState;
  String? _selectedCity;

  // List of all states in India
  final List<String> states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal', 'Delhi', 'Chandigarh',
  ];

  // Map of cities for specific states
  final Map<String, List<String>> cities = {
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior', 'Jabalpur'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Ghaziabad', 'Agra'],
    // Add other states and their respective cities
  };

  @override
  void dispose() {
    _firstNameController.dispose();
    _empCodeController.dispose();
    _designationController.dispose();
    _whatsappController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Employee Login'),
        backgroundColor: const Color(0xFFE1A522),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24.0),
                  _buildTextField('First Name', _firstNameController, Icons.person),
                  const SizedBox(height: 16.0),
                  _buildTextField('Employee Code', _empCodeController, Icons.badge),
                  const SizedBox(height: 16.0),
                  _buildTextField('Designation', _designationController, Icons.work),
                  const SizedBox(height: 16.0),
                  _buildStateDropdown(),
                  const SizedBox(height: 16.0),
                  _buildCityDropdown(),
                  const SizedBox(height: 16.0),
                  _buildTextField('WhatsApp Number', _whatsappController, Icons.wechat_sharp, isNumeric: true),
                  const SizedBox(height: 16.0),
                  _buildTextField('Mobile Number', _mobileController, Icons.phone, isNumeric: true),
                  const SizedBox(height: 24.0),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE1A522).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.account_balance, size: 48, color: Color(0xFFE1A522)),
            SizedBox(height: 8),
            Text(
              'Finance Employee Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE1A522),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
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

  Widget _buildStateDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select State',
        prefixIcon: const Icon(Icons.location_on, color: Color(0xFFE1A522)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFE1A522), width: 2.0),
        ),
      ),
      value: _selectedState,
      items: states.map((state) {
        return DropdownMenuItem<String>(
          value: state,
          child: Text(state),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedState = value;
          _selectedCity = null; // Reset city when state changes
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a state';
        }
        return null;
      },
    );
  }

  Widget _buildCityDropdown() {
    final citiesList = _selectedState != null ? cities[_selectedState!] : [];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select City',
        prefixIcon: const Icon(Icons.location_city, color: Color(0xFFE1A522)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFE1A522), width: 2.0),
        ),
      ),
      value: _selectedCity,
      items: citiesList?.map((city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a city';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Handle form submission
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form Submitted')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE1A522),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}