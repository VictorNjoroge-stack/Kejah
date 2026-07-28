import 'package:flutter/material.dart';
import '../../models/lease.dart';
import '../../models/lease_status.dart';
import '../../models/building.dart';
import '../../models/unit.dart';
import '../../models/tenant.dart';
import '../../services/lease_service.dart';
import '../../services/building_service.dart';
import '../../services/unit_service.dart';
import '../../services/tenant_service.dart';
import 'package:intl/intl.dart';
import 'add_lease_screen.dart';

class LeaseDetailsScreen extends StatefulWidget {
  final Lease lease;

  const LeaseDetailsScreen({
    super.key,
    required this.lease,
  });

  @override
  State<LeaseDetailsScreen> createState() => _LeaseDetailsScreenState();
}

class _LeaseDetailsScreenState extends State<LeaseDetailsScreen> {
  final LeaseService _leaseService = LeaseService();
  final BuildingService _buildingService = BuildingService();
  final UnitService _unitService = UnitService();
  final TenantService _tenantService = TenantService();

  late Lease _lease;
  Building? _building;
  Unit? _unit;
  Tenant? _tenant;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _lease = widget.lease;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Get building
      final building = await _buildingService.getBuilding(_lease.buildingId).first;
      // Get unit
      final units = await _unitService.getBuildingUnits(_lease.buildingId).first;
      final unit = units.firstWhere((u) => u.id == _lease.unitId);
      // Get tenant
      final tenant = await _tenantService.getTenant(_lease.tenantId);

      if (mounted) {
        setState(() {
          _building = building;
          _unit = unit;
          _tenant = tenant;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<void> _updateStatus(LeaseStatus? status) async {
    if (status == null || status == _lease.status) return;

    try {
      if (status == LeaseStatus.terminated) {
        await _leaseService.terminateLease(_lease.id);
      } else if (status == LeaseStatus.expired) {
        await _leaseService.expireLease(_lease.id);
      } else {
        await _leaseService.updateLease(_lease.copyWith(status: status));
      }

      setState(() {
        _lease = _lease.copyWith(status: status);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lease Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddLeaseScreen(lease: _lease),
                ),
              );
              _loadData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _lease.leaseNumber,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      _statusBadge(_lease.status),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionHeader('Property Information'),
                  _infoCard([
                    _infoRow(Icons.apartment, 'Building', _building?.name ?? 'Loading...'),
                    _infoRow(Icons.home, 'Unit Number', _unit?.unitNumber ?? 'Loading...'),
                  ]),
                  const SizedBox(height: 24),
                  _sectionHeader('Tenant Information'),
                  _infoCard([
                    _infoRow(Icons.person, 'Name', _tenant?.name ?? 'Loading...'),
                    _infoRow(Icons.phone, 'Phone', _tenant?.phone ?? 'N/A'),
                  ]),
                  const SizedBox(height: 24),
                  _sectionHeader('Financials'),
                  _infoCard([
                    _infoRow(Icons.attach_money, 'Monthly Rent', 'KES ${_lease.monthlyRent.toStringAsFixed(2)}'),
                    _infoRow(Icons.account_balance_wallet, 'Deposit', 'KES ${_lease.deposit.toStringAsFixed(2)}'),
                    _infoRow(Icons.event, 'Billing Day', 'Day ${_lease.billingDay} of every month'),
                  ]),
                  const SizedBox(height: 24),
                  _sectionHeader('Lease Period'),
                  _infoCard([
                    _infoRow(Icons.calendar_today, 'Start Date', dateFormat.format(_startDate)),
                    _infoRow(Icons.calendar_today, 'End Date', dateFormat.format(_endDate)),
                    _infoRow(Icons.timer, 'Remaining', '${_lease.daysRemaining} days'),
                  ]),
                  const SizedBox(height: 24),
                  if (_lease.notes.isNotEmpty) ...[
                    _sectionHeader('Notes'),
                    Text(_lease.notes, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 24),
                  ],
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Update Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<LeaseStatus>(
                    value: _lease.status,
                    items: LeaseStatus.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: _updateStatus,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  DateTime get _startDate => _lease.startDate;
  DateTime get _endDate => _lease.endDate;

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(LeaseStatus status) {
    Color color;
    switch (status) {
      case LeaseStatus.active: color = Colors.green; break;
      case LeaseStatus.pending: color = Colors.orange; break;
      case LeaseStatus.expired: color = Colors.grey; break;
      case LeaseStatus.terminated: color = Colors.red; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
