import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/building.dart';
import '../models/unit.dart';
import '../services/unit_service.dart';

class UnitScreen extends StatefulWidget {
  final Building building;

  const UnitScreen({
    super.key,
    required this.building,
  });

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  final UnitService _service = UnitService();

  Future<void> _addUnitDialog() async {
    final numberController = TextEditingController();
    final rentController = TextEditingController();
    final depositController = TextEditingController();

    String type = "Apartment";

    int bedrooms = 1;
    int bathrooms = 1;

    bool furnished = false;
    bool parking = false;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Unit"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  TextField(
                    controller: numberController,
                    decoration: const InputDecoration(
                      labelText: "Unit Number",
                    ),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: type,
                    items: const [
                      DropdownMenuItem(
                        value: "Apartment",
                        child: Text("Apartment"),
                      ),
                      DropdownMenuItem(
                        value: "Studio",
                        child: Text("Studio"),
                      ),
                      DropdownMenuItem(
                        value: "Bedsitter",
                        child: Text("Bedsitter"),
                      ),
                      DropdownMenuItem(
                        value: "Maisonette",
                        child: Text("Maisonette"),
                      ),
                      DropdownMenuItem(
                        value: "Shop",
                        child: Text("Shop"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        type = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [

                      Expanded(
                        child: TextFormField(
                          initialValue: "1",
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Bedrooms",
                          ),
                          onChanged: (v) {
                            bedrooms = int.tryParse(v) ?? 1;
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextFormField(
                          initialValue: "1",
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Bathrooms",
                          ),
                          onChanged: (v) {
                            bathrooms = int.tryParse(v) ?? 1;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: rentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Monthly Rent",
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: depositController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Deposit",
                    ),
                  ),

                  SwitchListTile(
                    value: furnished,
                    title: const Text("Furnished"),
                    onChanged: (v) {
                      setState(() {
                        furnished = v;
                      });
                    },
                  ),

                  SwitchListTile(
                    value: parking,
                    title: const Text("Parking"),
                    onChanged: (v) {
                      setState(() {
                        parking = v;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {

              final unit = Unit(
                id: const Uuid().v4(),
                buildingId: widget.building.id,
                unitNumber: numberController.text,
                unitType: type,
                bedrooms: bedrooms,
                bathrooms: bathrooms,
                rent: double.tryParse(rentController.text) ?? 0,
                deposit: double.tryParse(depositController.text) ?? 0,
                occupied: false,
                furnished: furnished,
                parking: parking,
                status: "Vacant",
                tenantId: null,
                images: const [],
              );

              await _service.addUnit(unit);

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget statCard(String title, Stream<int> stream, Color color) {
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "${snapshot.data ?? 0}",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(title),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.building.name),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addUnitDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                Expanded(
                  child: statCard(
                    "Units",
                    _service.totalUnits(widget.building.id),
                    Colors.blue,
                  ),
                ),

                Expanded(
                  child: statCard(
                    "Occupied",
                    _service.occupiedCount(widget.building.id),
                    Colors.green,
                  ),
                ),

                Expanded(
                  child: statCard(
                    "Vacant",
                    _service.vacantCount(widget.building.id),
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Unit>>(
              stream: _service.getUnits(widget.building.id),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final units = snapshot.data!;

                if (units.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Units Yet",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: units.length,
                  itemBuilder: (context, index) {

                    final unit = units[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(unit.unitNumber),
                        ),
                        title: Text(
                          "${unit.bedrooms} BR • ${unit.unitType}",
                        ),
                        subtitle: Text(
                          "KES ${unit.rent.toStringAsFixed(0)}",
                        ),
                        trailing: Chip(
                          label: Text(unit.status),
                          backgroundColor: unit.occupied
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}