import 'package:flutter/material.dart';

import '../models/dashboard.dart';
import '../models/dashboard_activity.dart';

import '../services/dashboard_service.dart';

import '../widgets/dashboard/dashboard_breakpoints.dart';
import '../widgets/dashboard/dashboard_empty.dart';
import '../widgets/dashboard/dashboard_grid.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_loading.dart';
import '../widgets/dashboard/dashboard_section.dart';
import '../widgets/dashboard/maintenance_summary_card.dart';
import '../widgets/dashboard/occupancy_summary_card.dart';
import '../widgets/dashboard/quick_action_card.dart';
import '../widgets/dashboard/recent_activity_card.dart';
import '../widgets/dashboard/revenue_summary_card.dart';
import '../widgets/dashboard/stat_card.dart';

import 'payments_screen.dart';
import 'properties_screen.dart';
import 'tenants_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
final DashboardService _dashboardService = DashboardService();

late Future<Dashboard> _dashboardFuture;
late Future<List<DashboardActivity>> _activityFuture;

@override
void initState() {
super.initState();
_loadDashboard();
}

void _loadDashboard() {
_dashboardFuture = _dashboardService.loadDashboard();
_activityFuture = _dashboardService.loadRecentActivity();
}

Future<void> _refresh() async {
setState(() {
_loadDashboard();
});

await Future.wait([
_dashboardFuture,
_activityFuture,
]);
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: RefreshIndicator(
onRefresh: _refresh,
child: FutureBuilder<Dashboard>(
future: _dashboardFuture,
builder: (context, dashboardSnapshot) {
if (dashboardSnapshot.connectionState !=
ConnectionState.done) {
return const DashboardLoading();
}

if (dashboardSnapshot.hasError) {
return DashboardEmpty(
onRefresh: _refresh,
);
}

final dashboard =
dashboardSnapshot.data ?? Dashboard.empty();

if (dashboard.totalBuildings == 0 &&
dashboard.totalUnits == 0 &&
dashboard.totalTenants == 0) {
return DashboardEmpty(
onRefresh: _refresh,
);
}

return FutureBuilder<List<DashboardActivity>>(
future: _activityFuture,
builder: (context, activitySnapshot) {
final activities =
activitySnapshot.data ?? [];

return Center(
child: ConstrainedBox(
constraints: BoxConstraints(
maxWidth:
DashboardBreakpoints.maxContentWidth(
context,
),
),
child: ListView(
padding: EdgeInsets.symmetric(
horizontal:
DashboardBreakpoints.horizontalPadding(
context,
),
vertical: 24,
),
children: [
const DashboardHeader(),

DashboardSection(
title: 'Portfolio Overview',
child: DashboardGrid(
children: [
StatCard(
title: 'Buildings',
value: dashboard.totalBuildings
.toString(),
icon:
Icons.apartment_rounded,
color: Colors.indigo,
),

StatCard(
title: 'Units',
value: dashboard.totalUnits
.toString(),
icon:
Icons.home_work_rounded,
color: Colors.teal,
subtitle:
'${dashboard.occupiedUnits} Occupied',
),

StatCard(
title: 'Tenants',
value: dashboard.totalTenants
.toString(),
icon:
Icons.people_alt_rounded,
color: Colors.orange,
),

StatCard(
title: 'Occupancy',
value:
'${dashboard.occupancyRate.toStringAsFixed(1)}%',
icon:
Icons.analytics_outlined,
color: Colors.green,
),
],
),
),

const SizedBox(height: 24),

DashboardSection(
title: 'Revenue',
child: RevenueSummaryCard(
collectedRevenue:
dashboard.totalRevenue,
expectedRevenue:
dashboard.expectedRevenue,
),
),

const SizedBox(height: 24),

DashboardSection(
title: 'Occupancy',
child: OccupancySummaryCard(
occupiedUnits:
dashboard.occupiedUnits,
vacantUnits:
dashboard.vacantUnits,
),
),

const SizedBox(height: 24),
  DashboardSection(
    title: 'Quick Actions',
    child: Column(
      children: [
        QuickActionCard(
          title: 'Manage Properties',
          icon: Icons.apartment_rounded,
          color: Colors.indigo,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const PropertiesScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        QuickActionCard(
          title: 'Manage Tenants',
          icon: Icons.people_rounded,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TenantsScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        QuickActionCard(
          title: 'Record Payments',
          icon: Icons.payments_rounded,
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PaymentsScreen(),
              ),
            );
          },
        ),
      ],
    ),
  ),

  const SizedBox(height: 24),

  DashboardSection(
    title: 'Maintenance',
    child: MaintenanceSummaryCard(
      openRequests:
      dashboard.openMaintenance,
    ),
  ),

  const SizedBox(height: 24),

  DashboardSection(
    title: 'Recent Activity',
    child: RecentActivityCard(
      activities: activities,
    ),
  ),
],
),
),
);
},
);
},
),
),
),
);
}
}