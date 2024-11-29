import 'package:flutter/material.dart';

class PendingVehicleEntryPage extends StatefulWidget {
  @override
  _PendingVehicleEntryPageState createState() => _PendingVehicleEntryPageState();
}

class _PendingVehicleEntryPageState extends State<PendingVehicleEntryPage> {
  final List<Map<String, String>> pendingVehicles = [
    {
      'clientName': 'John Doe',
      'registrationNumber': 'ABC1234',
      'makeModel': 'Toyota Camry 2021',
      'inwardDate': '2024-10-12',
      'status': 'Pending',
      'location': 'North Yard',
      'type': 'Sedan'
    },
    {
      'clientName': 'Sam Wilson',
      'registrationNumber': 'DEF9101',
      'makeModel': 'Ford F-150 2022',
      'inwardDate': '2024-10-11',
      'status': 'Pending',
      'location': 'South Yard',
      'type': 'Pickup'
    },
  ];

  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatusBar(),
          Expanded(
            child: pendingVehicles.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: pendingVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = pendingVehicles[index];
                      return _buildVehicleCard(vehicle, context);
                    },
                  )
                : _buildEmptyState(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new vehicle entry
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFFDBB2D),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        "Pending Vehicles",
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list, color: Colors.black87),
          onPressed: () {
            // Show filter options
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () {
            // Show more options
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by registration number or client name',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

 Widget _buildStatusBar() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    color: Colors.white,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatusChip('All', 12, true),
          SizedBox(width: 8),
          _buildStatusChip('Pending', 8, false),
          SizedBox(width: 8),
          _buildStatusChip('Approved', 3, false),
          SizedBox(width: 8),
          _buildStatusChip('Rejected', 1, false),
        ],
      ),
    ),
  );
}

  Widget _buildStatusChip(String label, int count, bool isSelected) {
    return FilterChip(
      label: Text(
        '$label ($count)',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        // Handle filter selection
      },
      backgroundColor: isSelected ? Color(0xFFFDBB2D) : Colors.grey[200],
      selectedColor: Color(0xFFFDBB2D),
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildVehicleCard(Map<String, String> vehicle, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Row(
              children: [
                Text(
                  vehicle['clientName']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                _buildStatusBadge(vehicle['status']!),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                _buildInfoRow(Icons.directions_car, vehicle['makeModel']!),
                SizedBox(height: 4),
                _buildInfoRow(Icons.pin_drop, vehicle['location']!),
                SizedBox(height: 4),
                _buildInfoRow(Icons.calendar_today, vehicle['inwardDate']!),
                SizedBox(height: 4),
                _buildInfoRow(Icons.numbers, vehicle['registrationNumber']!),
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.visibility,
                  label: 'View',
                  color: Colors.blue,
                  onPressed: () => _showVehicleDetails(context, vehicle),
                ),
                _buildActionButton(
                  icon: Icons.check_circle,
                  label: 'Approve',
                  color: Colors.green,
                  onPressed: () => _approveVehicle(vehicle),
                ),
                _buildActionButton(
                  icon: Icons.cancel,
                  label: 'Reject',
                  color: Colors.red,
                  onPressed: () => _rejectVehicle(vehicle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[900]!;
        break;
      case 'approved':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[900]!;
        break;
      case 'rejected':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[900]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[900]!;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 20),
      label: Text(
        label,
        style: TextStyle(color: color),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No pending vehicles found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showVehicleDetails(BuildContext context, Map<String, String> vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vehicle Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client Name: ${vehicle['clientName']}'),
            Text('Registration Number: ${vehicle['registrationNumber']}'),
            Text('Make/Model: ${vehicle['makeModel']}'),
            Text('Location: ${vehicle['location']}'),
            Text('Inward Date: ${vehicle['inwardDate']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _approveVehicle(Map<String, String> vehicle) {
    // Approve vehicle logic
  }

  void _rejectVehicle(Map<String, String> vehicle) {
    // Reject vehicle logic
  }
}
