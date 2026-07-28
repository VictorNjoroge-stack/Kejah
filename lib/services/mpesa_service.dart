import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MpesaService {
  // In a real production app, these would come from your backend or environment variables
  // and you would use a backend to securely handle the OAuth token and STK Push.
  // For this MVP, I am setting up the structure.
  
  static const String _baseUrl = "https://sandbox.safaricom.co.ke"; // Change to production for live

  Future<void> initiateStkPush({
    required String phone,
    required double amount,
    required String reference,
  }) async {
    // 1. Format Phone (must be 254...)
    String formattedPhone = phone.replaceAll('+', '');
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '254${formattedPhone.substring(1)}';
    }

    // 2. This is a conceptual implementation of the STK Push
    // Typically, you would call YOUR backend which then calls Safaricom.
    // Calling Safaricom directly from the app is not secure because it requires API Keys.
    
    print("Initiating M-Pesa STK Push for $formattedPhone, Amount: $amount, Ref: $reference");

    // TODO: Connect to your Kejah Backend M-Pesa Endpoint
    // final response = await http.post(
    //   Uri.parse('https://your-api.com/mpesa/stkpush'),
    //   body: {
    //     'phone': formattedPhone,
    //     'amount': amount.toString(),
    //     'reference': reference,
    //   },
    // );
  }
}
