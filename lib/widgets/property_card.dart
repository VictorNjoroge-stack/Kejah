import 'package:flutter/material.dart';

import '../models/property.dart';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 28,
          child: Icon(Icons.home),
        ),
        title: Text(property.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(property.location),
            Text(
              "KES ${property.price.toStringAsFixed(0)} / month",
            ),
            Text(property.type),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}