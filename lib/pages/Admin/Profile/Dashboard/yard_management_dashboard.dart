import 'package:flutter/material.dart';
import '../admin_profile.dart';
void main() {
  runApp(YardManagementApp());
}
  
class YardManagementApp extends StatelessWidget {
  const YardManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yard Management Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ).copyWith(
          secondary: Colors.cyanAccent,
          surface: Colors.white,
        ),
        fontFamily: 'Raleway', // Add this font in pubspec.yaml
        textTheme: TextTheme(
          headlineSmall:
              const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.grey.shade700),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade700,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Any initialization logic goes here
  }

  static final List<Widget> _widgetOptions = <Widget>[
    YardOverviewPanel(),
    YardDetailsPanel(),
    RepoDetailsPanel(),
    TasksPanel(),
    CarDetailsPanel(),
    FinancierDetailsPanel(),
    GatepassDetailsPanel(),
    // Pass the _searchQuery as an argument when needed
    SearchResultsPanel(searchQuery: ''),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = false;
      Navigator.pop(context); // Close the drawer
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _selectedIndex = _widgetOptions.length - 1;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _selectedIndex = 0;
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
      _widgetOptions[_widgetOptions.length - 1] =
          SearchResultsPanel(searchQuery: _searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search e.g car state gate pass',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _updateSearchQuery,
              )
            : const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _isSearching ? _stopSearch : _startSearch,
          ),
        ],
      ),
      drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 56, 62, 66), const Color.fromARGB(255, 39, 244, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add your logo here
            Image.asset(
              'assets/logo-white.jpg', // Ensure you have this image in your assets
              height: 95, 
              width:300,// Adjust the height as necessary
            ),
            const SizedBox(height: 5), // Space between logo and title
            const Text(
              'Dashboard Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
      _createDrawerItem(
          icon: Icons.dashboard, text: 'Overview', index: 0),
      _createDrawerItem(icon: Icons.yard, text: 'Yard Details', index: 1),
      _createDrawerItem(
          icon: Icons.store, text: 'Repo Details', index: 2),
      _createDrawerItem(icon: Icons.assignment, text: 'Tasks', index: 3),
      _createDrawerItem(
          icon: Icons.directions_car, text: 'Car Details', index: 4),
      _createDrawerItem(
          icon: Icons.account_balance,
          text: 'Financier Details',
          index: 5),
      _createDrawerItem(
          icon: Icons.receipt_long, text: 'Gate Pass Details', index: 6),
    ],
  ),
),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon, required String text, required int index}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: () => _onItemTapped(index),
    );
  }
}

// Panel for Yard Overview
class YardOverviewPanel extends StatelessWidget {
  const YardOverviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yard Overview', style: TextStyle(fontSize: 20)), // Adjusted title size
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, color: Colors.white),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Handle notification icon press
            },
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/11.jpg'), // Replace with actual user image URL
            radius: 20, // Adjust the size as needed
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              _buildSortByFilter(),
              SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildCard('Total Cars', '150', const Color.fromARGB(255, 5, 187, 207), Icons.directions_car),
                  _buildCard('Available Spaces', '50', Colors.teal.shade300, Icons.local_parking),
                  _buildCard('Pending Tasks', '10', Colors.orange.shade400, Icons.pending),
                  _buildCard('Completed Tasks', '25', Colors.purple.shade300, Icons.check_circle),
                  _buildCard('Total Financer', '15', Colors.greenAccent.shade400, Icons.account_balance),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.approval, color: Colors.green),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Approval',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel, color: Colors.red),
            label: 'Rejected',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            // Navigate to AdminProfile page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()), // Ensure AdminProfile is defined
            );
          }
          // Handle other navigation cases
        },
      ),
    );
  }

  Widget _buildSortByFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sort By:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Adjusted size
        ),
        DropdownButton<String>(
          items: <String>['Date', 'Popularity', 'Name'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14)), // Adjusted size
            );
          }).toList(),
          onChanged: (String? newValue) {
            // Handle sort change
          },
          hint: Text('Select', style: TextStyle(fontSize: 14)), // Adjusted size
        ),
      ],
    );
  }

  Widget _buildCard(String title, String value, Color color, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16, // Adjusted size
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24, // Adjusted size
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 36, // Adjusted size
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
// Yard Details Panel
class YardDetailsPanel extends StatelessWidget {
  const YardDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const <Widget>[
        Card(
          child: ListTile(
            title: Text('Yard Capacity'),
            subtitle: Text('200 cars'),
            leading: Icon(Icons.car_rental, color: Colors.blueGrey),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Current Occupancy'),
            subtitle: Text('150 cars (75%)'),
            leading: Icon(Icons.bar_chart, color: Colors.teal),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Average Stay Duration'),
            subtitle: Text('7 days'),
            leading: Icon(Icons.timer, color: Colors.orange),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Peak Hours'),
            subtitle: Text('10:00 AM - 2:00 PM'),
            leading: Icon(Icons.access_time, color: Colors.purple),
          ),
        ),
      ],
    );
  }
}

