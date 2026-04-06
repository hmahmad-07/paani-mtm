import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartController extends ChangeNotifier {
  bool homeLoaded = false;

  void setHomeLoaded() {
    homeLoaded = true;
    notifyListeners();
  }

  final List<ProductModel> products = [
    ProductModel(
      id: '1',
      name: '1.5 Litre Water Bottle',
      description:
          'Premium purified drinking water in a highly portable 1.5-litre bottle. Treated with reverse osmosis and rich in essential minerals, this water delivers a crisp and refreshing taste. Perfect for gym sessions, travel, or just keeping at your desk to ensure you stay fully hydrated throughout your busy day. The bottle is 100% recyclable.',
      imagePath: 'assets/1.5-litr.webp',
      price: 1.5,
    ),
    ProductModel(
      id: '2',
      name: '19 Litre Water Bottle',
      description:
          'Our large 19-litre dispenser bottle is the ultimate hydration solution for families and corporate offices. Sourced from natural springs and rigorously tested for purity, it provides an uninterrupted supply of crystal clear water. Designed to fit perfectly on any standard hot and cold water dispenser. Delivered directly to your doorstep with guaranteed seal protection.',
      imagePath: 'assets/19-litr-bottle.webp',
      price: 8.0,
      refillPrice: 3.5,
    ),
    ProductModel(
      id: '3',
      name: '200 ml Water Cup',
      description:
          'Convenient 200 ml disposable water cups, ideal for large gatherings, corporate events, weddings, or quick single servings. Manufactured under strict hygiene standards and sealed securely to prevent any contamination before use. Compact form factor makes it incredibly easy to distribute among crowds without fuss or spillage.',
      imagePath: 'assets/200-ml-Cup.webp',
      price: 0.3,
    ),
    ProductModel(
      id: '4',
      name: '500 ml Water Bottle',
      description:
          'Handy 500 ml mineral water bottle for quick on-the-go refreshment. Whether you are running errands, packing lunch for the kids, or taking a short walk, this compact bottle slips easily into any bag or cup holder. Every drop is UV treated and mineralized to provide maximum vitality.',
      imagePath: 'assets/500-ml.webp',
      price: 0.8,
    ),
    ProductModel(
      id: '5',
      name: '6 Litre Water Bottle',
      description:
          'The 6-litre family utility bottle strikes the perfect balance between high capacity and manageability. Ideal for small families, camping trips, or weekend getaways. It features a sturdy, ergonomic built-in handle for easy pouring and carrying. Enjoy premium filtered drinking water wherever you are without committing to the heavy 19-litre jug.',
      imagePath: 'assets/6-litr-bottle.webp',
      price: 3.5,
    ),
  ];

  final Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems => _cartItems;

  int get itemQuantity => _cartItems.length;

  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((key, cartItem) {
      final itemPrice = (cartItem.isRefill && cartItem.product.refillPrice != null)
          ? cartItem.product.refillPrice!
          : cartItem.product.price;
      total += itemPrice * cartItem.quantity;
    });
    return total;
  }

  void addToCart(ProductModel product, {bool isRefill = false, int quantity = 1}) {
    // Unique key for cart items based on product ID and refill status
    final cartKey = isRefill ? '${product.id}_refill' : product.id;

    if (_cartItems.containsKey(cartKey)) {
      _cartItems[cartKey]!.quantity += quantity;
    } else {
      _cartItems.putIfAbsent(
        cartKey,
        () => CartItem(product: product, quantity: quantity, isRefill: isRefill),
      );
    }
    notifyListeners();
  }

  void removeFromCart(String cartKey) {
    _cartItems.remove(cartKey);
    notifyListeners();
  }

  void incrementQuantity(String cartKey) {
    if (_cartItems.containsKey(cartKey)) {
      _cartItems[cartKey]!.quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String cartKey) {
    if (_cartItems.containsKey(cartKey)) {
      if (_cartItems[cartKey]!.quantity > 1) {
        _cartItems[cartKey]!.quantity -= 1;
      } else {
        _cartItems.remove(cartKey);
      }
      notifyListeners();
    }
  }

  int getQuantity(String cartKey) {
    if (_cartItems.containsKey(cartKey)) {
      return _cartItems[cartKey]!.quantity;
    }
    return 0;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
