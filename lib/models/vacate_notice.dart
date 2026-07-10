class VacateNotice {
  final String id;
  final String houseId;
  final String tenantId;
  final String reason;
  final DateTime date;

  VacateNotice({
    required this.id,
    required this.houseId,
    required this.tenantId,
    required this.reason,
    required this.date,
  });
}