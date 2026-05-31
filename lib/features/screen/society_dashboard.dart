import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/AppColors.dart';

class SocietyDashboard extends StatefulWidget {
  const SocietyDashboard({super.key});

  @override
  State<SocietyDashboard> createState() => _SocietyDashboardState();
}

class _SocietyDashboardState extends State<SocietyDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        title: const Text('DashBoard'),
        // Force back button even if framework thinks there is no stack history
        leading: context.canPop()
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ): null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildOverviewCards(),
              const SizedBox(height: 24),
              const Text(
                'QUICK ACCESS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              _buildGridMenu(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0D2C54),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Bills'),
          BottomNavigationBarItem(icon: Icon(Icons. people), label: 'Visitors'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E9F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Good morning',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                'Amar Singh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D2C54),
                ),
              ),
              Text(
                'Tower A • Flat 402',
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE5E9F0),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none, color: Color(0xFF0D2C54)),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text('AS', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Pending dues',
            value: '₹2,500',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: Colors.redAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Open complaints',
            value: '3',
            icon: Icons.assignment_late_outlined,
            iconColor: Colors.orangeAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Icon(icon, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'label': 'Profile', 'icon': Icons.person_outline, 'color': Colors.blue.shade50},
      {'label': 'Visitors', 'icon': Icons.people, 'color': Colors.orange.shade50},
      {'label': 'Complaints', 'icon': Icons.campaign_outlined, 'color': Colors.red.shade50},
      {'label': 'Announcements', 'icon': Icons.campaign, 'color': Colors.purple.shade50},
      {'label': 'Amenities', 'icon': Icons.pool_outlined, 'color': Colors.teal.shade50},
      {'label': 'Accounting', 'icon': Icons.calculate_outlined, 'color': Colors.green.shade50},
      {'label': 'Staff', 'icon': Icons.badge_outlined, 'color': Colors.amber.shade50},
      {'label': 'Polling', 'icon': Icons.how_to_vote_outlined, 'color': Colors.cyan.shade50},
      {'label': 'Packages', 'icon': Icons.local_shipping_outlined, 'color': Colors.brown.shade50},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                var label= item['label'];
                print('Tapped on ${item['label']}');
                switch (label) {
                  case 'Profile':
                    context.push(AppRouter.Profile,
                      extra: {
                        'mobile':       '8147574889',
                        'societyId':    'societyId',
                        'buildingId':   'buildingId',
                        'flatId':       'flatId',
                        'flatNumber':   'flatNumber',
                        'buildingName': 'buildingName',
                        'societyName':  'societyName',
                      },
                    );
                    break;
                  case 'Visitors':
                    context.push(AppRouter.addVisitor);
                    break; // Optional in modern Dart for regular code blocks, but good practice
                  case 'rejected':
                    print('Application denied.');
                    break;
                  default:
                    print('Unknown status.'); // Executes if no matches are found
                }

              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item['color'],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item['icon'], color: const Color(0xFF0D2C54), size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}