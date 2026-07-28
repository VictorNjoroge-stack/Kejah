import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/maintenance.dart';
import '../../models/maintenance_priority.dart';
import '../../models/maintenance_status.dart';
import '../../models/building.dart';
import '../../models/unit.dart';
import '../../services/maintenance_service.dart';
import '../../services/building_service.dart';
import '../../services/unit_service.dart';
import '../../services/session_service.dart';

class AddMaintenanceScreen extends StatefulWidget {
  const AddMaintenanceScreen({super.key});

  @override
  State<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends State<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _maintenanceService = MaintenanceService();
  final _buildingService = BuildingService();
  final _unitService = UnitService();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _estimatedCostController = TextEditingController();

  MaintenancePriority _priority = MaintenancePriority.medium;
  String? _selectedBuildingId;
  String? _selectedUnitId;
  String? _selectedTenantId;

  List<Building> _buildings = [];
  List<Unit> _units = [];
  final List<XFile> _images = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  Future<void> _loadBuildings() async {
    _buildingService.getActiveBuildings().listen((buildings) {
      if (mounted) {
        setState(() {
          _buildings = buildings;
        });
      }
    });
  }

  Future<void> _loadUnits(String buildingId) async {
    _unitService.getBuildingUnits(buildingId).listen((units) {
      if (mounted) {
        setState(() {
          _units = units;
          _selectedUnitId = null;
          _selectedTenantId = null;
        });
      }
    });
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _images.addAll(pickedImages);
      });
    }
  }

  Future<List<String>> _uploadImages(String maintenanceId) async {
    final List<String> urls = [];
    final storageRef = FirebaseStorage.instance.ref();

    for (var i = 0; i < _images.length; i++) {
      final file = File(_images[i].path);
      final ref = storageRef.child('maintenance/$maintenanceId/photo_$i.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBuildingId == null || _selectedUnitId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select building and unit')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final orgId = SessionService.instance.organizationId!;
      final maintenanceId = const Uuid().v4();
      
      // Upload images if any
      final List<String> photoUrls = await _uploadImages(maintenanceId);

      final maintenance = Maintenance(
        id: maintenanceId,
        organizationId: orgId,
        buildingId: _selectedBuildingId!,
        unitId: _selectedUnitId!,
        tenantId: _selectedTenantId ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        status: MaintenanceStatus.reported,
        assignedTo: _assignedToController.text.trim(),
        photos: photoUrls,
        reportedAt: DateTime.now(),
        estimatedCost: double.tryParse(_estimatedCostController.text) ?? 0,
        actualCost: 0,
      );

      await _maintenanceService.addRequest(maintenance);
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
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToController.dispose();
    _estimatedCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance Request')),
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
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Issue Title (e.g. Leaking Tap)'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<MaintenancePriority>(
                      value: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: MaintenancePriority.values.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _priority = v!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedBuildingId,
                      decoration: const InputDecoration(labelText: 'Building'),
                      items: _buildings.map((b) {
                        return DropdownMenuItem(
                          value: b.id,
                          child: Text(b.name),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() => _selectedBuildingId = v);
                        if (v != null) _loadUnits(v);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedUnitId,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: _units.map((u) {
                        return DropdownMenuItem(
                          value: u.id,
                          child: Text(u.unitNumber),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedUnitId = v;
                          final unit = _units.firstWhere((u) => u.id == v);
                          _selectedTenantId = unit.tenantId;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Photos', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          InkWell(
                            onTap: _pickImages,
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[400]!),
                              ),
                              child: const Icon(Icons.add_a_photo_outlined),
                            ),
                          ),
                          ..._images.map((img) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(File(img.path), width: 100, height: 100, fit: BoxFit.cover),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _assignedToController,
                      decoration: const InputDecoration(labelText: 'Assign to (Vendor/Caretaker)'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _estimatedCostController,
                      decoration: const InputDecoration(
                        labelText: 'Estimated Cost',
                        prefixText: 'KES ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Submit Request', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
