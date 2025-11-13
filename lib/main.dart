import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/line_item.dart';
import 'widgets/line_item_row.dart';
import 'widgets/quote_preview.dart';

void main() {
  runApp(QuoteApp());
}

class QuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Quote Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: QuoteHomePage(),
    );
  }
}

class QuoteHomePage extends StatefulWidget {
  @override
  _QuoteHomePageState createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {
  final _clientNameCtl = TextEditingController();
  final _clientAddressCtl = TextEditingController();
  final _referenceCtl = TextEditingController();

  List<LineItem> items = [];

  @override
  void initState() {
    super.initState();
    items.add(LineItem.empty());
  }

  void addItem() => setState(() => items.add(LineItem.empty()));
  void removeItem(int i) => setState(() => items.removeAt(i));

  void updateItem(int i, LineItem item) => setState(() => items[i] = item);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.lineTotal());

  void openPreview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuotePreview(
          clientName: _clientNameCtl.text,
          clientAddress: _clientAddressCtl.text,
          reference: _referenceCtl.text,
          items: items,
          subtotal: subtotal,
          currencyFormat:
              NumberFormat.simpleCurrency(decimalDigits: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addItem,
        icon: Icon(Icons.add),
        label: Text("Add Item"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3eaff), Color(0xfff7f9ff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Quote Builder",
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),

                SizedBox(height: 20),

                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Client Info",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      appInput(_clientNameCtl, "Client Name"),
                      appInput(_clientAddressCtl, "Client Address"),
                      appInput(_referenceCtl, "Reference"),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Text("Line Items",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                SizedBox(height: 10),

                glassCard(
                  child: Column(
                    children: List.generate(
                      items.length,
                      (i) => Column(
                        children: [
                          LineItemRow(
                            item: items[i],
                            onChanged: (it) => updateItem(i, it),
                            onRemove: () => removeItem(i),
                          ),
                          SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                glassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal",
                          style: TextStyle(fontSize: 18)),
                      Text(
                        NumberFormat.simpleCurrency()
                            .format(subtotal),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 30),

                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 16),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: openPreview,
                    label: Text("Preview & Export PDF"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appInput(TextEditingController c, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget glassCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 4),
            color: Colors.black12,
          )
        ],
      ),
      child: child,
    );
  }
}

