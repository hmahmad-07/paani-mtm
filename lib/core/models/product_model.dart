class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final double? refillPrice;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    this.refillPrice,
  });
}

class CartItem {
  final ProductModel product;
  int quantity;
  bool isRefill;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isRefill = false,
  });
}
