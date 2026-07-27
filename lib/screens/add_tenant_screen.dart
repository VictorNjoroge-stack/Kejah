import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/building.dart';
import '../models/tenant.dart';
import '../models/unit.dart';
import '../services/tenant_service.dart';
import '../services/unit_service.dart';

class AddTenantScreen extends StatefulWidget {
  final Building building;
  final Unit unit;

  const AddTenantScreen({
    super.key,
    required this.building,
    required this.unit,
  });

  @override
  State<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();

  final TenantService _tenantService = TenantService();
  final UnitService _unitService = UnitService();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();

  bool _saving = false;

  Future<void> _saveTenant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
    });

    try {
      final tenant = Tenant(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        buildingId: widget.building.id,
        organizationId: widget.building.organizationId,
        unitId: widget.unit.id,
        rent: widget.unit.monthlyRent,
        deposit: widget.unit.deposit,
        active: true,
        createdAt: DateTime.now(),
      );

      await _tenantService.addTenant(tenant);

      await _unitService.assignTenant(
        unitId: widget.unit.id,
        tenantId: tenant.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tenant assigned successfully.",
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Widget _textField(
      TextEditingController controller,
      String label,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Tenant"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.apartment),
                        title: Text(widget.building.name),
                        subtitle: const Text("Building"),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: Text(widget.unit.unitNumber),
                        subtitle: const Text("Unit"),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.payments),
                        title: Text(
                          "KES ${widget.unit.monthlyRent.toStringAsFixed(0)}",
                        ),
                        subtitle: const Text("Monthly Rent"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _textField(
                _nameController,
                "Full Name",
                Icons.person,
              ),

              _textField(
                _phoneController,
                "Phone Number",
                Icons.phone,
              ),

              _textField(
                _emailController,
                "Email Address",
                Icons.email,
              ),

              _textField(
                _nationalIdController,
                "National ID",
                Icons.badge,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _saveTenant,
                  icon: _saving
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.check),
                  label: Text(
                    _saving
                        ? "Assigning..."
                        : "Assign Tenant",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}