// Repo Details Panel
class RepoDetailsPanel extends StatelessWidget {
  const RepoDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const <Widget>[
        Card(
          child: ListTile(
            title: Text('Total Repositories'),
            subtitle: Text('5'),
            leading: Icon(Icons.store, color: Colors.blueGrey),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Active Repositories'),
            subtitle: Text('4'),
            leading: Icon(Icons.check_circle, color: Colors.teal),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Inactive Repositories'),
            subtitle: Text('1'),
            leading: Icon(Icons.cancel, color: Colors.orange),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Average Inventory'),
            subtitle: Text('30 cars per repository'),
            leading: Icon(Icons.inventory, color: Colors.purple),
          ),
        ),
      ],
    );
  }
}

// Tasks Panel
class TasksPanel extends StatelessWidget {
  const TasksPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Pending Tasks'),
              Tab(text: 'Completed Tasks'),
            ],
            indicatorColor: Theme.of(context).colorScheme.secondary,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTaskList(isPending: true),
                _buildTaskList(isPending: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList({required bool isPending}) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Task ${index + 1}'),
            subtitle:
                Text(isPending ? 'Due: Tomorrow' : 'Completed: Yesterday'),
            leading: Icon(
              isPending ? Icons.pending_actions : Icons.task_alt,
              color: isPending ? Colors.orange : Colors.green,
            ),
            trailing: isPending
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Complete'),
                  )
                : null,
          ),
        );
      },
    );
  }
}

// Car Details Panel

class CarDetailsPanel extends StatelessWidget {
  const CarDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          shadowColor: Colors.blueGrey.shade100,
          child: ExpansionTile(
            title: Text('Car ${index + 1}'),
            subtitle: const Text('Toyota Camry'),
            leading: const Icon(Icons.directions_car, color: Colors.blueGrey),
            children: <Widget>[
              const ListTile(title: Text('VIN: 1HGBH41JXMN109186')),
              const ListTile(title: Text('Year: 2022')),
              const ListTile(title: Text('Color: Silver')),
              const ListTile(title: Text('Status: In Yard')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://via.placeholder.com/300x200?text=Car+Photo',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text('Failed to load image'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//FinancierDetailsPanel
class FinancierDetailsPanel extends StatelessWidget {
  const FinancierDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Replace with actual number of financiers
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          shadowColor: Colors.blueGrey.shade100,
          child: ExpansionTile(
            title: Text('Financier ${index + 1}'),
            subtitle: const Text('Company Name'),
            leading: const Icon(Icons.account_balance, color: Colors.blueGrey),
            children: const <Widget>[
              ListTile(title: Text('Employee Name: John Doe')),
              ListTile(title: Text('Employee Code: EMP001')),
              ListTile(title: Text('Designation: Manager')),
              ListTile(title: Text('State: California')),
              ListTile(title: Text('City: Los Angeles')),
              ListTile(title: Text('WhatsApp: +1 123-456-7890')),
              ListTile(title: Text('Mobile: +1 987-654-3210')),
            ],
          ),
        );
      },
    );
  }
}

//GatepassDetailsPanel
class GatepassDetailsPanel extends StatelessWidget {
  const GatepassDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Replace with actual number of gate passes
      itemBuilder: (context, index) {
        bool isGenerated = index % 2 ==
            0; // For demonstration, alternate between generated and not generated
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          shadowColor: Colors.blueGrey.shade100,
          child: ExpansionTile(
            title: Text('Gate Pass ${index + 1}'),
            subtitle:
                Text('Status: ${isGenerated ? 'Generated' : 'Not Generated'}'),
            leading: Icon(
              isGenerated ? Icons.check_circle : Icons.pending,
              color: isGenerated ? Colors.green : Colors.orange,
            ),
            children: [
              if (isGenerated) ...[
                ListTile(
                    title:
                        Text('Generation Time: ${DateTime.now().toString()}')),
                ListTile(title: Text('Generated By: John Doe')),
                ListTile(
                    title: Text(
                        'Vehicle Left Time: ${DateTime.now().add(Duration(hours: 2)).toString()}')),
                ListTile(title: Text('Employee in Charge: Jane Smith')),
                ListTile(title: Text('Vehicle Collector: Mike Johnson')),
                ListTile(title: Text('Collector Designation: Driver')),
                ListTile(title: Text('Collector Contact: +1 234-567-8901')),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://via.placeholder.com/150',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ] else ...[
                ListTile(title: Text('Gate pass not yet generated')),
              ],
            ],
          ),
        );
      },
    );
  }
}

// Searching Panel
class SearchResultsPanel extends StatelessWidget {
  final String searchQuery;

  const SearchResultsPanel({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // This is a placeholder implementation. In a real app, you would search through your actual data.
    List<String> dummyResults = [
      'Car: Toyota Camry (VIN: 1HGBH41JXMN109186)',
      'Financier: ABC Financial (John Doe)',
      'Gate Pass: #1234 (Generated)',
      'Task: Inspect Vehicle #5678',
    ]
        .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: dummyResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(dummyResults[index]),
          onTap: () {
            // Handle tapping on a search result
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You tapped on: ${dummyResults[index]}')),
            );
          },
        );
      },
    );
  }
}