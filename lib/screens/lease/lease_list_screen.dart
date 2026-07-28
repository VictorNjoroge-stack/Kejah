import 'package:flutter/material.dart';
import '../../models/lease.dart';
import '../../services/lease_service.dart';
import '../../widgets/lease_card.dart';
import '../lease/add_lease_screen.dart';
import '../lease/lease_details_screen.dart';

class LeaseListScreen extends StatefulWidget {
  const LeaseListScreen({super.key});

  @override
  State<LeaseListScreen> createState() => _LeaseListScreenState();
}

class _LeaseListScreenState extends State<LeaseListScreen> {
  final LeaseService _leaseService = LeaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leases'),
      ),
      body: StreamBuilder<List<Lease>>(
        stream: _leaseService.getLeases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final leases = snapshot.data ?? [];

          if (leases.isEmpty) {
            return const Center(
              child: Text('No leases found.'),
            );
          }

          return ListView.builder(
            itemCount: leases.length,
            itemBuilder: (context, index) {
              final lease = leases[index];
              return LeaseCard(
                lease: lease,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeaseDetailsScreen(lease: lease),
                    ),
                  );
                },
                onEdit: () {
                  // TODO: Implement edit
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Lease'),
                      content: const Text('Are you sure you want to delete this lease?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await _leaseService.deleteLease(lease.id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddLeaseScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
