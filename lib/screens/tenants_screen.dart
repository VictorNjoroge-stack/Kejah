import 'package:flutter/material.dart';
import '../data/tenant_data.dart';
import 'add_tenant_screen.dart';

class TenantsScreen extends StatefulWidget {
  const TenantsScreen({super.key});

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  @override
  Widget build(BuildContext context) {
    final tenants = TenantData.tenants;

    return Scaffold(
      appBar: AppBar(title: const Text('Tenants')),
      body: tenants.isEmpty
          ? const Center(child: Text('No tenants added yet'))
          : ListView.builder(
        itemCount: tenants.length,
        itemBuilder: (context, index) {
          final tenant = tenants[index];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(tenant['name']),
              subtitle: Text(
                '${tenant['propertyName']} • KES ${tenant['rent']}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  TenantData.deleteTenant(index);
                  setState(() {});
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTenantScreen(),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}