import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/pages/Yard/yard_forms/exit_vehicle_details.dart';
import 'package:flutter_application_1/pages/Yard/panels/pending_vehicle_entry.dart';
import '../yard_forms/yard_vehicle_entry_page.dart';
import '../panels/yard_vehicle_list_page.dart';

class VehicleExitForm extends StatefulWidget {
  @override
  _VehicleExitFormState createState() => _VehicleExitFormState();
}

class _VehicleExitFormState extends State<VehicleExitForm> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final List<Widget> _pages = [
    VehicleRegistrationForm(),
    PendingVehicleEntryPage(),
    YardVehicleListPage(),
    VehicleExitForm(),
  ];

  final _clientNameController = TextEditingController();
  final _agreementNumberController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _variantController = TextEditingController();
  final _refNoController = TextEditingController();
  final _segmentController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _loanNoController = TextEditingController();
  final _odometerReadingController = TextEditingController();
  final _yardController = TextEditingController();
  final _exitDateTimeController = TextEditingController();
  final _geoLocationController = TextEditingController();

  String? _selectedFuelType;
  DateTime? _selectedExitDate;
  TimeOfDay? _selectedExitTime;

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Please enable location services');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _geoLocationController.text = '${position.latitude}, ${position.longitude}';
      });
      
      _showSnackBar('Location updated successfully');
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _selectExitDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red[300]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.red[300]!,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedExitDate = pickedDate;
          _selectedExitTime = pickedTime;
          _exitDateTimeController.text =
              '${_selectedExitDate!.toLocal().toString().split(' ')[0]} ${_selectedExitTime!.format(context)}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vehicle Exit Form",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red[300],
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Help'),
                  content: Text('Fill in the vehicle exit details. All fields marked with * are mandatory.'),
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
                  Card(
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
                            "Basic Information",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            "Client Name*",
                            _clientNameController,
                            prefixIcon: Icons.person,
                          ),
                          _buildTextField(
                            "Agreement Number*",
                            _agreementNumberController,
                            prefixIcon: Icons.assignment,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
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
                            "Vehicle Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  "Make*",
                                  _makeController,
                                  prefixIcon: Icons.directions_car,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  "Model*",
                                  _modelController,
                                  prefixIcon: Icons.car_repair,
                                ),
                              ),
                            ],
                          ),
                          _buildTextField(
                            "Variant",
                            _variantController,
                            prefixIcon: Icons.category,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  "Ref.No.*",
                                  _refNoController,
                                  prefixIcon: Icons.numbers,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  "Segment",
                                  _segmentController,
                                  prefixIcon: Icons.segment,
                                ),
                              ),
                            ],
                          ),
                          _buildTextField(
                            "Registration Number*",
                            _registrationNumberController,
                            prefixIcon: Icons.pin,
                          ),
                          _buildTextField(
                            "Loan No*",
                            _loanNoController,
                            prefixIcon: Icons.account_balance,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
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
                            "Exit Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildFuelTypeDropdown()),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  "Odometer Reading*",
                                  _odometerReadingController,
                                  prefixIcon: Icons.speed,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          _buildTextField(
                            "Yard*",
                            _yardController,
                            prefixIcon: Icons.location_city,
                          ),
                          InkWell(
                            onTap: () => _selectExitDateTime(context),
                            child: IgnorePointer(
                              child: _buildTextField(
                                "Exit Date & Time*",
                                _exitDateTimeController,
                                prefixIcon: Icons.calendar_today,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _getCurrentLocation,
                            child: IgnorePointer(
                              child: _buildTextField(
                                "Geo Location*",
                                _geoLocationController,
                                prefixIcon: Icons.location_on,
                                suffixIcon: Icons.my_location,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExitVehicleDetailsForm(),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.check_circle),
                      label: Text(
                        'Submit Exit Details',
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
        labelText: 'Fuel Type*',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.local_gas_station),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? prefixIcon,
    IconData? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        validator: (value) {
          if (label.contains('*') && (value == null || value.isEmpty)) {
            return 'Please enter ${label.replaceAll('*', '')}';
          }
          return null;
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }
}