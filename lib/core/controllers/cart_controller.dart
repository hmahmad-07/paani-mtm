import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

// ============================================================
//  Cart Item - API Based (No ProductModel)
// ============================================================
class CartItem {
  final Map<String, dynamic> product;
  int quantity;
  bool isRefill;

  CartItem({required this.product, this.quantity = 1, this.isRefill = false});
}

// ============================================================
//  Cart Controller
// ============================================================
class CartController extends ChangeNotifier {
  static const String _kCartKey = 'cart_items';

  CartController() {
    _loadCart();
  }
  bool homeLoaded = false;
  bool isPlacingOrder = false;

  void setPlacingOrder(bool value) {
    isPlacingOrder = value;
    notifyListeners();
  }

  void setHomeLoaded() {
    homeLoaded = true;
    notifyListeners();
  }

  // ================================================================ Products =================================================================

  List<Map<String, dynamic>> productList = [];
  bool isLoadingProducts = false;

  Future<void> fetchProducts() async {
    try {
      isLoadingProducts = true;

      final dio = Dio();

      var url =
          '${Constants.baseUrl}itemlist_cspmobile.php?id=${Constants.entityID}';

      final response = await dio.request(
        url,
        options: Options(
          method: 'GET',
          headers: {'Accept': 'application/json'},
        ),
      );

      log('URL: $url');
      log('Response: $response');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['error'] == 0) {
          final List rawList = data['products'];

          productList = rawList.map((item) {
            return <String, dynamic>{
              'ENTITY_NO': item['ENTITY_NO']?.toString() ?? '',
              'ITEM_ID': item['ITEM_ID']?.toString() ?? '',
              'ITEM_NAME': item['ITEM_NAME']?.toString() ?? '',
              'DESCRIPTION': item['DESCRIPTION']?.toString() ?? '',
              'IMAGE_URL': item['IMAGE_URL']?.toString() ?? '',
              'PRICE': item['PRICE']?.toString() ?? '0',
              'STOCK_QTY': item['STOCK_QTY']?.toString() ?? '0',
            };
          }).toList();

          log('Products loaded: ${productList.length}');
        } else {
          log('Products error: ${data['error_msg']}');
          productList = [];
        }
      }
    } on DioException catch (e) {
      log('Dio error fetching products: ${e.response?.data}');
      productList = [];
    } catch (e) {
      log('Unexpected error fetching products: $e');
      productList = [];
    } finally {
      isLoadingProducts = false;
      notifyListeners();
    }
  }

  // ================================================================ Cart =================================================================

  final Map<String, CartItem> cartItems = {};

  int get itemQuantity => cartItems.length;

  double get totalAmount {
    double total = 0.0;
    cartItems.forEach((key, cartItem) {
      final double price =
          double.tryParse(cartItem.product['PRICE'] ?? '0') ?? 0.0;
      total += price * cartItem.quantity;
    });
    return total;
  }

  void addToCart(
    Map<String, dynamic> product, {
    bool isRefill = false,
    int quantity = 1,
  }) {
    final String itemId = product['ITEM_ID'] ?? '';
    final cartKey = isRefill ? '${itemId}_refill' : itemId;

    if (cartItems.containsKey(cartKey)) {
      cartItems[cartKey]!.quantity += quantity;
    } else {
      cartItems.putIfAbsent(
        cartKey,
        () =>
            CartItem(product: product, quantity: quantity, isRefill: isRefill),
      );
    }
    notifyListeners();
    _saveCart();
  }

  void removeFromCart(String cartKey) {
    cartItems.remove(cartKey);
    notifyListeners();
    _saveCart();
  }

  void incrementQuantity(String cartKey) {
    if (cartItems.containsKey(cartKey)) {
      cartItems[cartKey]!.quantity += 1;
      notifyListeners();
      _saveCart();
    }
  }

  void decrementQuantity(String cartKey) {
    if (cartItems.containsKey(cartKey)) {
      if (cartItems[cartKey]!.quantity > 1) {
        cartItems[cartKey]!.quantity -= 1;
      } else {
        cartItems.remove(cartKey);
      }
      notifyListeners();
      _saveCart();
    }
  }

  /// Set an item's quantity explicitly. If [product] is provided and the
  /// item doesn't exist yet, it will be created. If [quantity] <= 0 the
  /// item will be removed. Saves state after mutation.
  void setItemQuantity(
    String cartKey,
    Map<String, dynamic>? product,
    int quantity, {
    bool isRefill = false,
  }) {
    if (quantity <= 0) {
      cartItems.remove(cartKey);
      notifyListeners();
      _saveCart();
      return;
    }

    if (cartItems.containsKey(cartKey)) {
      cartItems[cartKey]!.quantity = quantity;
      cartItems[cartKey]!.isRefill = isRefill;
    } else {
      if (product != null && product.isNotEmpty) {
        cartItems[cartKey] = CartItem(
          product: product,
          quantity: quantity,
          isRefill: isRefill,
        );
      }
    }

    notifyListeners();
    _saveCart();
  }

  int getQuantity(String cartKey) {
    return cartItems[cartKey]?.quantity ?? 0;
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
    _saveCart();
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> serializable = {};
      cartItems.forEach((key, item) {
        serializable[key] = {
          'product': item.product,
          'quantity': item.quantity,
          'isRefill': item.isRefill,
        };
      });
      await prefs.setString(_kCartKey, json.encode(serializable));
    } catch (e) {
      log('Error saving cart: $e');
    }
  }

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_kCartKey);
      if (data == null || data.isEmpty) return;
      final Map<String, dynamic> decoded = json.decode(data);
      cartItems.clear();
      decoded.forEach((key, value) {
        try {
          final prod = Map<String, dynamic>.from(value['product'] ?? {});
          final qty = (value['quantity'] is int)
              ? value['quantity']
              : int.tryParse(value['quantity']?.toString() ?? '0') ?? 0;
          final isRefill = value['isRefill'] == true;
          if (prod.isNotEmpty && qty > 0) {
            cartItems[key] = CartItem(
              product: prod,
              quantity: qty,
              isRefill: isRefill,
            );
          }
        } catch (_) {}
      });
      notifyListeners();
    } catch (e) {
      log('Error loading cart: $e');
    }
  }

  // ================================================================ Place Order =================================================================

  Future<bool> placeOrder() async {
    try {
      setPlacingOrder(true);

      final List<Map<String, dynamic>> orderItems = cartItems.values.map((
        item,
      ) {
        final product = item.product;
        return {
          'item_id': int.tryParse(product['ITEM_ID']?.toString() ?? '0') ?? 0,
          'item_name': product['ITEM_NAME'],
          'price': double.tryParse(product['PRICE']?.toString() ?? '0') ?? 0.0,
          'quantity': item.quantity,
        };
      }).toList();

      final String itemsJson = json.encode(orderItems);

      final formDataMap = {
        'is_external_client': '1',
        'entity_no': Constants.entityID,
        'created_at': DateTime.now().toIso8601String(),
        'items': itemsJson,
      };

      log('Order Payload: $formDataMap');

      final dio = Dio();
      final data = FormData.fromMap(formDataMap);

      final response = await dio.request(
        '${Constants.baseUrl}submit_visit_order.php',
        options: Options(method: 'POST'),
        data: data,
      );

      log('Order Response: ${response.data}');

      if (response.statusCode == 200) {
        clearCart();
        return true;
      }
      return false;
    } catch (e) {
      log('Error placing order: $e');
      return false;
    } finally {
      setPlacingOrder(false);
    }
  }
}
