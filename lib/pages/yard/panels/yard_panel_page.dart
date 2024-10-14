import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Yard/panels/pending_vehicle_entry.dart';
import 'package:flutter_application_1/pages/Yard/yard_forms/yard_vehicle_exit.dart';
import '../yard_forms/yard_vehicle_entry_page.dart';
import 'yard_vehicle_list_page.dart';

class YardPanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yard Panel",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Welcome to the Yard",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildPanelButton(
                  "Yard Vehicle Entry",
                  Icons.directions_car_filled,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VehicleRegistrationForm()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildPanelButton(
                  "Pending Vehicle Entry",
                  Icons.pending,
                  Colors.yellow[700]!,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PendingVehicleEntryPage()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildPanelButton(
                  "Yard Vehicle List",
                  Icons.list_alt,
                  Colors.teal,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YardVehicleListPage()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildPanelButton(
                  "Vehicle Exit",
                  Icons.exit_to_app,
                  Colors.redAccent,
                  () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VehicleExitForm()),
                    );
                    // Handle Vehicle Exit
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanelButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            SizedBox(width: 15),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
