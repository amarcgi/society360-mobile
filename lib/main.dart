// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'injection.dart';
import 'core/network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //For testing purpose comment when actualty using API uncomment when using API
  // ✅ Step 1: Init ApiClient FIRST
  ApiClient().init();

  // Setup dependencies
  await initDependencies();

  // Init API client
  ApiClient();
  runApp(const Society360App());
}

class Society360App extends StatelessWidget {
  const Society360App({super.key});

  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      title: 'Society360',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );*/
    return MaterialApp.router(
      title: 'Society360',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // 💡 Let GoRouter handle the navigation engine
      routerConfig: AppRouter.router,
    );
  }
}
