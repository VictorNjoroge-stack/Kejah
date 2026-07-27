import 'package:flutter/material.dart';

import '../../screens/add_building_screen.dart';
import '../../screens/add_payment_screen.dart';
import '../../screens/analytics_screen.dart';
import '../../screens/buildings_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/payments_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/tenants_screen.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case AppRoutes.buildings:
        return MaterialPageRoute(
          builder: (_) => BuildingsScreen(),
        );

      case AppRoutes.addBuilding:
        return MaterialPageRoute(
          builder: (_) => const AddBuildingScreen(),
        );

      case AppRoutes.tenants:
        return MaterialPageRoute(
          builder: (_) => TenantsScreen(),
        );

    // AddTenantScreen is opened from Unit Details
    // because it requires a Building and Unit.
    // Do not register it as a global route.

      case AppRoutes.payments:
        return MaterialPageRoute(
          builder: (_) => PaymentsScreen(),
        );

      case AppRoutes.addPayment:
        return MaterialPageRoute(
          builder: (_) => const AddPaymentScreen(),
        );

      case AppRoutes.analytics:
        return MaterialPageRoute(
          builder: (_) => AnalyticsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text("Page Not Found"),
            ),
            body: Center(
              child: Text(
                "No route defined for ${settings.name}",
              ),
            ),
          ),
        );
    }
  }
}