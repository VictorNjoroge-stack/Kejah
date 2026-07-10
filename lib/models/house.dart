import 'house_status.dart';

class House {
  final String id;
  final String buildingId;
  final String houseNumber;
  final double monthlyRent;

  HouseStatus status;

  DateTime? lastPaymentDate;
  DateTime? vacateNoticeDate;

  House({
    required this.id,
    required this.buildingId,
    required this.houseNumber,
    required this.monthlyRent,
    this.status = HouseStatus.vacant,
    this.lastPaymentDate,
    this.vacateNoticeDate,
  });
}