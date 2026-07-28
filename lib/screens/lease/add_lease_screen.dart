import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/lease.dart';
import '../../models/lease_status.dart';
import '../../models/building.dart';
import '../../models/unit.dart';
import '../../models/tenant.dart';
import '../../services/lease_service.dart';
import '../../services/building_service.dart';
import '../../services/unit_service.dart';
import '../../services/tenant_service.dart';
import '../../services/session_service.dart';
import 'package:intl/intl.dart';

class AddLeaseScreen extends StatefulWidget {
  final Lease? lease;
  final Building? building;
  final Unit? unit;
  final Tenant? tenant;

  const AddLeaseScreen({
    super.key,
    this.lease,
    this.building,
    this.unit,
    this.tenant,
  });

  @override
  State<AddLeaseScreen> createState() => _AddLeaseScreenState();
}

class _AddLeaseScreenState extends State<AddLeaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _leaseService = LeaseService();
  final _buildingService = BuildingService();
  final _unitService = UnitService();
  final _tenantService = TenantService();

  final _leaseNumberController = TextEditingController();
  final _monthlyRentController = TextEditingController();
  final _depositController = TextEditingController();
  final _billingDayController = TextEditingController(text: '1');
  final _notesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  String? _selectedBuildingId;
  String? _selectedUnitId;
  String? _selectedTenantId;

  List<Building> _buildings = [];
  List<Unit> _units = [];
  List<Tenant> _tenants = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedBuildingId = widget.building?.id;
    _selectedUnitId = widget.unit?.id;
    _selectedTenantId = widget.tenant?.id;

    if (widget.lease != null) {
      final l = widget.lease!;
      _leaseNumberController.text = l.leaseNumber;
      _monthlyRentController.text = l.monthlyRent.toString();
      _depositController.text = l.deposit.toString();
      _billingDayController.text = l.billingDay.toString();
      _notesController.text = l.notes;
      _startDate = l.startDate;
      _endDate = l.endDate;
      _selectedBuildingId = l.buildingId;
      _selectedUnitId = l.unitId;
      _selectedTenantId = l.tenantId;
    } else if (widget.unit != null) {
      _monthlyRentController.text = widget.unit!.monthlyRent.toString();
      _depositController.text = widget.unit!.deposit.toString();
    }

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _buildingService.getActiveBuildings().listen((buildings) {
      if (mounted) setState(() => _buildings = buildings);
    });

    _tenantService.getTenants().listen((tenants) {
      if (mounted) setState(() => _tenants = tenants);
    });

    if (_selectedBuildingId != null) {
      _loadUnits(_selectedBuildingId!);
    }
  }

  void _loadUnits(String buildingId) {
    _unitService.getBuildingUnits(buildingId).listen((units) {
      if (mounted) {
        setState(() {
          _units = units;
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 365));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBuildingId == null || _selectedUnitId == null || _selectedTenantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select building, unit, and tenant')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final orgId = SessionService.instance.organizationId!;
      final lease = Lease(
        id: widget.lease?.id ?? const Uuid().v4(),
        organizationId: orgId,
        buildingId: _selectedBuildingId!,
        unitId: _selectedUnitId!,
        tenantId: _selectedTenantId!,
        leaseNumber: _leaseNumberController.text.trim(),
        monthlyRent: double.parse(_monthlyRentController.text),
        deposit: double.parse(_depositController.text),
        billingDay: int.parse(_billingDayController.text),
        startDate: _startDate,
        endDate: _endDate,
        status: widget.lease?.status ?? LeaseStatus.active,
        agreementUrl: widget.lease?.agreementUrl ?? '',
        notes: _notesController.text.trim(),
        createdAt: widget.lease?.createdAt ?? DateTime.now(),
      );

      if (widget.lease == null) {
        await _leaseService.addLease(lease);
        // Also update unit status and tenant id in unit
        await _unitService.assignTenant(unitId: lease.unitId, tenantId: lease.tenantId);
      } else {
        await _leaseService.updateLease(lease);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _leaseNumberController.dispose();
    _monthlyRentController.dispose();
    _depositController.dispose();
    _billingDayController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(title: Text(widget.lease == null ? 'New Lease' : 'Edit Lease')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _leaseNumberController,
                      decoration: const InputDecoration(labelText: 'Lease Number (e.g. L-101)'),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedBuildingId,
                      decoration: const InputDecoration(labelText: 'Building'),
                      items: _buildings.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedBuildingId = v;
                          _selectedUnitId = null;
                        });
                        if (v != null) _loadUnits(v);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedUnitId,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: _units.map((u) => DropdownMenuItem(value: u.id, child: Text(u.unitNumber))).toList(),
                      onChanged: (v) => setState(() => _selectedUnitId = v),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedTenantId,
                      decoration: const InputDecoration(labelText: 'Tenant'),
                      items: _tenants.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))).toList(),
                      onChanged: (v) => setState(() => _selectedTenantId = v),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _monthlyRentController,
                            decoration: const InputDecoration(labelText: 'Monthly Rent (KES)'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _depositController,
                            decoration: const InputDecoration(labelText: 'Deposit (KES)'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _billingDayController,
                      decoration: const InputDecoration(labelText: 'Billing Day (1-31)'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final val = int.tryParse(v ?? '');
                        if (val == null || val < 1 || val > 31) return 'Invalid day';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text('Lease Period', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _selectDate(context, true),
                            child: Text('Start: ${dateFormat.format(_startDate)}'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _selectDate(context, false),
                            child: Text('End: ${dateFormat.format(_endDate)}'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _save,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(widget.lease == null ? 'Create Lease' : 'Update Lease'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
