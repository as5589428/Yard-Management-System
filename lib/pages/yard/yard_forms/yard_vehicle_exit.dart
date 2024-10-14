import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Yard/yard_forms/exit_vehicle_details.dart';
import 'vehicle_details.dart';

class VehicleExitForm extends StatefulWidget {
  @override
  _VehicleExitFormState createState() => _VehicleExitFormState();
}

class _VehicleExitFormState extends State<VehicleExitForm> {
  final _formKey = GlobalKey<FormState>();

  final _clientNameController = TextEditingController();
  final _agreementNumberController = TextEditingController();
  final _makeModelController = TextEditingController();
  final _refNoController = TextEditingController();
  final _segmentController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _loanNoController = TextEditingController();
  final _odometerReadingController = TextEditingController();
  final _yardController = TextEditingController();
  final _exitDateTimeController = TextEditingController();
  final _geoLocationController = TextEditingController();

  String? _selectedFuelType; // Variable to store the selected fuel type

  DateTime? _selectedExitDate;
  TimeOfDay? _selectedExitTime;

  Future<void> _selectExitDateTime(BuildContext context) async {
    // Select Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // Select Time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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
        title: Text("Vehicle Exit Form"),
        backgroundColor: Colors.red[300],
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
                  "Vehicle Exit Details",
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
                _buildTextField("Registration number", _registrationNumberController),
                _buildTextField("Loan No", _loanNoController),
                Row(
                  children: [
                    Expanded(
                      child: _buildFuelTypeDropdown(), // Replace TextField with Dropdown for Fuel Type
                    ),
                    SizedBox(width: 10),
                    Expanded(child: _buildTextField("Odometer Reading", _odometerReadingController)),
                  ],
                ),
                _buildTextField("Yard", _yardController),
                GestureDetector(
                  onTap: () => _selectExitDateTime(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      "Exit Date & Time",
                      _exitDateTimeController,
                    ),
                  ),
                ),
                _buildTextField("Geo Location", _geoLocationController),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExitVehicleDetailsForm()),
                        );
                      }
                    },
                    child: Text('Submit Exit'),
                    style: ElevatedButton.styleFrom(
            
                      backgroundColor: Colors.red,
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
