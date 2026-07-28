import 'package:flutter/material.dart';
import '../models/application.dart';
import '../models/application_status.dart';
import '../models/unit.dart';
import '../models/tenant.dart';
import '../models/lease.dart';
import '../models/lease_status.dart';
import '../services/unit_service.dart';
import '../services/tenant_service.dart';
import '../services/lease_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final Application application;

  const ApplicationDetailsScreen({super.key, required this.application});

  @override
  State<ApplicationDetailsScreen> createState() => _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen> {
  bool _isProcessing = false;
  final _unitService = UnitService();
  final _tenantService = TenantService();
  final _leaseService = LeaseService();

  Future<void> _approveApplication() async {
    setState(() => _isProcessing = true);

    try {
      final app = widget.application;
      
      // 1. Create Tenant (Converted from Seeker)
      final tenantId = app.seekerId; // Keep same ID for continuity
      final tenant = Tenant(
        id: tenantId,
        name: app.seekerName,
        phone: app.seekerPhone,
        email: app.seekerEmail,
        nationalId: '', // To be filled later
        buildingId: app.buildingId,
        organizationId: app.organizationId,
        unitId: app.unitId,
        rent: 0, // Will be set by lease
        deposit: 0,
        active: true,
        createdAt: DateTime.now(),
      );
      await _tenantService.addTenant(tenant);

      // 1.5 Update User Role to 'tenant'
      await FirebaseFirestore.instance.collection('users').doc(tenantId).update({
        'role': 'tenant',
      });

      // 2. Fetch Unit to get rent details
      final unitSnapshot = await FirebaseFirestore.instance.collection('units').doc(app.unitId).get();
      final unitMap = unitSnapshot.data()!;
      final monthlyRent = (unitMap['monthlyRent'] ?? 0).toDouble();
      final deposit = (unitMap['deposit'] ?? 0).toDouble();

      // 3. Auto-Generate Lease
      final leaseId = const Uuid().v4();
      final lease = Lease(
        id: leaseId,
        organizationId: app.organizationId,
        buildingId: app.buildingId,
        unitId: app.unitId,
        tenantId: tenantId,
        leaseNumber: 'L-${DateFormat('yyyyMM').format(DateTime.now())}-${app.unitId.substring(0,4)}',
        monthlyRent: monthlyRent,
        deposit: deposit,
        billingDay: 1, // Default
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
        status: LeaseStatus.pending, // Pending signature
        agreementUrl: '', // Landlord will upload this next
        notes: 'Generated from Application: ${app.id}',
        createdAt: DateTime.now(),
      );
      await _leaseService.addLease(lease);

      // 4. Update Unit Status
      await _unitService.assignTenant(unitId: app.unitId, tenantId: tenantId);

      // 5. Update Application Status
      await FirebaseFirestore.instance.collection('applications').doc(app.id).update({
        'status': ApplicationStatus.approved.name,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Application Approved! Lease generated and Unit occupied.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Application Review")),
      body: _isProcessing 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoSection("Applicant Details", [
                  _infoRow(Icons.person, "Name", app.seekerName),
                  _infoRow(Icons.phone, "Phone", app.seekerPhone.isEmpty ? "Not Provided" : app.seekerPhone),
                  _infoRow(Icons.email, "Email", app.seekerEmail),
                ]),
                const SizedBox(height: 24),
                _infoSection("Target Property", [
                  _infoRow(Icons.apartment, "Building ID", app.buildingId),
                  _infoRow(Icons.home, "Unit ID", app.unitId),
                ]),
                const SizedBox(height: 24),
                const Text("Notes from Seeker", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(app.notes.isEmpty ? "No notes provided." : app.notes, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Implement Rejection
                        },
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text("REJECT"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _approveApplication,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        child: const Text("APPROVE & GEN LEASE"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _infoSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: Colors.grey[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: rows),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
