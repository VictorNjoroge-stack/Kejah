class Payment {
  final String tenantName;
  final String propertyName;
  final int amount;
  final String date;

  Payment({
    required this.tenantName,
    required this.propertyName,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "tenantName": tenantName,
      "propertyName": propertyName,
      "amount": amount,
      "date": date,
    };
  }

  static Payment fromMap(Map data) {
    return Payment(
      tenantName: data["tenantName"],
      propertyName: data["propertyName"],
      amount: data["amount"],
      date: data["date"],
    );
  }
}