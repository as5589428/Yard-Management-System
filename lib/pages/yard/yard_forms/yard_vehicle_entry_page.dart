import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vehicle_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'dart:developer'; 
class VehicleRegistrationForm extends StatefulWidget {
  @override
  _VehicleRegistrationFormState createState() => _VehicleRegistrationFormState();
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
 final TextEditingController inwardDateTimeController = TextEditingController();

  String? _selectedFuelType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  List<dynamic> vehicleData = [];
  List<String> makeList = [];
  List<String> modelList = [];
  List<String> variantList = [];

 // Fetch data from API
  Future<void> fetchVehicleData() async {
    final response = await http.get(Uri.parse('http://192.168.0.194:5000/api/makeModelDataset'));
    print(response);
    if (response.statusCode == 200) {
      vehicleData = json.decode(response.body);
      setState(() {
        makeList = vehicleData.map((item) => item['Make'] as String).toSet().toList();
      });
    } else {
      throw Exception('Failed to load vehicle data');
    }
  }
  @override
  void initState() {
    super.initState();
    _loadSavedForm();
      super.initState();
    fetchVehicleData();
      _setCurrentDateTime();
  }

  void _setCurrentDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now); // Customize format as needed
    _inwardDateTimeController.text = formattedDate;
  }

  @override
  void dispose() {
    _inwardDateTimeController.dispose();
    super.dispose();
  }  

  // You can use this if you still want a manual refresh
  void _selectDateTime(BuildContext context) {
    _setCurrentDateTime();
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

 


// Future<void> _saveForm() async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('clientName', _clientNameController.text);
//     await prefs.setString('agreementNumber', _agreementNumberController.text);
//     await prefs.setString('make', _makeController.text);
//     await prefs.setString('model', _modelController.text);
//     await prefs.setString('variant', _variantController.text);
//     await prefs.setString('refNo', _refNoController.text);
//     await prefs.setString('segment', _segmentController.text);
//     await prefs.setString('geoLocation', _geoLocationController.text);
//     await prefs.setString('inwardDateTime', _inwardDateTimeController.text);


//     var url = Uri.parse('http://192.168.0.194:5000/api/inward');
//     var response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'clientName': _clientNameController.text,
//         'agreementNumber': _agreementNumberController.text,
//         'make': _makeController.text,
//         'model': _modelController.text,
//         'variant': _variantController.text,
//         'refNo': _refNoController.text,
//         'segment': _segmentController.text,
//         'geoLocation': _geoLocationController.text,
//         'inwardDateTime': _inwardDateTimeController.text,
//         'loanNo': _loanNoController.text,
//         'fuelType': _selectedFuelType,
//         'odometerReading': _odometerReadingController.text,
//         'yard': _yardController.text,
//       }),
//     );

//      // Debug the response
//     log('Response Status: ${response.statusCode}');
//     log('Response Body: ${response.body}');

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Form saved successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save form: ${response.body}')),
//       );
//     }
//   } catch (error) {
//     log('Error: $error');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('An error occurred: $error')),
//     );
//   }
// }

Future<void> _saveFirstScreenForm() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the first screen data in SharedPreferences
    await prefs.setString('clientName', _clientNameController.text);
    await prefs.setString('agreementNumber', _agreementNumberController.text);
    await prefs.setString('make', _makeController.text);
    await prefs.setString('model', _modelController.text);
    await prefs.setString('variant', _variantController.text);
    await prefs.setString('refNo', _refNoController.text);
    await prefs.setString('segment', _segmentController.text);
    await prefs.setString('geoLocation', _geoLocationController.text);
    await prefs.setString('inwardDateTime', _inwardDateTimeController.text);
    await prefs.setString('loanNo', _loanNoController.text);
    await prefs.setString('fuelType', _selectedFuelType.toString());

    await prefs.setString('odometerReading', _odometerReadingController.text);
    await prefs.setString('yard', _yardController.text);

    // Navigate to the second screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VehicleDetailsForm()),
    );
  } catch (error) {
    log('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
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
        title: Text(
          "Vehicle Registration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[400],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed:_saveFirstScreenForm,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[400]!, Colors.white],
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
                  _buildSectionHeader("Client Information"),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTextField("Client Name", _clientNameController, Icons.person),
                          _buildTextField("Agreement Number", _agreementNumberController, Icons.description),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildSectionHeader("Vehicle Details"),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                            _buildDropdown("Make", makeList, _makeController, Icons.directions_car, _onMakeChanged),
                _buildDropdown("Model", modelList, _modelController, Icons.car_repair, _onModelChanged),
                _buildDropdown("Variant", variantList, _variantController, Icons.merge_type, _onVariantChanged),
                
                          Row(
                            children: [
                              Expanded(child: _buildTextField("Ref.No.", _refNoController, Icons.numbers)),
                              SizedBox(width: 10),
                              Expanded(child: _buildTextField("Segment", _segmentController, Icons.category, readOnly: true)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _buildTextField("Loan No", _loanNoController, Icons.account_balance)),
                              SizedBox(width: 10),
                              Expanded(child: _buildFuelTypeDropdown()),
                            ],
                          ),
                          _buildTextField("Odometer Reading", _odometerReadingController, Icons.speed),
                          _buildTextField("Yard", _yardController, Icons.location_city),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildSectionHeader("Other Information"),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _selectDateTime(context),
                            child: AbsorbPointer(
                              child: _buildTextField(
                                "Inward Date & Time",
                                _inwardDateTimeController,
                                Icons.calendar_today,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  "Geo Location",
                                  _geoLocationController,
                                  Icons.location_on,
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: _getCurrentLocation,
                                icon: Icon(Icons.my_location),
                                label: Text("Location"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[400],
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text(
                          'Continue to Details',
                          style: TextStyle(
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
Widget _buildDropdown(String label, List<String> items, TextEditingController controller, IconData icon, Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0), // Add padding between fields
    child: DropdownSearch<String>(
      items: items,
      selectedItem: controller.text,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Colors.green[600], // Set icon color to green
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding inside the dropdown
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      dropdownBuilder: (context, selectedItem) => Text(selectedItem ?? ""),
      popupProps: PopupProps.menu(
        showSearchBox: true, // Enables search in the dropdown menu
      ),
      onChanged: (value) {
        controller.text = value!;
        onChanged(value);
      },
    ),
  );
}


  Widget _buildFuelTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
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
          prefixIcon: Icon(Icons.local_gas_station, color: Colors.green[600]),
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
    );
  }
 // Handlers for dropdown changes
  void _onMakeChanged(String? make) {
    setState(() {
      modelList = vehicleData.where((item) => item['Make'] == make).map((item) => item['Model'] as String).toSet().toList();
      _modelController.clear();
      _variantController.clear();
      _segmentController.clear();
      variantList.clear();
    });
  }

    void _onModelChanged(String? model) {
    setState(() {
      variantList = vehicleData.where((item) => item['Model'] == model).map((item) => item['Variant'] as String).toSet().toList();
      _variantController.clear();
      final segment = vehicleData.firstWhere((item) => item['Model'] == model, orElse: () => null)?['Segment'];
      _segmentController.text = segment ?? "";
    });
  }
   void _onVariantChanged(String? variant) {
    // Add additional logic if needed when variant changes
  }
  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1,bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        
             readOnly: readOnly,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
}