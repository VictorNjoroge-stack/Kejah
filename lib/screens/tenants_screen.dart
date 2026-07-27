import 'package:flutter/material.dart';

import '../models/tenant.dart';
import '../services/tenant_service.dart';
import 'tenant_profile_screen.dart';

class TenantsScreen extends StatelessWidget {
TenantsScreen({super.key});

final TenantService _service = TenantService();

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Tenants"),
),
body: StreamBuilder<List<Tenant>>(
stream: _service.getTenants(),
builder: (context, snapshot) {
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
}

final tenants = snapshot.data ?? [];

if (tenants.isEmpty) {
return const Center(
child: Text(
"No tenants found.\n\nAssign a tenant from a Unit.",
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 18,
),
),
);
}

return ListView.separated(
padding: const EdgeInsets.all(16),
itemCount: tenants.length,
  separatorBuilder: (context, index) =>
  const SizedBox(height: 12),
itemBuilder: (context, index) {
final tenant = tenants[index];

return Card(
elevation: 3,
child: InkWell(
borderRadius:
BorderRadius.circular(12),
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
TenantProfileScreen(
tenant: tenant,
),
),
);
},
child: Padding(
padding:
const EdgeInsets.all(16),
child: Row(
children: [
const CircleAvatar(
radius: 28,
child: Icon(
Icons.person,
),
),

const SizedBox(width: 16),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment
.start,
children: [
Text(
tenant.name,
style:
const TextStyle(
fontSize: 18,
fontWeight:
FontWeight
.bold,
),
),

const SizedBox(
height: 6,
),

Text(
tenant.phone,
),

const SizedBox(
height: 4,
),

Text(
"Unit: ${tenant.unitId}",
),

const SizedBox(
height: 4,
),

Text(
"Rent: KES ${tenant.rent.toStringAsFixed(0)}",
),

const SizedBox(
height: 8,
),

Chip(
label: Text(
tenant.active
? "ACTIVE"
: "VACATED",
),
avatar: Icon(
tenant.active
? Icons
.check_circle
: Icons.cancel,
size: 18,
),
),
],
),
),

PopupMenuButton<String>(
onSelected:
(value) async {
if (value ==
"delete") {
await _service
.deleteTenant(
tenant.id,
);
}
},
itemBuilder: (_) =>
const [PopupMenuItem(
  value: "delete",
  child: Text("Delete"),
),
],
),
],
),
),
),
);
},
);
},
),
);
}
}