import 'package:flutter/material.dart';
import '../data/property_data.dart';
import 'add_property_screen.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  @override
  Widget build(BuildContext context) {
    final properties = PropertyData.properties;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
      ),
      body: properties.isEmpty
          ? const Center(
        child: Text('No properties yet'),
      )
          : ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.apartment),
              title: Text(property['name'] ?? ''),
              subtitle: Text(
                '${property['location']} • ${property['units']} units',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  PropertyData.deleteProperty(index);
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
              builder: (_) => const AddPropertyScreen(),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}