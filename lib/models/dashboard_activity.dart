class DashboardActivity {
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final DashboardActivityType type;

  const DashboardActivity({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
  });
}

enum DashboardActivityType {
  payment,
  tenant,
  lease,
  maintenance,
}