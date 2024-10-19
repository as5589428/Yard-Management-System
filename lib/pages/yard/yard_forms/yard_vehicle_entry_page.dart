import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vehicle_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class VehicleRegistrationForm extends StatefulWidget {
  @override
  _VehicleRegistrationFormState createState() =>
      _VehicleRegistrationFormState();
}

class _VehicleRegistrationFormState extends State<VehicleRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final _clientNameController = TextEditingController();
  final _agreementNumberController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _variantController = TextEditingController();
  final _refNoController = TextEditingController();
  final _segmentController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _repoDateController = TextEditingController();
  final _loanNoController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _odometerReadingController = TextEditingController();
  final _yardController = TextEditingController();
  final _inwardDateTimeController = TextEditingController();
  final _geoLocationController = TextEditingController();

  String? _selectedFuelType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadSavedForm();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _geoLocationController.text =
          'Lat: ${position.latitude}, Long: ${position.longitude}';
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
          _inwardDateTimeController.text =
              '${_selectedDate!.toLocal().toString().split(' ')[0]} ${_selectedTime!.format(context)}';
        });
      }
    }
  }

  Future<void> _saveForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('clientName', _clientNameController.text);
    await prefs.setString('agreementNumber', _agreementNumberController.text);
    await prefs.setString('make', _makeController.text);
    await prefs.setString('model', _modelController.text);
    await prefs.setString('variant', _variantController.text);
    await prefs.setString('refNo', _refNoController.text);
    await prefs.setString('segment', _segmentController.text);
    await prefs.setString('geoLocation', _geoLocationController.text);
    await prefs.setString('inwardDateTime', _inwardDateTimeController.text);

  // Now send data to Node.js API
  var url = Uri.parse('http://192.168.0.194:5000/api/inward');
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'clientName': _clientNameController.text,
      'agreementNumber': _agreementNumberController.text,
      'make': _makeController.text,
      'model': _modelController.text,
      'variant': _variantController.text,
      'refNo': _refNoController.text,
      'segment': _segmentController.text,
      'geoLocation': _geoLocationController.text,
      'inwardDateTime': _inwardDateTimeController.text,
      'loanNo': _loanNoController.text,
      'fuelType': _selectedFuelType,
      'odometerReading': _odometerReadingController.text,
      'yard': _yardController.text,
    }),
  );

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form saved successfully')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save form')),
    );
  }
}

  Future<void> _loadSavedForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _clientNameController.text = prefs.getString('clientName') ?? '';
      _agreementNumberController.text = prefs.getString('agreementNumber') ?? '';
      _makeController.text = prefs.getString('make') ?? '';
      _modelController.text = prefs.getString('model') ?? '';
      _variantController.text = prefs.getString('variant') ?? '';
      _refNoController.text = prefs.getString('refNo') ?? '';
      _segmentController.text = prefs.getString('segment') ?? '';
      _geoLocationController.text = prefs.getString('geoLocation') ?? '';
      _inwardDateTimeController.text = prefs.getString('inwardDateTime') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle Registration"),
        backgroundColor: Colors.green[400],
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Client Information"),
                _buildTextField("Client Name", _clientNameController),
                _buildTextField("Agreement Number", _agreementNumberController),
                
                _buildSectionHeader("Vehicle Details"),
                _buildTextField("Make", _makeController),
                _buildTextField("Model", _modelController),
                _buildTextField("Variant", _variantController),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Ref.No.", _refNoController)),
                    SizedBox(width: 10),
                    Expanded(child: _buildTextField("Segment", _segmentController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Loan No", _loanNoController)),
                    SizedBox(width: 10),
                    Expanded(child: _buildFuelTypeDropdown()),
                  ],
                ),
                _buildTextField("Odometer Reading", _odometerReadingController),
                _buildTextField("Yard", _yardController),
                
                _buildSectionHeader("Other Information"),
                GestureDetector(
                  onTap: () => _selectDateTime(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      "Inward Date & Time",
                      _inwardDateTimeController,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Geo Location", _geoLocationController)),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _getCurrentLocation,
                      child: Text("Allow Location"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VehicleDetailsForm()),
                        );
                      }
                    },
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                     
                      backgroundColor: Colors.green,
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

  Widget _buildFuelTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFuelType,
      items: [
        'Petrol',
        'Diesel',
        'CNG',
        'LPG',
        'Ethanol',
        'Hybrids',
        'EV'
      ].map((fuelType) {
        return DropdownMenuItem(
          value: fuelType,
          child: Text(fuelType),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Fuel Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          _selectedFuelType = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a fuel type';
        }
        return null;
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        ),
      ),
    );
  }
}