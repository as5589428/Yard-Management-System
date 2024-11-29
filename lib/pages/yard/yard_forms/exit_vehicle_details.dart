import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/photo_exit.dart';

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

  final List<Map<String, dynamic>> checklistItems = [
    {"label": "Key", "value": null, "icon": Icons.vpn_key},
    {"label": "Light", "value": null, "icon": Icons.lightbulb},
    {"label": "Horns", "value": null, "icon": Icons.volume_up},
    {"label": "Music System", "value": null, "icon": Icons.music_note},
    {"label": "Roast Light", "value": null, "icon": Icons.highlight},
    {"label": "Speaker", "value": null, "icon": Icons.speaker},
    {"label": "Roof Light", "value": null, "icon": Icons.light},
    {"label": "Fan", "value": null, "icon": Icons.air},
    {"label": "Rear View", "value": null, "icon": Icons.visibility},
    {"label": "Sun Visor", "value": null, "icon": Icons.wb_sunny},
    {"label": "Rain Visor", "value": null, "icon": Icons.umbrella},
    {"label": "Fuel Cap", "value": null, "icon": Icons.local_gas_station},
    {"label": "Battery Make", "value": null, "icon": Icons.battery_full},
    {"label": "Battery", "value": null, "icon": Icons.battery_std},
    {"label": "Door Handle", "value": null, "icon": Icons.door_sliding},
    {"label": "Door Glass", "value": null, "icon": Icons.window},
    {"label": "Stepney", "value": null, "icon": Icons.tire_repair},
    {"label": "Jack", "value": null, "icon": Icons.car_repair},
    {"label": "Jack Rod", "value": null, "icon": Icons.straighten},
    {"label": "Wheel Spanner", "value": null, "icon": Icons.build},
    {"label": "Tool", "value": null, "icon": Icons.handyman},
    {"label": "Rope", "value": null, "icon": Icons.cable},
    {"label": "Tarpaulin", "value": null, "icon": Icons.layers},
    {"label": "Cultivator", "value": null, "icon": Icons.agriculture},
    {"label": "Tyre", "value": null, "icon": Icons.tire_repair},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Exit Vehicle Details",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red[300],
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Help'),
                  content: Text('Fill in the vehicle exit details and complete the checklist. All fields are mandatory.'),
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
            colors: [Colors.red[50]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    "Vehicle Information",
                    [
                      _buildTextField(
                        "Customer Name*",
                        _customerNameController,
                        prefixIcon: Icons.person,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              "Engine Number*",
                              _engineNumberController,
                              prefixIcon: Icons.engineering,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              "Chassis Number*",
                              _chassisNumberController,
                              prefixIcon: Icons.confirmation_number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              "Color*",
                              _colorController,
                              prefixIcon: Icons.color_lens,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              "Vehicle Class*",
                              _vehicleClassController,
                              prefixIcon: Icons.category,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        "Vehicle Condition*",
                        _vehicleConditionController,
                        prefixIcon: Icons.car_repair,
                      ),
                      _buildTextField(
                        "Transmission*",
                        _transmissionController,
                        prefixIcon: Icons.settings,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildSection(
                    "Remarks",
                    [
                      _buildTextField(
                        "Additional Notes",
                        _remarksController,
                        maxLines: 3,
                        prefixIcon: Icons.note,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildSection(
                    "Vehicle Checklist",
                    [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: checklistItems.map((item) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: Icon(item["icon"], color: Colors.red[300]),
                                title: Text(
                                  item["label"],
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<bool>(
                                      value: false,
                                      groupValue: item["value"],
                                      onChanged: (value) {
                                        setState(() => item["value"] = value);
                                      },
                                      activeColor: Colors.red[300],
                                    ),
                                    Text("No"),
                                    Radio<bool>(
                                      value: true,
                                      groupValue: item["value"],
                                      onChanged: (value) {
                                        setState(() => item["value"] = value);
                                      },
                                      activeColor: Colors.red[300],
                                    ),
                                    Text("Yes"),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
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
                            MaterialPageRoute(
                              builder: (context) => PhotoExitPage(),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.camera_alt),
                      label: Text(
                        'Continue to Photo Upload',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
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
                color: Colors.red[700],
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
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.red[300]) : null,
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