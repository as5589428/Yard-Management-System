import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/photo_entry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../../api_Service/api_service.dart';
class VehicleDetailsForm extends StatefulWidget {
    // final ApiService apiService = ApiService();
  final ApiService apiService = ApiService();
  
  @override
  _VehicleDetailsFormState createState() => _VehicleDetailsFormState();
  
}

class _VehicleDetailsFormState extends State<VehicleDetailsForm> {

  final _formKey = GlobalKey<FormState>();

  // String uniqueId = '';
  // bool showError = false;
  // String errorMessage = '';
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();
  final TextEditingController _chassisNumberController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _vehicleClassController = TextEditingController();
  final TextEditingController _vehicleConditionController = TextEditingController();
  final TextEditingController _keyLocationController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  // Checklist items remain the same
  final List<Map<String, dynamic>> checklistItems = [
    {"label": "Key", "icon": Icons.key, "yes": false, "no": false},
    {"label": "Light", "icon": Icons.lightbulb, "yes": false, "no": false},
    {"label": "Horns", "icon": Icons.volume_up, "yes": false, "no": false},
    {"label": "Music System", "icon": Icons.music_note, "yes": false, "no": false},
    {"label": "Roast Light", "icon": Icons.highlight, "yes": false, "no": false},
    {"label": "Speaker", "icon": Icons.speaker, "yes": false, "no": false},
    {"label": "Roof Light", "icon": Icons.roofing, "yes": false, "no": false},
    {"label": "Fan", "icon": Icons.air, "yes": false, "no": false},
    {"label": "Rear View", "icon": Icons.visibility, "yes": false, "no": false},
    {"label": "Door Mirror", "icon": Icons.flip_to_back, "yes": false, "no": false},
    {"label": "Sun Visor", "icon": Icons.wb_sunny, "yes": false, "no": false},
    {"label": "Rain Visor", "icon": Icons.umbrella, "yes": false, "no": false},
    {"label": "Fuel Cap", "icon": Icons.local_gas_station, "yes": false, "no": false},
    {"label": "Battery Make", "icon": Icons.battery_full, "yes": false, "no": false},
    {"label": "Battery", "icon": Icons.battery_charging_full, "yes": false, "no": false},
    {"label": "Door Handle", "icon": Icons.door_sliding, "yes": false, "no": false},
    {"label": "Door Glass", "icon": Icons.window, "yes": false, "no": false},
    {"label": "Stepney", "icon": Icons.tire_repair, "yes": false, "no": false},
    {"label": "Jack", "icon": Icons.car_repair, "yes": false, "no": false},
    {"label": "Jack Rod", "icon": Icons.straighten, "yes": false, "no": false},
    {"label": "Wheel Spanner", "icon": Icons.build, "yes": false, "no": false},
    {"label": "Tool", "icon": Icons.handyman, "yes": false, "no": false},
    {"label": "Rope", "icon": Icons.linear_scale, "yes": false, "no": false},
    {"label": "Tarpaulin", "icon": Icons.layers, "yes": false, "no": false},
    {"label": "Cultivator", "icon": Icons.agriculture, "yes": false, "no": false},
    {"label": "Tyre", "icon": Icons.tire_repair, "yes": false, "no": false},
  ];

