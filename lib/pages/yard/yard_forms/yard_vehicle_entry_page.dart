import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vehicle_details.dart';

class VehicleRegistrationForm extends StatefulWidget {
  @override
  _VehicleRegistrationFormState createState() =>
      _VehicleRegistrationFormState();
}

class _VehicleRegistrationFormState extends State<VehicleRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final _clientNameController = TextEditingController();
  final _agreementNumberController = TextEditingController();
  final _makeModelController = TextEditingController();
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

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadSavedForm(); // Load form data if available
  }

  // Function to get the current location
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

  // Save the form data
  Future<void> _saveForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('clientName', _clientNameController.text);
    await prefs.setString('agreementNumber', _agreementNumberController.text);
    await prefs.setString('makeModel', _makeModelController.text);
    await prefs.setString('refNo', _refNoController.text);
    await prefs.setString('segment', _segmentController.text);
    await prefs.setString('geoLocation', _geoLocationController.text);
    await prefs.setString('inwardDateTime', _inwardDateTimeController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form saved successfully')),
    );
  }

  // Load the saved form data
  Future<void> _loadSavedForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _clientNameController.text = prefs.getString('clientName') ?? '';
      _agreementNumberController.text = prefs.getString('agreementNumber') ?? '';
      _makeModelController.text = prefs.getString('makeModel') ?? '';
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
        title: Text("Vehicle Registration Form"),
        backgroundColor: Colors.green[300],
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm, // Save form on pressing save icon
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
                Text(
                  "Make | Model | Variant | YOM",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildTextField("Client Name", _clientNameController),
                _buildTextField("Agreement Number", _agreementNumberController),
                _buildTextField("Make/Model/Variant", _makeModelController),
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
                    Expanded(child: _buildTextField("Client Name", _clientNameController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Fuel Type", _fuelTypeController)),
                    SizedBox(width: 10),
                    Expanded(child: _buildTextField("Odometer Reading", _odometerReadingController)),
                  ],
                ),
                _buildTextField("Yard", _yardController),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
}
