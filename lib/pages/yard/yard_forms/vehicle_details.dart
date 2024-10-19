import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/photo_entry.dart';

class VehicleDetailsForm extends StatefulWidget {
  @override
  _VehicleDetailsFormState createState() => _VehicleDetailsFormState();
}

class _VehicleDetailsFormState extends State<VehicleDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  // Add controllers for each vehicle details field
  final _customerNameController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _chassisNumberController = TextEditingController();
  final _colorController = TextEditingController();
  final _vehicleClassController = TextEditingController();
  final _vehicleConditionController = TextEditingController();
  final _keyLocationController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _remarksController = TextEditingController();

  // List of checklist items
  final List<Map<String, dynamic>> checklistItems = [
    {"label": "Key", "yes": false, "no": false},
    {"label": "Light", "yes": false, "no": false},
    {"label": "Horns", "yes": false, "no": false},
    {"label": "Wiper Blade", "yes": false, "no": false},
    {"label": "Back Wiper", "yes": false, "no": false},
    {"label": "Music System", "yes": false, "no": false},
    {"label": "Roast Light", "yes": false, "no": false},
    {"label": "Speaker", "yes": false, "no": false},
    {"label": "Roof Light", "yes": false, "no": false},
    {"label": "Fan", "yes": false, "no": false},
    {"label": "Rear View", "yes": false, "no": false},
    {"label": "Door Mirror", "yes": false, "no": false},
    {"label": "Sun Visor", "yes": false, "no": false},
    {"label": "Rain Visor", "yes": false, "no": false},
    {"label": "Fuel Cap", "yes": false, "no": false},
    {"label": "Battery Make", "yes": false, "no": false},
    {"label": "Battery", "yes": false, "no": false},
    {"label": "Door Handle", "yes": false, "no": false},
    {"label": "Door Glass", "yes": false, "no": false},
    {"label": "Stepney", "yes": false, "no": false},
    {"label": "Jack", "yes": false, "no": false},
    {"label": "Jack Rod", "yes": false, "no": false},
    {"label": "Wheel Spanner", "yes": false, "no": false},
    {"label": "Tool", "yes": false, "no": false},
    {"label": "Rope", "yes": false, "no": false},
    {"label": "Tarpaulin", "yes": false, "no": false},
    {"label": "Cultivator", "yes": false, "no": false},
    {"label": "Tyre", "yes": false, "no": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle Details"),
        backgroundColor: Colors.green[300], // Changed to green
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Customer Name", _customerNameController),
                _buildTextField("Engine Number", _engineNumberController),
                _buildTextField("Chassis Number", _chassisNumberController),
                _buildTextField("Color", _colorController),
                _buildTextField("Vehicle Class", _vehicleClassController),
                _buildTextField("Vehicle Condition", _vehicleConditionController),
                _buildTextField("Key Location", _keyLocationController),
                _buildTextField("Transmission", _transmissionController),
                SizedBox(height: 20),
                Text(
                  "REMARKS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildTextField("Remarks", _remarksController, maxLines: 3),
                SizedBox(height: 20),

                // Checklist Section
                Text(
                  "CHECKLIST",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                SizedBox(height: 10),

                // Loop through checklist items and display them with No/Yes icons
                Column(
                  children: checklistItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(item["label"], style: TextStyle(fontSize: 16)),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  item["no"] = true;
                                  item["yes"] = false;
                                });
                              },
                              child: Icon(
                                Icons.close,
                                color: item["no"] ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  item["yes"] = true;
                                  item["no"] = false;
                                });
                              },
                              child: Icon(
                                Icons.check,
                                color: item["yes"] ? Colors.green : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoEntryPage(),
                          ),
                        );
                      }
                    },
                    child: Text('Next', style: TextStyle(color: Colors.white)), // Changed text color to white
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 79, 238, 145), // Button background color can remain blue
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
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
