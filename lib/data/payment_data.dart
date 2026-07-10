import 'package:hive/hive.dart';

class PaymentData {
  static final Box box = Hive.box('payments');

  static List get payments => box.values.toList();

  static void addPayment(Map<String, dynamic> payment) {
    box.add(payment);
  }

  static void deletePayment(int index) {
    box.deleteAt(index);
  }
}