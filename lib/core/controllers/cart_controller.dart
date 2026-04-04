import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartController extends ChangeNotifier {
  bool homeLoaded = false;

  void setHomeLoaded() {
    homeLoaded = true;
    notifyListeners();
  }

  // Dummy Products for Home View
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
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addToCart(ProductModel product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity += 1;
    } else {
      _cartItems.putIfAbsent(product.id, () => CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!.quantity += 1;
      notifyListeners();
    } else {
      // If attempting to increment from home but it isn't in cart, add it.
      final prod = products.firstWhere((p) => p.id == productId);
      addToCart(prod);
    }
  }

  void decrementQuantity(String productId) {
    if (_cartItems.containsKey(productId)) {
      if (_cartItems[productId]!.quantity > 1) {
        _cartItems[productId]!.quantity -= 1;
      } else {
        _cartItems.remove(productId);
      }
      notifyListeners();
    }
  }

  int getQuantity(String productId) {
    if (_cartItems.containsKey(productId)) {
      return _cartItems[productId]!.quantity;
    }
    return 0;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
