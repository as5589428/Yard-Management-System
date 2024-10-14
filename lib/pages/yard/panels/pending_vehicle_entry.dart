import 'package:flutter/material.dart';

class PendingVehicleEntryPage extends StatelessWidget {
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
                      // Add action for viewing vehicle details
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
                      // Add action for approving the vehicle
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
                      // Add action for rejecting the vehicle
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

  // Method to show detailed information about the vehicle in a dialog
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

  // Method to handle vehicle approval
  void _approveVehicle(Map<String, String> vehicle) {
    // Update status to "Approved" (this is just a sample; you can replace this with your logic)
    vehicle['status'] = 'Approved';
    // Show a confirmation message or perform any other action as needed
  }

  // Method to handle vehicle rejection
  void _rejectVehicle(Map<String, String> vehicle) {
    // Update status to "Rejected" (this is just a sample; you can replace this with your logic)
    vehicle['status'] = 'Rejected';
    // Show a confirmation message or perform any other action as needed
  }
}
