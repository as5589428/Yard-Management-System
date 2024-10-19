import 'package:flutter/material.dart';

class FinanceDashboard extends StatefulWidget {
  @override
  _FinanceDashboardState createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  int _selectedIndex = 0;

  // Handle the bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the respective screens based on the selected index
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ApprovedScreen(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExitStatusScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Dashboard'),
        backgroundColor: Color(0xFFE1A522),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFE1A522),
              ),
              child: Text(
                'Finance Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Employee Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showEmployeeDetails(context);
              },
            ),
            ListTile(
              title: Text(
                'Repo Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showRepoDetails(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Finance Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE1A522),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  // Add other widgets or dashboard elements here
                  Text(
                    'Select options from the menu for more details.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Exit Status',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFE1A522),
        onTap: _onItemTapped,
      ),
    );
  }

  void showEmployeeDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmployeeDetailsScreen(),
      ),
    );
  }

  void showRepoDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RepoDetailsScreen(),
      ),
    );
  }
}

class EmployeeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        backgroundColor: Color(0xFFE1A522),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildEmployeeDetail(
            companyName: 'ABC Finance',
            employeeName: 'John Doe',
            employeeCode: 'EMP123',
            designation: 'Manager',
            state: 'Maharashtra',
            city: 'Mumbai',
            whatsappNumber: '9876543210',
            mobileNumber: '9123456789',
          ),
          _buildEmployeeDetail(
            companyName: 'XYZ Capital',
            employeeName: 'Jane Smith',
            employeeCode: 'EMP456',
            designation: 'Assistant Manager',
            state: 'Gujarat',
            city: 'Ahmedabad',
            whatsappNumber: '9876543210',
            mobileNumber: '9123456789',
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeDetail({
    required String companyName,
    required String employeeName,
    required String employeeCode,
    required String designation,
    required String state,
    required String city,
    required String whatsappNumber,
    required String mobileNumber,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: $companyName',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Employee Name: $employeeName'),
            Text('Employee Code: $employeeCode'),
            Text('Designation: $designation'),
            Text('Location: $city, $state'),
            Text('WhatsApp: $whatsappNumber'),
            Text('Mobile: $mobileNumber'),
          ],
        ),
      ),
    );
  }
}

class RepoDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repo Details'),
        backgroundColor: Color(0xFFE1A522),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildRepoDetail(
            companyName: 'ABC Finance',
            numberOfCars: 10,
            carModel: 'Toyota Camry',
            carNumber: 'MH12AB1234',
          ),
          _buildRepoDetail(
            companyName: 'XYZ Capital',
            numberOfCars: 5,
            carModel: 'Honda City',
            carNumber: 'GJ05XY6789',
          ),
        ],
      ),
    );
  }

  Widget _buildRepoDetail({
    required String companyName,
    required int numberOfCars,
    required String carModel,
    required String carNumber,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: $companyName',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Number of Cars: $numberOfCars'),
            Text('Car Model: $carModel'),
            Text('Car Number: $carNumber'),
          ],
        ),
      ),
    );
  }
}

// Dummy screens for bottom navigation actions
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFE1A522),
      ),
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}

class ApprovedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approved'),
        backgroundColor: Color(0xFFE1A522),
      ),
      body: Center(
        child: Text('Approved Screen'),
      ),
    );
  }
}

class ExitStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exit Status'),
        backgroundColor: Color(0xFFE1A522),
      ),
      body: Center(
        child: Text('Exit Status Screen'),
      ),
    );
  }
}
