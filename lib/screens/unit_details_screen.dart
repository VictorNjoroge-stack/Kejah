import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/building.dart';
import '../models/unit.dart';
import 'add_tenant_screen.dart';

class UnitDetailsScreen extends StatelessWidget {
final Building building;
final Unit unit;

const UnitDetailsScreen({
super.key,
required this.building,
required this.unit,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(unit.unitNumber),
),

body: ListView(
padding: const EdgeInsets.all(16),
children: [

_header(),

const SizedBox(height: 20),

_unitInfo(),

const SizedBox(height: 20),

_utilities(context),

const SizedBox(height: 20),

_amenities(),

const SizedBox(height: 25),

_actions(context),

const SizedBox(height: 40),
],
),
);
}

Widget _header() {
return Card(
elevation: 2,
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
children: [

Text(
unit.unitNumber,
style: const TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

Chip(
label: Text(
unit.status.name.toUpperCase(),
),
),

const SizedBox(height: 12),

Text(
building.name,
style: const TextStyle(
color: Colors.grey,
),
),
],
),
),
);
}

Widget _unitInfo() {
return Card(
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

const Text(
"Unit Information",
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 20,
),
),

const Divider(),

_row(
"Bedrooms",
"${unit.bedrooms}",
),

_row(
"Bathrooms",
"${unit.bathrooms}",
),

_row(
"Floor",
"${unit.floor}",
),

_row(
"Size",
"${unit.size} sqm",
),

_row(
"Monthly Rent",
"KES ${unit.monthlyRent.toStringAsFixed(0)}",
),

_row(
"Deposit",
"KES ${unit.deposit.toStringAsFixed(0)}",
),

_row(
"Service Charge",
"KES ${unit.serviceCharge.toStringAsFixed(0)}",
),
],
),
),
);
}

Widget _utilities(BuildContext context) {
return Card(
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"Utilities",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const Divider(),

ListTile(
leading: const Icon(
Icons.electric_bolt,
color: Colors.amber,
),
title: const Text("Electricity"),
subtitle: Text(
unit.electricityMeter.isEmpty
? "No meter assigned"
: unit.electricityMeter,
),
trailing: IconButton(
icon: const Icon(Icons.copy),
tooltip: "Copy Meter",
onPressed: unit.electricityMeter.isEmpty
? null
: () {
Clipboard.setData(
ClipboardData(
text: unit.electricityMeter,
),
);

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
"Electricity meter copied",
),
),
);
},
),
),

const Divider(),

ListTile(
leading: const Icon(
Icons.water_drop,
color: Colors.blue,
),
title: const Text("Water"),
subtitle: Text(
unit.waterMeter.isEmpty
? "No meter assigned"
: unit.waterMeter,
),
trailing: IconButton(
icon: const Icon(Icons.copy),
tooltip: "Copy Meter",
onPressed: unit.waterMeter.isEmpty
? null
: () {
Clipboard.setData(
ClipboardData(
text: unit.waterMeter,
),
);

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text( "Water meter copied",
),
),
);
},
),
),
],
),
),
);
}

Widget _amenities() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Amenities",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(),

          if (unit.parking)
            const ListTile(
              leading: Icon(Icons.local_parking),
              title: Text("Parking"),
            ),

          if (unit.wifiReady)
            const ListTile(
              leading: Icon(Icons.wifi),
              title: Text("Wi-Fi Ready"),
            ),

          if (unit.furnished)
            const ListTile(
              leading: Icon(Icons.chair),
              title: Text("Furnished"),
            ),

          if (unit.petsAllowed)
            const ListTile(
              leading: Icon(Icons.pets),
              title: Text("Pets Allowed"),
            ),

          if (!unit.parking &&
              !unit.wifiReady &&
              !unit.furnished &&
              !unit.petsAllowed)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text("No amenities assigned."),
            ),
        ],
      ),
    ),
  );
}

Widget _actions(BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text("Assign Tenant"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTenantScreen(
                      building: building,
                      unit: unit,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.description),
              label: const Text("Create Lease"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Create Lease coming soon"),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.payments),
              label: const Text("Record Payment"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Record Payment coming soon"),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.warning_amber),
              label: const Text("Issue Notice"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Issue Notice coming soon"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _row(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value),
        ),
      ],
    ),
  );
}
}