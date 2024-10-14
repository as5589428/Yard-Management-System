import 'package:flutter/material.dart';

class ExitVehicleDetailsForm extends StatefulWidget {
  @override
  _ExitVehicleDetailsFormState createState() => _ExitVehicleDetailsFormState();
}

class _ExitVehicleDetailsFormState extends State<ExitVehicleDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final _customerNameController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _chassisNumberController = TextEditingController();
  final _colorController = TextEditingController();
  final _vehicleClassController = TextEditingController();
  final _vehicleConditionController = TextEditingController();
  final _keyLocationController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _remarksController = TextEditingController();

  // List of checklist items with a selected value to track "Yes" or "No"
  final List<Map<String, dynamic>> checklistItems = [
    {"label": "Key", "value": null},
    {"label": "Light", "value": null},
    {"label": "Horns", "value": null},
    {"label": "Wiper Blade", "value": null},
    {"label": "Back Wiper", "value": null},
    {"label": "Music System", "value": null},
    {"label": "Roast Light", "value": null},
    {"label": "Speaker", "value": null},
    {"label": "Roof Light", "value": null},
    {"label": "Fan", "value": null},
    {"label": "Rear View", "value": null},
    {"label": "Door Mirror", "value": null},
    {"label": "Sun Visor", "value": null},
    {"label": "Rain Visor", "value": null},
    {"label": "Fuel Cap", "value": null},
    {"label": "Battery Make", "value": null},
    {"label": "Battery", "value": null},
    {"label": "Door Handle", "value": null},
    {"label": "Door Glass", "value": null},
    {"label": "Stepney", "value": null},
    {"label": "Jack", "value": null},
    {"label": "Jack Rod", "value": null},
    {"label": "Wheel Spanner", "value": null},
    {"label": "Tool", "value": null},
    {"label": "Rope", "value": null},
    {"label": "Tarpaulin", "value": null},
    {"label": "Cultivator", "value": null},
    {"label": "Tyre", "value": null},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exit Vehicle Details"),
        backgroundColor: Colors.red[200], // Light red color
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

                // Loop through checklist items and display them with Yes/No radio buttons
                Column(
                  children: checklistItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          // Checklist Label
                          Expanded(
                            flex: 2,
                            child: Text(item["label"], style: TextStyle(fontSize: 16)),
                          ),
                          // "No" option as a radio button
                          Flexible(
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: item["value"],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      item["value"] = value;
                                    });
                                  },
                                ),
                                Text("No"),
                              ],
                            ),
                          ),
                          // "Yes" option as a radio button
                          Flexible(
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: item["value"],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      item["value"] = value;
                                    });
                                  },
                                ),
                                Text("Yes"),
                              ],
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
                        // Implement navigation or form submission logic here
                      }
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200], // Light red color for the button
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
