import 'package:flutter/material.dart';

class OccupancySummaryCard extends StatelessWidget {
  final int occupiedUnits;
  final int vacantUnits;

  const OccupancySummaryCard({
    super.key,
    required this.occupiedUnits,
    required this.vacantUnits,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final int totalUnits = occupiedUnits + vacantUnits;

    final double occupancyRate = totalUnits == 0
        ? 0
        : occupiedUnits / totalUnits;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                  Colors.blue.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.home_work_rounded,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Occupancy",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              "${(occupancyRate * 100).toStringAsFixed(1)}%",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "$occupiedUnits Occupied • $vacantUnits Vacant",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: occupancyRate,
                minHeight: 10,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _StatusTile(
                    label: "Occupied",
                    value: occupiedUnits.toString(),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatusTile(
                    label: "Vacant",
                    value: vacantUnits.toString(),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}