import 'package:flutter/material.dart';
import 'package:flutter_application_1/welcome_screen.dart';

class ProfileYardOwner extends StatelessWidget {
  const ProfileYardOwner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yard Owner Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIWNTiq9IDokwKAKD68rWcfvb_790X2MOxIA&s'),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Aslam Khan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Email', 'aslam@example.com'),
            _buildInfoRow('Phone', '+1 (555) 123-4567'),
            _buildInfoRow('Address', '123, Anytown, Nagpur'),
            const SizedBox(height: 24),
            const Text(
              'Yard Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Yard Name', 'Green Acres Storage'),
            _buildInfoRow('Capacity', '500 units'),
            _buildInfoRow('Occupancy Rate', '75%'),
            _buildInfoRow('Available Units', '125'),
            const SizedBox(height: 24),
            const Text(
              'Additional Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Years in Business', '10'),
            _buildInfoRow('Rating', '4.5 / 5.0'),
            _buildInfoRow('Specialties', 'RV Storage, Climate Control'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality to edit profile
                },
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}