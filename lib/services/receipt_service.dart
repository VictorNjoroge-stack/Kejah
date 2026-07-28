import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/payment.dart';
import '../models/organization.dart';
import '../models/tenant.dart';
import '../models/building.dart';
import '../models/unit.dart';

class ReceiptService {
  static Future<void> generateAndShowReceipt({
    required Payment payment,
    required Organization org,
    required Tenant tenant,
    required Building building,
    required Unit unit,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: org.currencyCode + ' ');

    pw.MemoryImage? logoImage;
    if (org.logoUrl != null && org.logoUrl!.isNotEmpty) {
      try {
        final logoProvider = await networkImage(org.logoUrl!);
        logoImage = logoProvider;
      } catch (e) {
        print("Error loading logo for receipt: $e");
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        if (logoImage != null)
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(right: 12),
                            child: pw.Image(logoImage, width: 50, height: 50),
                          ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(org.name, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                            pw.Text(org.address),
                            pw.Text(org.phone),
                            pw.Text(org.email),
                          ],
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('OFFICIAL RECEIPT', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo)),
                        pw.Text('No: ${payment.id.substring(0, 8).toUpperCase()}'),
                        pw.Text('Date: ${dateFormat.format(payment.paymentDate)}'),
                      ],
                    ),
                  ],
                ),
                pw.Divider(thickness: 2, color: PdfColors.grey300),
                pw.SizedBox(height: 20),

                // Received From
                pw.Row(
                  children: [
                    pw.Text('Received From: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(tenant.name),
                  ],
                ),
                pw.SizedBox(height: 10),

                // Property Details
                pw.Row(
                  children: [
                    pw.Text('Property: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${building.name} - Unit ${unit.unitNumber}'),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Table Header
                pw.Container(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Row(
                    children: [
                      pw.Expanded(child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),

                // Table Row
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Row(
                    children: [
                      pw.Expanded(child: pw.Text('Rent / Utility Payment (${payment.paymentMethod})')),
                      pw.Text(currencyFormat.format(payment.amount)),
                    ],
                  ),
                ),
                pw.Divider(color: PdfColors.grey300),

                // Total
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text('Total Paid: ', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Text(currencyFormat.format(payment.amount), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                    ],
                  ),
                ),

                pw.SizedBox(height: 40),
                
                // Footer
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Reference: ${payment.reference}'),
                    if (payment.notes.isNotEmpty) pw.Text('Notes: ${payment.notes}'),
                  ],
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Text('Generated by Kejah - Property Management System', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Receipt_${payment.id.substring(0, 8)}.pdf',
    );
  }
}
