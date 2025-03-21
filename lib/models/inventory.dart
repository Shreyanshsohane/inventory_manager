class Inventory {
  final String itemName;
  final int quantity;
  final String price;
  final int threshold;
  final DateTime lastUpdated;
  final String status;

  Inventory({
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.threshold,
    required this.lastUpdated,
    required this.status,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      itemName: json['Item Name'],
      quantity: json['Quantity'],
      price: json['Price'],
      threshold: json['Threshold'],
      lastUpdated: DateTime.parse(json['Last Updated']),
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Item Name': itemName,
      'Quantity': quantity,
      'Price': price,
      'Threshold': threshold,
      'Last Updated': lastUpdated.toIso8601String(),
      'Status': status,
    };
  }
}
