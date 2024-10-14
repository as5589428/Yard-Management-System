import 'package:flutter/material.dart';

class YardVehicleListPage extends StatefulWidget {
  @override
  _YardVehicleListPageState createState() => _YardVehicleListPageState();
}

class _YardVehicleListPageState extends State<YardVehicleListPage> {
  final List<Map<String, String>> vehicles = [
    {
      'clientName': 'John Doe',
      'registrationNumber': 'ABC1234',
      'makeModel': 'Toyota Camry 2021',
      'inwardDate': '2024-10-12',
      'status': 'Pending',
      'color': 'Blue',
      'chassisNumber': 'XYZ1234567890',
      'entryTime': '10:30 AM'
    },
    {
      'clientName': 'Jane Smith',
      'registrationNumber': 'XYZ5678',
      'makeModel': 'Honda Civic 2020',
      'inwardDate': '2024-10-10',
      'status': 'Approved',
      'color': 'Red',
      'chassisNumber': 'DEF1234567890',
      'entryTime': '2:00 PM'
    },
    // ... more vehicles
  ];

  String selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    // Filtered list based on selected status
    List<Map<String, String>> filteredVehicles = selectedStatus == 'All'
        ? vehicles
        : vehicles
            .where((vehicle) => vehicle['status'] == selectedStatus)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Yard Vehicle List"),
        backgroundColor: Colors.green[300],
      ),
      body: Column(
        children: [
          // Dropdown for selecting status filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter by Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedStatus,
                  items: <String>['All', 'Pending', 'Approved']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = filteredVehicles[index];
                return _buildVehicleCard(vehicle);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, String> vehicle) {
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
              "Color: ${vehicle['color']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "Chassis Number: ${vehicle['chassisNumber']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "Inward Date: ${vehicle['inwardDate']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "Entry Time: ${vehicle['entryTime']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "Status: ${vehicle['status']}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: vehicle['status'] == 'Pending' ? Colors.orange : Colors.green,
              ),
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
                    },
                    child: Text("View"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white, // Text color set to white
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add action for approving the vehicle
                    },
                    child: Text("Approve"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white, // Text color set to white
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add action for rejecting the vehicle
                    },
                    child: Text("Reject"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white, // Text color set to white
                      padding: EdgeInsets.symmetric(vertical: 10),
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
}
