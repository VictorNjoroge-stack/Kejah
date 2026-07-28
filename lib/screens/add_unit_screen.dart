import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/building.dart';
import '../models/unit.dart';
import '../models/unit_status.dart';
import '../services/unit_service.dart';

class AddUnitScreen extends StatefulWidget {
  final Building building;
  final Unit? unit;

  const AddUnitScreen({
    super.key,
    required this.building,
    this.unit,
  });

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _unitController = TextEditingController();
  final _floorController = TextEditingController();
  final _bedroomController = TextEditingController();
  final _bathroomController = TextEditingController();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _serviceChargeController = TextEditingController();
  final _sizeController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool parking = false;
  bool wifi = false;
  bool furnished = false;
  bool pets = false;
  bool isPublic = true;
  UnitStatus status = UnitStatus.vacant;

  final List<XFile> _newImages = [];
  List<String> _existingPhotos = [];
  bool _isLoading = false;

  final UnitService _service = UnitService();
  bool get editing => widget.unit != null;

  @override
  void initState() {
    super.initState();
    if (widget.unit != null) {
      final unit = widget.unit!;
      _unitController.text = unit.unitNumber;
      _floorController.text = unit.floor.toString();
      _bedroomController.text = unit.bedrooms.toString();
      _bathroomController.text = unit.bathrooms.toString();
      _rentController.text = unit.monthlyRent.toString();
      _depositController.text = unit.deposit.toString();
      _serviceChargeController.text = unit.serviceCharge.toString();
      _sizeController.text = unit.size.toString();
      _descriptionController.text = unit.description;
      parking = unit.parking;
      wifi = unit.wifiReady;
      furnished = unit.furnished;
      pets = unit.petsAllowed;
      isPublic = unit.isPublic;
      status = unit.status;
      _existingPhotos = List.from(unit.photos);
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) setState(() => _newImages.addAll(images));
  }

  Future<List<String>> _uploadNewImages(String unitId) async {
    final List<String> urls = [];
    final storageRef = FirebaseStorage.instance.ref();
    for (var i = 0; i < _newImages.length; i++) {
      final ref = storageRef.child('units/$unitId/photo_${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
      await ref.putFile(File(_newImages[i].path));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  Future<void> _saveUnit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final unitId = editing ? widget.unit!.id : const Uuid().v4();
      final newPhotoUrls = await _uploadNewImages(unitId);
      final allPhotos = [..._existingPhotos, ...newPhotoUrls];

      final unit = Unit(
        id: unitId,
        organizationId: widget.building.organizationId,
        buildingId: widget.building.id,
        unitNumber: _unitController.text.trim(),
        floor: int.parse(_floorController.text),
        bedrooms: int.parse(_bedroomController.text),
        bathrooms: int.parse(_bathroomController.text),
        size: double.parse(_sizeController.text),
        monthlyRent: double.parse(_rentController.text),
        deposit: double.parse(_depositController.text),
        serviceCharge: double.parse(_serviceChargeController.text),
        status: status,
        isPublic: isPublic,
        tenantId: editing ? widget.unit!.tenantId : "",
        leaseId: editing ? widget.unit!.leaseId : "",
        electricityMeter: editing ? widget.unit!.electricityMeter : "",
        waterMeter: editing ? widget.unit!.waterMeter : "",
        parking: parking,
        wifiReady: wifi,
        furnished: furnished,
        petsAllowed: pets,
        description: _descriptionController.text.trim(),
        amenities: editing ? widget.unit!.amenities : const [],
        photos: allPhotos,
        createdAt: editing ? widget.unit!.createdAt : DateTime.now(),
      );

      if (editing) {
        await _service.updateUnit(unit);
      } else {
        await _service.addUnit(unit);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editing ? "Edit Unit" : "Add Unit")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _textField(_unitController, "Unit Number"),
                  _numberField(_floorController, "Floor"),
                  Row(
                    children: [
                      Expanded(child: _numberField(_bedroomController, "Bedrooms")),
                      const SizedBox(width: 16),
                      Expanded(child: _numberField(_bathroomController, "Bathrooms")),
                    ],
                  ),
                  _numberField(_sizeController, "Size (sqm)"),
                  _numberField(_rentController, "Monthly Rent"),
                  _numberField(_depositController, "Deposit"),
                  _numberField(_serviceChargeController, "Service Charge"),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  const SizedBox(height: 24),
                  const Align(alignment: Alignment.centerLeft, child: Text("Marketplace Visibility", style: TextStyle(fontWeight: FontWeight.bold))),
                  SwitchListTile(
                    title: const Text("Public Listing"),
                    subtitle: const Text("Show this unit on the Kejah Marketplace when vacant."),
                    value: isPublic, 
                    onChanged: (v) => setState(() => isPublic = v),
                  ),
                  const SizedBox(height: 24),
                  const Align(alignment: Alignment.centerLeft, child: Text("Photos", style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _photoPickerButton(),
                        ..._newImages.map((f) => _photoPreview(File(f.path))),
                        ..._existingPhotos.map((url) => _photoPreviewUrl(url)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<UnitStatus>(
                    value: status,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: UnitStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => status = v!),
                  ),
                  CheckboxListTile(value: parking, title: const Text("Parking"), onChanged: (v) => setState(() => parking = v!)),
                  CheckboxListTile(value: wifi, title: const Text("WiFi Ready"), onChanged: (v) => setState(() => wifi = v!)),
                  CheckboxListTile(value: furnished, title: const Text("Furnished"), onChanged: (v) => setState(() => furnished = v!)),
                  CheckboxListTile(value: pets, title: const Text("Pets Allowed"), onChanged: (v) => setState(() => pets = v!)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _saveUnit,
                      icon: Icon(editing ? Icons.save : Icons.add_home),
                      label: Text(editing ? "Update Unit" : "Save Unit"),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _photoPickerButton() {
    return InkWell(
      onTap: _pickImages,
      child: Container(
        width: 120,
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[400]!)),
        child: const Icon(Icons.add_a_photo, color: Colors.grey),
      ),
    );
  }

  Widget _photoPreview(File file) {
    return Padding(padding: const EdgeInsets.only(left: 8), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(file, width: 120, height: 120, fit: BoxFit.cover)));
  }

  Widget _photoPreviewUrl(String url) {
    return Padding(padding: const EdgeInsets.only(left: 8), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(url, width: 120, height: 120, fit: BoxFit.cover)));
  }

  Widget _numberField(TextEditingController c, String l) => TextFormField(controller: c, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: l), validator: (v) => v == null || v.isEmpty ? "Required" : null);
  Widget _textField(TextEditingController c, String l) => TextFormField(controller: c, decoration: InputDecoration(labelText: l), validator: (v) => v == null || v.isEmpty ? "Required" : null);
}
