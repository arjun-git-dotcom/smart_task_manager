import 'package:flutter/material.dart';
import 'package:smart_task_manager/features/auth/presentation/pages/login_page.dart';
import 'package:smart_task_manager/features/auth/presentation/pages/registration_page.dart';
import 'package:smart_task_manager/features/auth/presentation/pages/splash_page.dart';
import 'package:smart_task_manager/features/home/presentation/pages/dashboard_page.dart';
import 'package:smart_task_manager/features/home/presentation/pages/home_page.dart';
import 'package:smart_task_manager/features/profile/presentation/pages/profile_page.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case AppRoutes.home:
        final uid = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => HomePage(userId: uid));

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegistrationPage());

      case AppRoutes.profile:
        final uid = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ProfilePage(uid: uid));

      case AppRoutes.dashboard:
        final uid = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DashboardPage(userId: uid));

      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
