class LineItem {
  String name;
  double quantity;
  double rate;
  double discount;
  double taxPercent;

  LineItem({
    required this.name,
    required this.quantity,
    required this.rate,
    required this.discount,
    required this.taxPercent,
  });

  factory LineItem.empty() =>
      LineItem(name: "", quantity: 1, rate: 0, discount: 0, taxPercent: 0);

  double get baseAmount => (rate - discount) * quantity;

  double get taxAmount => (baseAmount * taxPercent) / 100;

  double lineTotal() => baseAmount + taxAmount;

  double totalFromInclusive(double totalWithTax) =>
      totalWithTax / (1 + taxPercent / 100);
}

