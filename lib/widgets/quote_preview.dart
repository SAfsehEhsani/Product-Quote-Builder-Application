// Updated preview UI placeholder
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/line_item.dart';
import '../utils/pdf_generator.dart';
import 'package:printing/printing.dart';

class QuotePreview extends StatelessWidget {
  final String clientName;
  final String clientAddress;
  final String reference;
  final List<LineItem> items;
  final double subtotal;
  final NumberFormat currencyFormat;

  const QuotePreview({
    required this.clientName,
    required this.clientAddress,
    required this.reference,
    required this.items,
    required this.subtotal,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quote Preview"),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final pdf = await PdfGenerator.generateQuotePdf(
                clientName: clientName,
                clientAddress: clientAddress,
                reference: reference,
                items: items,
                subtotal: subtotal,
              );
              await Printing.layoutPdf(
                  onLayout: (format) async => pdf);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(22),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 4),
                    color: Colors.black12)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("QUOTATION",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
              SizedBox(height: 20),

              // Bill To
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  invoiceBlock("Bill To:", [clientName, clientAddress]),
                  invoiceBlock("Info:", [
                    "Ref: $reference",
                    "Date: ${DateTime.now().toString().split(' ')[0]}",
                  ])
                ],
              ),

              SizedBox(height: 20),
              Divider(),

              SizedBox(height: 20),

              rowHeader(),
              ...items.map((it) => rowItem(it)).toList(),

              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Subtotal: ${currencyFormat.format(subtotal)}"),
                      SizedBox(height: 8),
                      Text(
                        "Grand Total: ${currencyFormat.format(subtotal)}",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget invoiceBlock(String title, List<String> items) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ...items.map((e) => Text(e))
        ]);
  }

  Widget rowHeader() {
    return Row(children: [
      Expanded(flex: 4, child: Text("Item", style: headerStyle())),
      Expanded(child: Text("Qty", style: headerStyle())),
      Expanded(child: Text("Rate", style: headerStyle())),
      Expanded(child: Text("Tax", style: headerStyle())),
      Expanded(child: Text("Total", style: headerStyle())),
    ]);
  }

  Widget rowItem(LineItem it) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(flex: 4, child: Text(it.name)),
        Expanded(child: Text(it.quantity.toStringAsFixed(2))),
        Expanded(child: Text(currencyFormat.format(it.rate))),
        Expanded(child: Text("${it.taxPercent}%")),
        Expanded(child: Text(currencyFormat.format(it.lineTotal()))),
      ]),
    );
  }

  TextStyle headerStyle() =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
}