  // Function to show the SnackBar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vehicle Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[300],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[300]!, Colors.white],
            stops: [0.0, 0.3],
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
                  _buildSectionTitle("Basic Information"),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTextField("Customer Name", _customerNameController, Icons.person),
                          _buildTextField("Engine Number", _engineNumberController, Icons.engineering),
                          _buildTextField("Chassis Number", _chassisNumberController, Icons.confirmation_number),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  _buildSectionTitle("Vehicle Specifications"),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTextField("Color", _colorController, Icons.color_lens),
                          _buildTextField("Vehicle Class", _vehicleClassController, Icons.category),
                          _buildTextField("Vehicle Condition", _vehicleConditionController, Icons.car_repair),
                          _buildTextField("Key Location", _keyLocationController, Icons.location_on),
                          _buildTextField("Transmission", _transmissionController, Icons.settings),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildSectionTitle("Remarks"),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildTextField("Additional Notes", _remarksController, Icons.note_add, maxLines: 3),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Checklist Section (kept as is)
                  _buildSectionTitle("Checklist"),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: checklistItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Icon(item["icon"], size: 24, color: Colors.grey[600]),
                                SizedBox(width: 10),
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
                    ),
                  ),

                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
             onPressed: () async {
  if (_formKey.currentState!.validate()) {
    
       SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Collecting form data (e.g. customer details)
      String clientName = prefs.getString('clientName') ?? '';
      String agreementNumber = prefs.getString('agreementNumber') ?? '';
      String make = prefs.getString('make') ?? '';
      String model = prefs.getString('model') ?? '';
      String variant = prefs.getString('variant') ?? '';
      String refNo = prefs.getString('refNo') ?? '';
      String segment = prefs.getString('segment') ?? '';
         String loanNo = prefs.getString('loanNo') ?? '';
      String geoLocation = prefs.getString('geoLocation') ?? '';
      String inwardDateTime = prefs.getString('inwardDateTime') ?? '';
      String fuelType = prefs.getString('fuelType') ?? '';
      String odometerReading = prefs.getString('odometerReading') ?? '';
      String yard = prefs.getString('yard') ?? '';
      
      // Collecting additional form data (e.g. vehicle details)
      String customerName = _customerNameController.text;
      String engineNumber = _engineNumberController.text;
      String chassisNumber = _chassisNumberController.text;
      String color = _colorController.text;
      String vehicleClass = _vehicleClassController.text;
      String vehicleCondition = _vehicleConditionController.text;
      String keyLocation = _keyLocationController.text;
      String transmission = _transmissionController.text;
      String remarks = _remarksController.text;

      // Prepare the body for the API request
      // Construct the JSON body
      var body = jsonEncode({
        "clientName": clientName,
        "agreementNumber": agreementNumber,
        "make": make,
        "model": model,
        "variant": variant,
        "refNo": refNo,
        "segment": segment,
        "loanNo": loanNo,
        "fuelType": fuelType,
        "odometerReading": odometerReading,
        "yard": yard,
        "inwardDateTime": inwardDateTime,
        "geoLocation": geoLocation,
        "vehicleDetails": {  
          "customerName": customerName,
          "engineNumber": engineNumber,
          "chassisNumber": chassisNumber,
          "color": color, 
          "vehicleClass": vehicleClass,
          "vehicleCondition": vehicleCondition,
          "keyLocation": keyLocation,
          "transmission": transmission,
          "remarks": remarks
        },
        "checklist": [
          { "label": "Key", "yes": true, "no": false },
          { "label": "Light", "yes": false, "no": true },
          { "label": "Horns", "yes": true, "no": false },
          { "label": "Wiper Blade", "yes": false, "no": true },
          { "label": "Back Wiper", "yes": true, "no": false },
          { "label": "Music System", "yes": true, "no": false },
          { "label": "Roast Light", "yes": false, "no": true },
          { "label": "Speaker", "yes": true, "no": false },
          { "label": "Roof Light", "yes": false, "no": true },
          { "label": "Fan", "yes": true, "no": false },
          { "label": "Rear View", "yes": false, "no": true },
          { "label": "Door Mirror", "yes": true, "no": false },
          { "label": "Sun Visor", "yes": false, "no": true },
          { "label": "Rain Visor", "yes": true, "no": false },
          { "label": "Fuel Cap", "yes": false, "no": true },
          { "label": "Battery Make", "yes": true, "no": false },
          { "label": "Battery", "yes": false, "no": true },
          { "label": "Door Handle", "yes": true, "no": false },
          { "label": "Door Glass", "yes": false, "no": true },
          { "label": "Stepney", "yes": true, "no": false },
          { "label": "Jack", "yes": false, "no": true },
          { "label": "Jack Rod", "yes": true, "no": false },
          { "label": "Wheel Spanner", "yes": false, "no": true },
          { "label": "Tool", "yes": true, "no": false },
          { "label": "Rope", "yes": false, "no": true },
          { "label": "Tarpaulin", "yes": true, "no": false },
          { "label": "Cultivator", "yes": false, "no": true },
          { "label": "Tyre", "yes": true, "no": false }
        ]
      });

      // Send the API request
      var url = Uri.parse('http://192.168.0.194:5000/api/inward');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Debug the response 
      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.body}');

      // Handle API response
       // Handle API response
// Handle API response
if (response.statusCode == 201) {
  
  // Parse the response to get the uniqueId
  var responseData = jsonDecode(response.body);
  String uniqueId = responseData['data']?['uniqueId'] ?? 'Unknown'; // Ensure uniqueId is checked for null
  // Now, pass the uniqueId to the photo upload API 
     // Store the uniqueId in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uniqueId', uniqueId);
  // Hide any existing banner before showing a new one
  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

  // Show the banner with the unique ID
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      backgroundColor: const Color.fromARGB(255, 154, 28, 28), // Changed banner color to green
      content: Text(
        'Form Unique ID is: $uniqueId',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Remove the banner when dismissed
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

            // Show loader after the banner is dismissed
            showDialog(
              context: context,
              barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );

            // Simulate a delay to show the loader, then navigate to the next screen
            Future.delayed(Duration(seconds: 2), () {
              // Dismiss the loader dialog
              Navigator.of(context).pop();

              // Navigate to PhotoEntryPage for photo upload
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoEntryPage(),
                ),
              );

              // Show a success message after navigating
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Form saved successfully')),
              );
            });
          },
          child: Text(
            'Next',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
} else {
  // Error response from API
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to save form: ${response.body}')),
  );
}
} catch (error) {
  // Error handling
  log('Error: $error');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('An error occurred: $error')),
  );
}
}},

                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text(
                          
                          
                          'Continue to Photos',
                          
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        
                        shape: RoundedRectangleBorder(
                          
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green[400]!),
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.grey[600]),
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