import 'package:flutter/material.dart';
import '../services/application_service.dart';
import '../models/application.dart';
import '../services/session_service.dart';
import 'application_details_screen.dart';
import 'package:intl/intl.dart';

class ApplicationsListScreen extends StatelessWidget {
  const ApplicationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final applicationService = ApplicationService();
    final orgId = SessionService.instance.organizationId ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Applications")),
      body: StreamBuilder<List<Application>>(
        stream: applicationService.getOrganizationApplications(orgId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final apps = snapshot.data ?? [];

          if (apps.isEmpty) {
            return const Center(child: Text("No applications yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return Card(
                child: ListTile(
                  title: Text(app.seekerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Unit ID: ${app.unitId}\nSubmitted: ${DateFormat('MMM d').format(app.createdAt)}"),
                  trailing: _statusChip(app.status.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApplicationDetailsScreen(application: app),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    return Chip(
      label: Text(status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.blue[50],
    );
  }
}
