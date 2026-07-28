import 'package:flutter/material.dart';

class RevenueSummaryCard extends StatelessWidget {
  final double collectedRevenue;
  final double expectedRevenue;

  const RevenueSummaryCard({
    super.key,
    required this.collectedRevenue,
    required this.expectedRevenue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double progress = expectedRevenue <= 0
        ? 0
        : (collectedRevenue / expectedRevenue).clamp(0.0, 1.0);

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
                  Colors.green.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.payments_rounded,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Revenue",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              "KES ${collectedRevenue.toStringAsFixed(2)}",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Expected: KES ${expectedRevenue.toStringAsFixed(2)}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(progress * 100).toStringAsFixed(0)}% collected",
                style: theme.textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}