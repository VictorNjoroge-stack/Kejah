import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../models/vacate_notice.dart';
import '../models/eviction_notice.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  final AppState app = AppState.instance;

  final reasonController = TextEditingController();
  final dateController = TextEditingController();

  // =========================
  // VACATE NOTICE
  // =========================
  void _addVacateNotice(String houseId, String tenantId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Issue Vacate Notice",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: "Reason"),
              ),

              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Move-out Date (YYYY-MM-DD)",
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  final notice = VacateNotice(
                    id: DateTime.now().toString(),
                    houseId: houseId,
                    tenantId: tenantId,
                    reason: reasonController.text,
                    date: DateTime.parse(dateController.text),
                  );

                  app.addVacateNotice(notice);
                  app.applyVacateNotice(notice);

                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text("Send Vacate Notice"),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // EVICTION NOTICE
  // =========================
  void _addEvictionNotice(String houseId, String tenantId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Issue Eviction Notice",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: "Reason"),
              ),

              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Issue Date (YYYY-MM-DD)",
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  final notice = EvictionNotice(
                    id: DateTime.now().toString(),
                    houseId: houseId,
                    tenantId: tenantId,
                    reason: reasonController.text,
                    date: DateTime.parse(dateController.text),
                  );

                  app.addEvictionNotice(notice);
                  app.applyEvictionNotice(notice);

                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text("Send Eviction Notice"),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notices")),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            "Vacate Notices",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          ...app.vacateNotices.map(
                (n) => Card(
              child: ListTile(
                title: const Text("Vacate Notice"),
                subtitle: Text(n.reason),
                trailing: Text(n.date.toString().split(" ")[0]),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Eviction Notices",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          ...app.evictionNotices.map(
                (n) => Card(
              child: ListTile(
                title: const Text("Eviction Notice"),
                subtitle: Text(n.reason),
                trailing: Text(n.date.toString().split(" ")[0]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}