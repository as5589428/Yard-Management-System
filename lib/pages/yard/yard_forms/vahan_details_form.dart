import 'package:flutter/material.dart';

class VahanDetailsForm extends StatefulWidget {
  @override
  _VahanDetailsFormState createState() => _VahanDetailsFormState();
}

class _VahanDetailsFormState extends State<VahanDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VAHAN DETAILS', 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF1E88E5),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Owner Information'),
                  _buildTextField('Owner Name'),
                  _buildTextField('Present Address'),
                  _buildTextField('Permanent Address'),
                  _buildTextField('Financier'),
                  _buildTextField('Insurer'),
                  SizedBox(height: 24),

                  _buildSectionHeader('Vehicle Registration Details'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField('Registration Number'),
                            _buildTextField('Registered at RTO'),
                            _buildTextField('Owner Serial Number'),
                            _buildTextField('Vehicle Make'),
                            _buildTextField('Color'),
                            _buildTextField('Chassis Number'),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField('Registration Date'),
                            _buildTextField('RC Status'),
                            _buildTextField('Manufacturing Date'),
                            _buildTextField('Vehicle Model'),
                            _buildTextField('Fuel'),
                            _buildTextField('Fuel Norms'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  _buildSectionHeader('Additional Details'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField('Engine Number'),
                            _buildTextField('Vehicle Category'),
                            _buildTextField('Vehicle Class Description'),
                            _buildTextField('Body Type'),
                            _buildTextField('Mobile No'),
                            _buildTextField('Permit No'),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField('Engine Cubic Capacity'),
                            _buildTextField('NCRB Status'),
                            _buildTextField('Blacklist Status'),
                            _buildTextField('NOC Details'),
                            _buildTextField('Permit Issue Date'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  _buildSectionHeader('Validity Information'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField('RC Fitness Validity'),
                            _buildTextField('RC Tax Validity'),
                            _buildTextField('Insurance Policy Number'),
                            _buildTextField('Insurance Validity'),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField('Permit Valid from Date'),
                            _buildTextField('Permit Valid upto Date'),
                            _buildTextField('Permit Type'),
                            _buildTextField('RC Status as on'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data', 
                              style: TextStyle(color: Colors.white))),
                          );
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E88E5),
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Color(0xFF1E88E5), width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
        style: TextStyle(color: Colors.black87),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}