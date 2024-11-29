import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/photo_entry.dart';

class VahanDetailsForm extends StatefulWidget {
  @override
  _VahanDetailsFormState createState() => _VahanDetailsFormState();
}

class _VahanDetailsFormState extends State<VahanDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vahan Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Help'),
                  content: Text('Fill in the vehicle details from VAHAN portal. All fields are mandatory.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      "Owner Information",
                      [
                        _buildTextField("Owner Name*", prefixIcon: Icons.person),
                        _buildTextField("Present Address*", prefixIcon: Icons.location_on, maxLines: 2),
                        _buildTextField("Permanent Address*", prefixIcon: Icons.home, maxLines: 2),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Financier*", prefixIcon: Icons.account_balance),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Insurer*", prefixIcon: Icons.security),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildSection(
                      "Registration Details",
                      [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Registration Number*", prefixIcon: Icons.pin),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Registration Date*", prefixIcon: Icons.calendar_today),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Registered RTO*", prefixIcon: Icons.location_city),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("RC Status*", prefixIcon: Icons.verified),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Owner Serial Number*", prefixIcon: Icons.format_list_numbered),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Manufacturing Date*", prefixIcon: Icons.date_range),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildSection(
                      "Vehicle Details",
                      [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Vehicle Make*", prefixIcon: Icons.directions_car),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Vehicle Model*", prefixIcon: Icons.car_repair),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Color*", prefixIcon: Icons.color_lens),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Fuel Type*", prefixIcon: Icons.local_gas_station),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Chassis Number*", prefixIcon: Icons.confirmation_number),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Engine Number*", prefixIcon: Icons.engineering),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Vehicle Category*", prefixIcon: Icons.category),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Body Type*", prefixIcon: Icons.directions_car_filled),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildSection(
                      "Validity Information",
                      [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("RC Fitness Validity*", prefixIcon: Icons.verified_user),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("RC Tax Validity*", prefixIcon: Icons.receipt_long),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Insurance Policy Number*", prefixIcon: Icons.policy),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Insurance Validity*", prefixIcon: Icons.security),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Permit Valid From*", prefixIcon: Icons.date_range),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField("Permit Valid Upto*", prefixIcon: Icons.event),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PhotoEntryPage()),
                            );
                          }
                        },
                        icon: Icon(Icons.camera_alt),
                        label: Text(
                          'Continue to Photo Upload',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.blue[300]) : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${label.replaceAll('*', '')}';
          }
          return null;
        },
      ),
    );
  }
}