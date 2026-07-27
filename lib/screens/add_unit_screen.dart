import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/building.dart';
import '../models/unit.dart';
import '../models/unit_status.dart';
import '../services/unit_service.dart';

class AddUnitScreen extends StatefulWidget {
  final Building building;

  /// null = Add Unit
  /// not null = Edit Unit
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

UnitStatus status = UnitStatus.vacant;

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
_serviceChargeController.text =
unit.serviceCharge.toString();
_sizeController.text = unit.size.toString();
_descriptionController.text = unit.description;

parking = unit.parking;
wifi = unit.wifiReady;
furnished = unit.furnished;
pets = unit.petsAllowed;

status = unit.status;
}
}

Future<void> _saveUnit() async {
if (!_formKey.currentState!.validate()) return;

final unit = Unit(
id: editing
? widget.unit!.id
: const Uuid().v4(),

  organizationId: widget.building.organizationId,

buildingId: widget.building.id,

unitNumber: _unitController.text.trim(),

floor: int.parse(_floorController.text),

bedrooms: int.parse(_bedroomController.text),

bathrooms: int.parse(_bathroomController.text),

size: double.parse(_sizeController.text),

monthlyRent: double.parse(_rentController.text),

deposit: double.parse(_depositController.text),

serviceCharge:
double.parse(_serviceChargeController.text),

status: status,

tenantId: editing
? widget.unit!.tenantId
: "",

leaseId: editing
? widget.unit!.leaseId
: "",

electricityMeter: editing
? widget.unit!.electricityMeter
: "",

waterMeter: editing
? widget.unit!.waterMeter
: "",

parking: parking,

wifiReady: wifi,

furnished: furnished,

petsAllowed: pets,

description:
_descriptionController.text.trim(),

amenities: editing
? widget.unit!.amenities
: const [],

photos: editing
? widget.unit!.photos
: const [],

createdAt: editing
? widget.unit!.createdAt
: DateTime.now(),
);
if (editing) {
  await _service.updateUnit(unit);
} else {
  await _service.addUnit(unit);
}

if (!mounted) return;

Navigator.pop(context);
}

Widget numberField(
    TextEditingController controller,
    String label,
    ) {
  return TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(
      decimal: true,
    ),
    decoration: InputDecoration(
      labelText: label,
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Required";
      }
      return null;
    },
  );
}

Widget textField(
    TextEditingController controller,
    String label,
    ) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Required";
      }
      return null;
    },
  );
}

@override
void dispose() {
  _unitController.dispose();
  _floorController.dispose();
  _bedroomController.dispose();
  _bathroomController.dispose();
  _rentController.dispose();
  _depositController.dispose();
  _serviceChargeController.dispose();
  _sizeController.dispose();
  _descriptionController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        editing ? "Edit Unit" : "Add Unit",
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            textField(
              _unitController,
              "Unit Number",
            ),

            numberField(
              _floorController,
              "Floor",
            ),

            numberField(
              _bedroomController,
              "Bedrooms",
            ),

            numberField(
              _bathroomController,
              "Bathrooms",
            ),

            numberField(
              _sizeController,
              "Size (sqm)",
            ),

            numberField(
              _rentController,
              "Monthly Rent",
            ),

            numberField(
              _depositController,
              "Deposit",
            ),

            numberField(
              _serviceChargeController,
              "Service Charge",
            ),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<UnitStatus>(
              initialValue: status,
              decoration: const InputDecoration(
                labelText: "Status",
              ),
              items: UnitStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                  value: status,
                  child: Text(
                    status.name.toUpperCase(),
                  ),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  status = value;
                });
              },
            ),

            const SizedBox(height: 20),

            CheckboxListTile(
              value: parking,
              title: const Text("Parking"),
              onChanged: (value) {
                setState(() {
                  parking = value ?? false;
                });
              },
            ),

            CheckboxListTile(
              value: wifi,
              title: const Text("WiFi Ready"),
              onChanged: (value) {
                setState(() {
                  wifi = value ?? false;
                });
              },
            ),

            CheckboxListTile(
              value: furnished,
              title: const Text("Furnished"),
              onChanged: (value) {
                setState(() {
                  furnished = value ?? false;
                });
              },
            ),

            CheckboxListTile(
              value: pets,
              title: const Text("Pets Allowed"),
              onChanged: (value) {
                setState(() {
                  pets = value ?? false;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveUnit,
                icon: Icon(
                  editing
                      ? Icons.save
                      : Icons.add_home,
                ),
                label: Text(
                  editing
                      ? "Update Unit"
                      : "Save Unit",
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