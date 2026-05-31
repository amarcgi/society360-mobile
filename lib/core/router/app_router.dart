import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/screen/login/login_screen.dart';
import '../../features/screen/login/otp_screen.dart';
//import '../../features/screen/Profile/Profile_wizard_screen.dart';

import '../../features/screen/profile/widgets/profile_wrapper.dart';
import '../../features/screen/society_dashboard.dart';
import '../../features/screen/splash/splash_screen.dart';
import '../../features/screen/visitors/add_visitor_screen.dart';
import '../../features/screen/visitors/gate_approval_screen.dart';
import '../../features/screen/visitors/model/visitor_history_model.dart';
import '../../features/screen/visitors/visitor_detail_screen.dart';
import '../../features/screen/visitors/visitor_history_screen.dart';
import '../../features/screen/visitors/visitor_management_screen.dart';
// Import your screens here
// import '../../presentation/screens/splash_screen.dart';
// import '../../presentation/screens/login_screen.dart';
// import '../../presentation/screens/dashboard_screen.dart';

class AppRouter {
  // Centralized Route Names as Constants to avoid typos
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String otp_screen = '/otp_screen';
  static const String Profile = '/Profile';
  static const String addVisitor = '/add-visitor';
  static const String visitorDetail = '/visitor-detail';
  static const String gateApproval = '/gate-approval';
  static const String visitorHistory = '/visitor-history';
  //static const String visitorManageMent = '/visitor-management';




  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true, // Useful for debugging route changes in terminal
    routes: [
      GoRoute(
        path: dashboard,
        builder: (context, state) => const SocietyDashboard(key: ValueKey('dash-board')),
      ),
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(key: ValueKey('splash-screen')),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(key: ValueKey('login-screen')),
      ),
      GoRoute(
        path: addVisitor,
        builder: (context, state) => const AddVisitorScreen(),
      ),
      GoRoute(
        path: visitorDetail,
        builder: (context, state) {
          // Extract the visitor object from the go_router state arguments
          final visitor = state.extra as VisitorHistoryModel;
          return VisitorDetailScreen(visitor: visitor);
        },
      ),
      GoRoute(
        path: gateApproval,
        builder: (context, state) => const GateApprovalScreen(),
      ),
      GoRoute(
        path: visitorHistory,
        builder: (context, state) => const VisitorHistoryScreen(),
      ),
      /*GoRoute(
        path: Profile_screen,
        builder: (context, state) => const ProfileWizardScreen(key: ValueKey('ProfileWizard-screen')),
      ),*/
      // ── Add to app_router.dart ───────────────
      GoRoute(
        path: AppRouter.Profile,
        builder: (_, state) {
          final extra = state.extra
          as Map<String, String>;
          return ProfileWrapper(
            mobile:       extra['mobile']!,
            societyId:    extra['societyId']!,
            buildingId:   extra['buildingId']!,
            flatId:       extra['flatId']!,
            flatNumber:   extra['flatNumber']!,
            buildingName: extra['buildingName']!,
            societyName:  extra['societyName']!,
          );
        },
      ),
      GoRoute(
        path: AppRouter.otp_screen,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return OtpScreen(
            mobile: data['mobile'] as String,
            role: data['role'] as String,
          );
        },
      ),
    ],
    // 💡 Bonus: Centralized Redirection (e.g., Guard routes if user isn't logged in)
    redirect: (context, state) {
      final bool loggedIn = true; // Replace with your actual auth state check
      final bool loggingIn = state.matchedLocation == login;

      if (!loggedIn && !loggingIn) return login;
      if (loggedIn && loggingIn) return login;
      return null;
    },
  );
}


/*
// lib/core/router/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/screens/login_screen.dart';

import '../storage/secure_storage.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',

    // Redirect based on auth state
    redirect: (context, state) async {
      final token = await SecureStorage.getToken();
      final isLoggedIn = token != null;
      final isLoginPage =
          state.uri.path == '/login';

      if (!isLoggedIn && !isLoginPage) return '/login';
      if (isLoggedIn && isLoginPage) return '/home';
      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      */
/*GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/announcements',
        builder: (_, __) =>
        const AnnouncementsScreen(),
      ),
      GoRoute(
        path: '/complaints',
        builder: (_, __) =>
        const ComplaintsScreen(),
      ),
      GoRoute(
        path: '/invoices',
        builder: (_, __) => const InvoicesScreen(),
      ),
      GoRoute(
        path: '/visitors',
        builder: (_, __) => const VisitorsScreen(),
      ),
      GoRoute(
        path: '/packages',
        builder: (_, __) => const PackagesScreen(),
      ),*//*

    ],
  );
});*/
