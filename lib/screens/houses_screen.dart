import 'package:flutter/material.dart';

import '../models/building.dart';
import '../models/house.dart';
import '../models/tenant.dart';
import '../models/payment.dart';
import '../state/app_state.dart';

class HousesScreen extends StatefulWidget {
  final Building building;

  const HousesScreen({super.key, required this.building});

  @override
  State<HousesScreen> createState() => _HousesScreenState();
}

class _HousesScreenState extends State<HousesScreen> {
  final AppState app = AppState.instance;

  void _addHouse(String number, double rent) {
    app.addHouse(
      House(
        id: DateTime.now().toString(),
        buildingId: widget.building.id,
        houseNumber: number,
        monthlyRent: rent,
      ),
    );
    setState(() {});
  }

  void _assignTenant(String houseId) {
    final name = TextEditingController();
    final phone = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone")),
            ElevatedButton(
              onPressed: () {
                app.addTenant(
                  Tenant(
                    id: DateTime.now().toString(),
                    name: name.text,
                    phone: phone.text,
                    houseId: houseId,
                  ),
                );

                app.markOccupied(houseId);

                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Assign"),
            )
          ],
        ),
      ),
    );
  }

  void _addPayment(String houseId, String tenantId) {
    final amount = TextEditingController();
    final ref = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: amount, keyboardType: TextInputType.number),
            TextField(controller: ref),
            ElevatedButton(
              onPressed: () {
                app.addPayment(
                  Payment(
                    id: DateTime.now().toString(),
                    tenantId: tenantId,
                    houseId: houseId,
                    amount: double.parse(amount.text),
                    reference: ref.text,
                    date: DateTime.now(),
                  ),
                );

                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final houses = app.housesByBuilding(widget.building.id);

    return Scaffold(
      appBar: AppBar(title: Text(widget.building.name)),
      body: houses.isEmpty
          ? const Center(child: Text("No houses yet"))
          : ListView.builder(
        itemCount: houses.length,
        itemBuilder: (_, i) {
          final h = houses[i];
          final tenant = app.getTenantByHouse(h.id);
          final paid = app.totalPaid(h.id);

          return Card(
            child: ExpansionTile(
              title: Text("House ${h.houseNumber}"),
              subtitle: Text(
                h.status.name.toUpperCase(),
              ),
              children: [
                ListTile(
                  title: Text("Rent: ${h.monthlyRent}"),
                  subtitle: Text("Paid: $paid"),
                ),
                if (tenant == null)
                  TextButton(
                    onPressed: () => _assignTenant(h.id),
                    child: const Text("Assign Tenant"),
                  )
                else
                  TextButton(
                    onPressed: () =>
                        _addPayment(h.id, tenant.id),
                    child: const Text("Add Payment"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}