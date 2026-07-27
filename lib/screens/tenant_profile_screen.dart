import 'package:flutter/material.dart';

import '../models/tenant.dart';
import 'payment_record_screen.dart';

class TenantProfileScreen extends StatelessWidget {
final Tenant tenant;

const TenantProfileScreen({
super.key,
required this.tenant,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Tenant Profile"),
),
body: ListView(
padding: const EdgeInsets.all(16),
children: [
_profileCard(),

const SizedBox(height: 20),

_financialCard(),

const SizedBox(height: 20),

_propertyCard(),

const SizedBox(height: 20),

_statusCard(),

const SizedBox(height: 25),

_actions(context),

const SizedBox(height: 30),
],
),
);
}

Widget _profileCard() {
return Card(
elevation: 2,
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
children: [
const CircleAvatar(
radius: 42,
child: Icon(
Icons.person,
size: 42,
),
),

const SizedBox(height: 18),

Text(
tenant.name,
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 18),

ListTile(
leading: const Icon(Icons.phone),
title: Text(tenant.phone),
),

ListTile(
leading: const Icon(Icons.email),
title: Text(tenant.email),
),

ListTile(
leading: const Icon(Icons.badge),
title: Text(tenant.nationalId),
),
],
),
),
);
}

Widget _financialCard() {
return Card(
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"Financial Information",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const Divider(),

_row(
"Monthly Rent",
"KES ${tenant.rent.toStringAsFixed(0)}",
),

_row(
"Deposit",
"KES ${tenant.deposit.toStringAsFixed(0)}",
),
],
),
),
);
}

Widget _propertyCard() {
return Card(
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"Property",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const Divider(),

_row("Building ID", tenant.buildingId),

_row("Unit ID", tenant.unitId),

_row(
"Date Added",
tenant.createdAt
.toLocal()
.toString()
.split(' ')
.first,
),
],
),
),
);
}

Widget _statusCard() {
return Card(
child: Padding(
padding: const EdgeInsets.all(18),
child: Row(
children: [
Icon(
tenant.active
? Icons.check_circle
: Icons.cancel,
color: tenant.active
? Colors.green
: Colors.red,
),

const SizedBox(width: 12),

Text(
tenant.active
? "Active Tenant"
: "Vacated Tenant",
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
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
      icon: const Icon(Icons.payments),
      label: const Text("Record Payment"),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentRecordScreen(
              tenant: tenant,
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
            content: Text(
              "Lease module coming soon",
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
      icon: const Icon(Icons.history),
      label: const Text("Payment History"),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Payment history coming soon",
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
      icon: const Icon(Icons.warning_amber),
      label: const Text("Issue Notice"),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Notice module coming soon",
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

Widget _row(
    String title,
    String value,
    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 8,
    ),
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