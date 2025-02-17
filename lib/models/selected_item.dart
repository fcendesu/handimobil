class SelectedItem {
  final int id;
  final String name;
  final String brand;
  final double originalPrice;
  final int quantity;
  final double? customPrice;

  SelectedItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.originalPrice,
    required this.quantity,
    this.customPrice,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        if (customPrice != null) 'custom_price': customPrice,
      };
}
