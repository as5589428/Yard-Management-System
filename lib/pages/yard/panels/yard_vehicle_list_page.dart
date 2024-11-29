import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/entry_summary.dart';
import 'package:image_picker/image_picker.dart';
 // Import the SummaryPage

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
      'entryTime': '10:30 AM',
    },
    {
      'clientName': 'Jane Smith',
      'registrationNumber': 'XYZ5678',
      'makeModel': 'Honda Civic 2020',
      'inwardDate': '2024-10-10',
      'status': 'Approved',
      'color': 'Red',
      'chassisNumber': 'DEF1234567890',
      'entryTime': '2:00 PM',
    },
  ];

  final Map<String, XFile?> vehicleImages = {
    'Front View': XFile('path/to/front_view.jpg'),
    'Side View': XFile('path/to/side_view.jpg'),
  };

  final List<XFile?> tyreImages = [
    XFile('path/to/tyre1.jpg'),
    XFile('path/to/tyre2.jpg'),
  ];

  void _navigateToSummaryPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPage(
          vehicleImages: vehicleImages,
          tyreImages: tyreImages,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }

  Widget _buildVehicleCard(Map<String, String> vehicle) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle['clientName']!,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        vehicle['registrationNumber']!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Text(
                  vehicle['status']!,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  'View',
                  Colors.blue,
                  () => _navigateToSummaryPage(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yard Vehicle List')),
      body: ListView(
        children: vehicles.map((vehicle) => _buildVehicleCard(vehicle)).toList(),
      ),
    );
  }
}
