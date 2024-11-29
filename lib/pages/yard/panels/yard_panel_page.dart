import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/pages/yard/QR_Scan/scan_qr_yard.dart';
import 'package:flutter_application_1/pages/Yard/panels/pending_vehicle_entry.dart';
import 'package:flutter_application_1/pages/Yard/yard_forms/yard_vehicle_exit.dart';
import 'package:flutter_application_1/pages/Yard/yard_forms/profile/profile_yard_owner.dart';
import 'package:flutter_application_1/pages/yard/panels/outward_vehicle_list.dart';
import '../yard_forms/yard_vehicle_entry_page.dart';
import 'yard_vehicle_list_page.dart';

class YardPanelPage extends StatefulWidget {
  @override
  _YardPanelPageState createState() => _YardPanelPageState();
}

class _YardPanelPageState extends State<YardPanelPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final List<Widget> _pages = [
    VehicleRegistrationForm(),
    PendingVehicleEntryPage(),
    YardVehicleListPage(),
    VehicleExitForm(),
  ];
    
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Scroll to the top of the page when Home is tapped
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
        ],
        body: RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                SizedBox(height: 24),
                _buildStatisticsSection(),
                SizedBox(height: 24),
                _buildRecentActivities(),
                SizedBox(height: 24),
                _buildAnalyticsSection(),
                SizedBox(height: 24),
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildAnimatedBottomNavigationBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VehicleRegistrationForm()),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('New Entry', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFDBB2D),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Color(0xFFFDBB2D),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Yard Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFDBB2D), Color(0xFFF09819)],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.notifications_outlined, color: Colors.white),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 20, color: Color(0xFFFDBB2D)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileYardOwner()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage your yard operations efficiently',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFDBB2D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.warehouse_outlined,
                size: 32,
                color: Color(0xFFFDBB2D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Vehicles',
                '150',
                Icons.directions_car,
                Color(0xFF4CAF50),
                '+12% from last month',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => YardVehicleListPage()),
                  );
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Pending Entry',
                '10',
                Icons.pending_actions,
                Color(0xFFFFA000),
                '5 new today',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PendingVehicleEntryPage()),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Completed Forms',
                '25',
                Icons.assignment_turned_in,
                Color(0xFF2196F3),
                '98% success rate',
                () {
                  // Navigate to CompletedFormsPage or similar
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Outward Vehicles', // Change title to "Outward Vehicles"
                '8', // Adjust the count as needed
                Icons.local_shipping, // Optional: Change the icon if desired
                Color(0xFF9C27B0), // Keep the color or adjust if necessary
                'All systems normal', // Adjust subtitle or description as needed
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OutwardVehicleList()), // Open OutwardVehicleList on click
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color,
      String change, VoidCallback onClick) {
    return GestureDetector(
      onTap: onClick, // Add onClick action
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                count,
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                change,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFDBB2D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    color: Color(0xFFFDBB2D),
                  ),
                ),
                title: Text(
                  'Vehicle Entry #${1234 + index}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text('2 hours ago'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vehicle Entries',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    DropdownButton<String>(
                      value: 'This Week',
                      items: ['This Week', 'This Month', 'This Year']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[300],
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              String text = '';
                              switch (value.toInt()) {
                                case 0:
                                  text = 'Mon';
                                  break;
                                case 2:
                                  text = 'Wed';
                                  break;
                                case 4:
                                  text = 'Fri';
                                  break;
                                case 6:
                                  text = 'Sun';
                                  break;
                              }
                              return Text(
                                text,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value % 2 == 0) {
                                return Text(
                                  '${value.toInt()}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 28,
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
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
                            FlSpot(6, 4),
                          ],
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFDBB2D),
                              Color(0xFFFDBB2D)
                            ], // You can use two identical colors if you want a solid color
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFDBB2D).withOpacity(0.1),
                                Color(0xFFFDBB2D).withOpacity(0.1),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
Widget _buildQuickActions() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Quick Actions',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              'New Entry',
              Icons.add_circle_outline,
              Colors.green,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VehicleRegistrationForm()),
                );
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildQuickActionCard(
              'Scan QR',
              Icons.qr_code_scanner,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanQRYard()),
                );
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildQuickActionCard(
              'Reports',
              Icons.assessment_outlined,
              Colors.orange,
              () {},
            ),
          ),
        ],
      ),
    ],
  );
}


  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', 0),
              _buildNavItem(Icons.pending_actions_outlined, 'Pending', 1),
              _buildNavItem(Icons.list_alt_outlined, 'List', 2),
              _buildNavItem(Icons.exit_to_app_outlined, 'Exit', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xFFFDBB2D) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFFFDBB2D) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
