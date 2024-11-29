import 'package:flutter/material.dart';

class OutwardVehicleList extends StatelessWidget {
  const OutwardVehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outward Vehicle List'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _dummyVehicles.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final vehicle = _dummyVehicles[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.directions_car,
                  color: Colors.blue.shade900,
                ),
              ),
              title: Text(
                vehicle.vehicleNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Driver: ${vehicle.driverName}'),
                  Text('Exit Time: ${vehicle.exitTime}'),
                ],
              ),
              trailing: Text(
                vehicle.status,
                style: TextStyle(
                  color: vehicle.status == 'Completed' 
                    ? Colors.green 
                    : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // Handle tap event - show details, etc.
              },
            ),
          );
        },
      ),
    );
  }
}

// Model class for vehicle data
class OutwardVehicle {
  final String vehicleNumber;
  final String driverName;
  final String exitTime;
  final String status;

  OutwardVehicle({
    required this.vehicleNumber,
    required this.driverName,
    required this.exitTime,
    required this.status,
  });
}

// Dummy data for demonstration
final List<OutwardVehicle> _dummyVehicles = [
  OutwardVehicle(
    vehicleNumber: 'MH 04 AB 1234',
    driverName: 'John Doe',
    exitTime: '2024-01-10 14:30',
    status: 'Completed',
  ),
  OutwardVehicle(
    vehicleNumber: 'MH 04 CD 5678',
    driverName: 'Jane Smith',
    exitTime: '2024-01-10 15:45',
    status: 'In Transit',
  ),
  OutwardVehicle(
    vehicleNumber: 'MH 04 EF 9012',
    driverName: 'Bob Wilson',
    exitTime: '2024-01-10 16:15',
    status: 'Completed',
  ),
];