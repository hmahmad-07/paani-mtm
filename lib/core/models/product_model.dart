class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
  });

  // Since it's dummy data, we avoid immutability pain for now and let the CartController handle quantity
}

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
