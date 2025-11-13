// Updated beautiful UI version placeholder (user already provided)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/line_item.dart';

class LineItemRow extends StatefulWidget {
  final LineItem item;
  final ValueChanged<LineItem> onChanged;
  final VoidCallback onRemove;

  const LineItemRow({
    required this.item,
    required this.onChanged,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  _LineItemRowState createState() => _LineItemRowState();
}

class _LineItemRowState extends State<LineItemRow> {
  late TextEditingController nameCtl;
  late TextEditingController qtyCtl;
  late TextEditingController rateCtl;
  late TextEditingController discountCtl;
  late TextEditingController taxCtl;

  @override
  void initState() {
    super.initState();
    nameCtl = TextEditingController(text: widget.item.name);
    qtyCtl = TextEditingController(text: widget.item.quantity.toString());
    rateCtl = TextEditingController(text: widget.item.rate.toString());
    discountCtl =
        TextEditingController(text: widget.item.discount.toString());
    taxCtl =
        TextEditingController(text: widget.item.taxPercent.toString());
  }

  void emit() {
    widget.onChanged(
      LineItem(
        name: nameCtl.text,
        quantity: double.tryParse(qtyCtl.text) ?? 0,
        rate: double.tryParse(rateCtl.text) ?? 0,
        discount: double.tryParse(discountCtl.text) ?? 0,
        taxPercent: double.tryParse(taxCtl.text) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.item.lineTotal();

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child:
                      input(nameCtl, "Item", onChanged: (_) => emit())),
              SizedBox(width: 10),
              Expanded(
                  child: input(qtyCtl, "Qty",
                      keyboard: TextInputType.number,
                      onChanged: (_) => emit())),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: input(rateCtl, "Rate",
                      keyboard: TextInputType.number,
                      onChanged: (_) => emit())),
              SizedBox(width: 10),
              Expanded(
                  child: input(discountCtl, "Discount",
                      keyboard: TextInputType.number,
                      onChanged: (_) => emit())),
              SizedBox(width: 10),
              Expanded(
                  child: input(taxCtl, "Tax %",
                      keyboard: TextInputType.number,
                      onChanged: (_) => emit())),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ${NumberFormat.simpleCurrency().format(total)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              IconButton(
                onPressed: widget.onRemove,
                icon: Icon(Icons.delete, color: Colors.red),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget input(TextEditingController c, String label,
      {TextInputType? keyboard, required Function(String) onChanged}) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
