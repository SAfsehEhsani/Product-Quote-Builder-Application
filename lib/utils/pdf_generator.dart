// pdf generator placeholder (logic provided earlier)
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/line_item.dart';

class PdfGenerator {
  static Future<Uint8List> generateQuotePdf({
    required String clientName,
    required String clientAddress,
    required String reference,
    required List<LineItem> items,
    required double subtotal,
  }) async {
    final pdf = pw.Document();
    final currency = NumberFormat.simpleCurrency(decimalDigits: 2);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("QUOTATION",
              style: pw.TextStyle(
                  fontSize: 28, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Bill To:",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text(clientName),
                  pw.Text(clientAddress),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Ref: $reference"),
                  pw.Text(
                    "Date: ${DateTime.now().toString().split(' ')[0]}",
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Divider(),

          // Header
          pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Row(children: [
              pw.Expanded(
                  flex: 4,
                  child: pw.Text("Item",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(
                  child: pw.Text("Qty",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(
                  child: pw.Text("Rate",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(
                  child: pw.Text("Tax",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(
                  child: pw.Text("Total",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            ]),
          ),

          ...items.map((it) {
            return pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Row(children: [
                pw.Expanded(flex: 4, child: pw.Text(it.name)),
                pw.Expanded(child: pw.Text(it.quantity.toStringAsFixed(2))),
                pw.Expanded(child: pw.Text(currency.format(it.rate))),
                pw.Expanded(child: pw.Text("${it.taxPercent}%")),
                pw.Expanded(
                    child: pw.Text(currency.format(it.lineTotal()))),
              ]),
            );
          }),

          pw.SizedBox(height: 20),
          pw.Divider(),

          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Subtotal: ${currency.format(subtotal)}"),
                  pw.SizedBox(height: 8),
                  pw.Text("Grand Total: ${currency.format(subtotal)}",
                      style: pw.TextStyle(
                          fontSize: 19,
                          fontWeight: pw.FontWeight.bold)),
                ]),
          )
        ],
      ),
    );

    return pdf.save();
  }
}
