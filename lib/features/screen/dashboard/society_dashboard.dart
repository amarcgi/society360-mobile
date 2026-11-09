import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:society360_app/core/shared/widgets/app_text_styles.dart';
import 'package:society360_app/features/screen/dashboard/bloc/society_dashboard_bloc.dart';
import 'package:society360_app/features/screen/profile/bloc/profile_bloc.dart';
import 'package:society360_app/features/screen/profile/bloc/profile_event.dart';
import 'package:society360_app/features/screen/profile/models/profile_model.dart';
import '../../../core/router/app_router.dart';
import '../../../core/shared/widgets/app_bar.dart';
import '../../../core/shared/widgets/app_loader.dart';
import '../../../core/shared/widgets/app_snackbar.dart';
import '../../../core/theme/AppColors.dart';
import '../../../injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society360_app/features/screen/profile/bloc/profile_state.dart';

import 'bloc/society_dashboard_event.dart';
import 'bloc/society_dashboard_state.dart';
import 'model/society_dashboard_response.dart';
class SocietyDashboard extends StatefulWidget {
  final String mobile;
  final String role;

  const SocietyDashboard({
    super.key,
    required this.mobile,
    required this.role,
  });

  @override
  State<SocietyDashboard> createState() => _SocietyDashboardState();
}

class _SocietyDashboardState extends State<SocietyDashboard> {
  int _currentIndex = 0;
    SocietyDashBoardDetails? _societyDashBoardDetails;
  SocietyDashboardBloc? _societyDashboardBloc;
// Using literals
  Map<String, dynamic> dashBoardDetailAsMap = {};

  @override
  void initState() {
    super.initState();
    _societyDashboardBloc = sl<SocietyDashboardBloc>()..add(LoadSocietyDashboard(widget.mobile));
    dashBoardDetailAsMap = {
            'mobile':       widget.mobile,
            'societyId':    _societyDashBoardDetails?.societyId,
            'buildingId':   _societyDashBoardDetails?.buildingId,
            'flatId':       _societyDashBoardDetails?.flatId,
            'flatNumber':   _societyDashBoardDetails?.flatNo,
            'buildingName': _societyDashBoardDetails?.buildingName,
            'societyName':  _societyDashBoardDetails?.societyName,
        };
  }



  @override
  void dispose() {
    _societyDashboardBloc?.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocietyDashboardBloc, SocietyDashboardState>(
      bloc: _societyDashboardBloc,
      listener: (context, state) {
        if (state is SocietyDashboardLoading) {
          showOverlayLoader(context, message: 'Loading DashBaord...');
        } else {
          hideOverlayLoader();
        }

        if (state is SocietyDashboardFailure) {
          AppSnackbar.error(context, state.message);
        }
      },
      builder: (context, state) {
        _societyDashBoardDetails = state is SocietyDashboardLoaded ?state.details:null;

        // Return your existing dashboard Scaffold here for both success and failure.
        return Scaffold(
          backgroundColor: const Color(0xFF0D2C54),
          appBar: CustomAppBars.customAppBar(
            context: context,
            title: 'DashBoard',
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
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Bills',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Visitors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
          ),
        );
      },
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
                    context.push(AppRouter.profile,
                      extra: dashBoardDetailAsMap,
                    );
                    break;
                  case 'Visitors':
                    context.push(AppRouter.addVisitor, extra: dashBoardDetailAsMap);
                    break; // Optional in modern Dart for regular code blocks, but good practice
                  case 'Complaints':
                    context.push(AppRouter.complain_dashboard,extra: dashBoardDetailAsMap);
                    break; // Optional in modern Dart for regular code blocks, but good practice
                  case 'Accounting':
                    context.push(AppRouter.accounting,extra: dashBoardDetailAsMap);
                    break;
                  case 'Polling':
                    context.push(AppRouter.pollsVoting,extra: dashBoardDetailAsMap);
                    break;
                  case 'rejected':
                    print('Application denied.');
                    break;
                  case 'Amenities':
                    context.push(AppRouter.amenitiesScreen,extra: dashBoardDetailAsMap);
                    break;
                  case 'Announcements':
                    context.push(AppRouter.announcementsScreen,extra: dashBoardDetailAsMap);
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
                    style: AppTextStyles.labelLarge,
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