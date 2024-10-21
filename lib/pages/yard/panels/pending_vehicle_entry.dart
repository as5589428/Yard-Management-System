import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Admin/Profile/admin_profile.dart';
// Import your YardPanelPage and other pages here
import 'yard_panel_page.dart'; // Make sure this path is correct
import 'package:flutter_application_1/pages/Yard/panels/pending_vehicle_entry.dart';
import 'package:flutter_application_1/pages/Yard/yard_forms/yard_vehicle_exit.dart';
import '../yard_forms/yard_vehicle_entry_page.dart';
import 'yard_vehicle_list_page.dart';
import '../panels/yard_vehicle_list_page.dart';
class PendingVehicleEntryPage extends StatefulWidget {
  @override
  _PendingVehicleEntryPageState createState() => _PendingVehicleEntryPageState();
}

class _PendingVehicleEntryPageState extends State<PendingVehicleEntryPage> {
  // Sample pending vehicle data (you can replace this with your dynamic data source)
  final List<Map<String, String>> pendingVehicles = [
    {
      'clientName': 'John Doe',
      'registrationNumber': 'ABC1234',
      'makeModel': 'Toyota Camry 2021',
      'inwardDate': '2024-10-12',
      'status': 'Pending'
    },
    {
      'clientName': 'Sam Wilson',
      'registrationNumber': 'DEF9101',
      'makeModel': 'Ford F-150 2022',
      'inwardDate': '2024-10-11',
      'status': 'Pending'
    },
  ];

  int _selectedIndex = 1; // Set initial index to 'Pending Vehicles' tab

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
          MaterialPageRoute(builder: (context) => YardPanelPage()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Vehicle Entries"),
        backgroundColor: Colors.green[300],
      ),
      body: pendingVehicles.isNotEmpty
          ? ListView.builder(
              itemCount: pendingVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = pendingVehicles[index];
                return _buildVehicleCard(vehicle, context);
              },
            )
          : Center(
              child: Text(
                "No Pending Vehicles",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
      bottomNavigationBar: _buildAnimatedBottomNavigationBar(),
    );
  }

  Widget _buildVehicleCard(Map<String, String> vehicle, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Client Name: ${vehicle['clientName']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Registration Number: ${vehicle['registrationNumber']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "Make/Model: ${vehicle['makeModel']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "Inward Date: ${vehicle['inwardDate']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: () {
                      _showVehicleDetails(context, vehicle);
                    },
                    child: Text(
                      "View Details",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: () {
                      _approveVehicle(vehicle);
                    },
                    child: Text(
                      "Approve",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: () {
                      _rejectVehicle(vehicle);
                    },
                    child: Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVehicleDetails(BuildContext context, Map<String, String> vehicle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Vehicle Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Client Name: ${vehicle['clientName']}"),
              SizedBox(height: 5),
              Text("Registration Number: ${vehicle['registrationNumber']}"),
              SizedBox(height: 5),
              Text("Make/Model: ${vehicle['makeModel']}"),
              SizedBox(height: 5),
              Text("Inward Date: ${vehicle['inwardDate']}"),
              SizedBox(height: 5),
              Text("Status: ${vehicle['status']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _approveVehicle(Map<String, String> vehicle) {
    vehicle['status'] = 'Approved';
    setState(() {});
  }

  void _rejectVehicle(Map<String, String> vehicle) {
    vehicle['status'] = 'Rejected';
    setState(() {});
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

// You need to create the ListPage, ExitPage, and ProfilePage widgets in separate files.
