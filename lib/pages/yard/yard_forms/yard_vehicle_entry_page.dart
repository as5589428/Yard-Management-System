import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Admin/Profile/admin_profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vehicle_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/pages/Yard/panels/pending_vehicle_entry.dart';
import 'package:flutter_application_1/pages/Yard/yard_forms/yard_vehicle_exit.dart';
import '../yard_forms/yard_vehicle_entry_page.dart';
// import 'yard_vehicle_list_page.dart';
import '../panels/yard_vehicle_list_page.dart';
class VehicleRegistrationForm extends StatefulWidget {
  @override
  _VehicleRegistrationFormState createState() => _VehicleRegistrationFormState();
}

class _VehicleRegistrationFormState extends State<VehicleRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
// Set initial index to 'Pending Vehicles' tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle page switching based on the selected index
    switch (index) {
      case 0:
        // Navigate to YardPanelPage when Home is tapped
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => YardVehicleListPage()),
        );
        break;
      case 1:
        // Stay on the current page, as it's for "Pending Vehicles"
        break;
      case 2:
        // Navigate to a list page (You need to create this page)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => YardVehicleListPage()), // Add your ListPage
        );
        break;
      case 3:
        // Navigate to an exit page (You need to create this page)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VehicleExitForm()), // Add your ExitPage
        );
        break;
      case 4:
        // Navigate to a profile page (You need to create this page)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()), // Add your ProfilePage
        );
        break;
    }
  }
  // Controllers for text fields
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
        SnackBar(content: Text('Location services are disabled. Please enable them.')),
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
      _geoLocationController.text = 'Lat: ${position.latitude}, Long: ${position.longitude}';
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
          _inwardDateTimeController.text = '${_selectedDate!.toLocal().toString().split(' ')[0]} ${_selectedTime!.format(context)}';
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
      backgroundColor: Color(0xFFFDBB2D),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveForm,
        ),
      ],
    ),
    body: Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Client Information"),
                _buildLabeledTextField("Client Name", _clientNameController),
                _buildLabeledTextField("Agreement Number", _agreementNumberController),
                
                _buildSectionHeader("Vehicle Details"),
                _buildLabeledTextField("Make", _makeController),
                _buildLabeledTextField("Model", _modelController),
                _buildLabeledTextField("Variant", _variantController),
                Row(
                  children: [
                    Expanded(child: _buildLabeledTextField("Ref.No.", _refNoController)),
                    SizedBox(width: 10),
                    Expanded(child: _buildLabeledTextField("Segment", _segmentController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildLabeledTextField("Loan No", _loanNoController)),
                    SizedBox(width: 10),
                    Expanded(child: _buildLabeledFuelTypeDropdown()),
                  ],
                ),
                _buildLabeledTextField("Odometer Reading", _odometerReadingController),
                _buildLabeledTextField("Yard", _yardController),
                
                _buildSectionHeader("Other Information"),
                GestureDetector(
                  onTap: () => _selectDateTime(context),
                  child: AbsorbPointer(
                    child: _buildLabeledTextField(
                      "Inward Date & Time",
                      _inwardDateTimeController,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: _buildLabeledTextField("Geo Location", _geoLocationController)),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _getCurrentLocation,
                      child: Text("Allow Location"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFDBB2D),
                        foregroundColor: Colors.white,
                      ),
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
                          MaterialPageRoute(builder: (context) => VehicleDetailsForm()),
                        );
                      }
                    },
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFDBB2D),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: _buildAnimatedBottomNavigationBar (),
  );
}

Widget _buildLabeledTextField(String label, TextEditingController controller, {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    ),
  );
}

Widget _buildLabeledFuelTypeDropdown() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fuel Type',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
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
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[100],
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
        ),
      ],
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
        color: Colors.black,
      ),
    ),
  );
}

  Widget _buildAnimatedBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.home, 0),
            label: 'Home', // Changed from Entry to Home
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.pending, 1),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.list_alt, 2),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.exit_to_app, 3),
            label: 'Exit',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.person, 4),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFDBB2D),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, int index) {
    return Icon(
      icon,
      color: _selectedIndex == index ? Color(0xFFFDBB2D) : Colors.grey[600],
    );
  }
}