import 'package:flutter/material.dart';

import '../../models/unit.dart';
import '../../models/unit_status.dart';

class UnitCard extends StatelessWidget {
  final Unit unit;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UnitCard({
    super.key,
    required this.unit,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Color get statusColor {
    switch (unit.status) {
      case UnitStatus.occupied:
        return Colors.green;

      case UnitStatus.vacant:
        return Colors.orange;

      case UnitStatus.reserved:
        return Colors.blue;

      case UnitStatus.maintenance:
        return Colors.red;

      case UnitStatus.inactive:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      unit.unitNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (unit.isPublic)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.shop_outlined, size: 16, color: Colors.indigo),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      unit.status.name.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                "${unit.bedrooms} Bedroom${unit.bedrooms > 1 ? 's' : ''}",
              ),

              Text(
                "${unit.bathrooms} Bathroom${unit.bathrooms > 1 ? 's' : ''}",
              ),

              const SizedBox(height: 10),

              Text(
                "KES ${unit.monthlyRent.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}