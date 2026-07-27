import 'package:flutter/material.dart';

import '../state/app_state.dart';

class NoticesScreen extends StatelessWidget {
  NoticesScreen({super.key});

  final AppState app = AppState.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notices"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Vacate Notices",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (app.vacateNotices.isEmpty)
            const Card(
              child: ListTile(
                title: Text("No vacate notices"),
              ),
            )
          else
            ...app.vacateNotices.map(
                  (notice) => Card(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(notice.reason),
                  subtitle: Text(
                    "Tenant: ${notice.tenantId}\nUnit: ${notice.houseId}",
                  ),
                  trailing: Text(
                    notice.date.toString().split(' ')[0],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 30),

          const Text(
            "Eviction Notices",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (app.evictionNotices.isEmpty)
            const Card(
              child: ListTile(
                title: Text("No eviction notices"),
              ),
            )
          else
            ...app.evictionNotices.map(
                  (notice) => Card(
                child: ListTile(
                  leading: const Icon(Icons.gavel),
                  title: Text(notice.reason),
                  subtitle: Text(
                    "Tenant: ${notice.tenantId}\nUnit: ${notice.houseId}",
                  ),
                  trailing: Text(
                    notice.date.toString().split(' ')[0],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}