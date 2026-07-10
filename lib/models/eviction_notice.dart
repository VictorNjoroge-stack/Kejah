class EvictionNotice {
  final String id;
  final String houseId;
  final String tenantId;
  final String reason;
  final DateTime date;

  EvictionNotice({
    required this.id,
    required this.houseId,
    required this.tenantId,
    required this.reason,
    required this.date,
  });
}