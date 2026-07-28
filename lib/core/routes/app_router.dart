import 'package:flutter/material.dart';

import '../../screens/add_building_screen.dart';
import '../../screens/add_payment_screen.dart';
import '../../screens/analytics_screen.dart';
import '../../screens/buildings_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/lease/lease_list_screen.dart';
import '../../screens/lease/add_lease_screen.dart';
import '../../screens/marketplace_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/maintenance/maintenance_list_screen.dart';
import '../../screens/maintenance/add_maintenance_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/payments_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/tenants_screen.dart';
import '../../screens/organization/organization_settings_screen.dart';

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

      case AppRoutes.marketplace:
        return MaterialPageRoute(
          builder: (_) => const MarketplaceScreen(),
        );

      case AppRoutes.maintenance:
        return MaterialPageRoute(
          builder: (_) => const MaintenanceListScreen(),
        );

      case AppRoutes.addMaintenance:
        return MaterialPageRoute(
          builder: (_) => const AddMaintenanceScreen(),
        );

      case AppRoutes.lease:
        return MaterialPageRoute(
          builder: (_) => const LeaseListScreen(),
        );

      case AppRoutes.addLease:
        return MaterialPageRoute(
          builder: (_) => const AddLeaseScreen(),
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const OrganizationSettingsScreen(),
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