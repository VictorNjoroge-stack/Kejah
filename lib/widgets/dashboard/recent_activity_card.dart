import 'package:flutter/material.dart';

import '../../models/dashboard_activity.dart';

class RecentActivityCard extends StatelessWidget {
  final List<DashboardActivity> activities;

  const RecentActivityCard({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            Text(
              "Recent Activity",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (activities.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text("No recent activity"),
                ),
              )
            else
              ...activities.map(
                    (activity) => _ActivityTile(activity: activity),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final DashboardActivity activity;

  const _ActivityTile({
    required this.activity,
  });

  IconData _icon() {
    switch (activity.type) {
      case DashboardActivityType.payment:
        return Icons.payments_rounded;

      case DashboardActivityType.tenant:
        return Icons.person_add_alt_1_rounded;

      case DashboardActivityType.lease:
        return Icons.assignment_rounded;

      case DashboardActivityType.maintenance:
        return Icons.build_rounded;
    }
  }

  Color _color() {
    switch (activity.type) {
      case DashboardActivityType.payment:
        return Colors.green;

      case DashboardActivityType.tenant:
        return Colors.blue;

      case DashboardActivityType.lease:
        return Colors.indigo;

      case DashboardActivityType.maintenance:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _color();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(
              _icon(),
              color: color,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  activity.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _timeAgo(activity.timestamp),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays} day(s) ago";
    }

    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}