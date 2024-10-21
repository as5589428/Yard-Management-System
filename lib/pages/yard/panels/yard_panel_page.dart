import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/pages/Yard/panels/pending_vehicle_entry.dart';
import 'package:flutter_application_1/pages/Yard/yard_forms/yard_vehicle_exit.dart';
import '../yard_forms/yard_vehicle_entry_page.dart';
import 'yard_vehicle_list_page.dart';

class YardPanelPage extends StatefulWidget {
  @override
  _YardPanelPageState createState() => _YardPanelPageState();
}

class _YardPanelPageState extends State<YardPanelPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    VehicleRegistrationForm(),
    PendingVehicleEntryPage(),
    YardVehicleListPage(),
    VehicleExitForm(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yard Panel",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFDBB2D),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24),
                    _buildCardView(),
                    SizedBox(height: 24),
                    _buildTotalCarsGraphCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildAnimatedBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFDBB2D),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xFFFDBB2D)),
                ),
                SizedBox(height: 10),
                Text(
                  'Yard Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.directions_car_filled, 'Vehicle Entry (Inward From)', () => _onItemTapped(0)),
          _buildDrawerItem(Icons.pending, 'Pending Vehicle Entry', () => _onItemTapped(1)),
          _buildDrawerItem(Icons.list_alt, 'Yard Vehicle List', () => _onItemTapped(2)),
          _buildDrawerItem(Icons.exit_to_app, 'Vehicle Exit (Outward Form)m n', () => _onItemTapped(3)),
          Divider(),
          _buildDrawerItem(Icons.settings, 'Settings', () {}),
          _buildDrawerItem(Icons.help, 'Help Center', () {}),
          _buildDrawerItem(Icons.info, 'About', () {}),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFFDBB2D)),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildCardView() {
    return Row(
      children: [
        Expanded(child: _buildInfoCard("Total Cars", "150", Icons.directions_car)),
        SizedBox(width: 12),
        Expanded(child: _buildInfoCard("Pending", "10", Icons.pending_actions)),
        SizedBox(width: 12),
        Expanded(child: _buildInfoCard("Saved Forms", "25", Icons.save)),
      ],
    );
  }

  Widget _buildInfoCard(String title, String count, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDBB2D), Color(0xFFF09819)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.white),
              SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 4),
              Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCarsGraphCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDBB2D), Color(0xFFF09819)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Cars",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 12),
              Container(
                height: 120,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(1, 1),
                          FlSpot(2, 4),
                          FlSpot(3, 2),
                          FlSpot(4, 5),
                          FlSpot(5, 3),
                        ],
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            icon: _buildAnimatedIcon(Icons.directions_car_filled, 0),
            label: 'Entry',
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
