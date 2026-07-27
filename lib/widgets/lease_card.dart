import 'package:flutter/material.dart';

import '../models/lease.dart';
import '../models/lease_status.dart';

class LeaseCard extends StatelessWidget {
  final Lease lease;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LeaseCard({
    super.key,
    required this.lease,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Color get statusColor {
    switch (lease.status) {
      case LeaseStatus.active:
        return Colors.green;

      case LeaseStatus.pending:
        return Colors.orange;

      case LeaseStatus.expired:
        return Colors.grey;

      case LeaseStatus.terminated:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (lease.status) {
      case LeaseStatus.active:
        return Icons.check_circle;

      case LeaseStatus.pending:
        return Icons.schedule;

      case LeaseStatus.expired:
        return Icons.history;

      case LeaseStatus.terminated:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
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
                      lease.leaseNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          color: statusColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lease.status.name.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _info(
                      "Monthly Rent",
                      "KES ${lease.monthlyRent.toStringAsFixed(0)}",
                    ),
                  ),
                  Expanded(
                    child: _info(
                      "Deposit",
                      "KES ${lease.deposit.toStringAsFixed(0)}",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _info(
                      "Start",
                      lease.startDate.toString().split(" ").first,
                    ),
                  ),
                  Expanded(
                    child: _info(
                      "End",
                      lease.endDate.toString().split(" ").first,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${lease.daysRemaining} days remaining",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(
      String title,
      String value,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}