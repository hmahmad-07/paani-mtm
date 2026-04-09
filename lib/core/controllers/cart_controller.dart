import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
  bool homeLoaded = false;

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
      notifyListeners();

      final dio = Dio();

      final response = await dio.request(
        '${Constants.baseUrl}itemlist_cspmobile.php?id=${Constants.entityID}',
        options: Options(
          method: 'GET',
          headers: {'Accept': 'application/json'},
        ),
      );

      log(response.toString());

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
  }

  void removeFromCart(String cartKey) {
    cartItems.remove(cartKey);
    notifyListeners();
  }

  void incrementQuantity(String cartKey) {
    if (cartItems.containsKey(cartKey)) {
      cartItems[cartKey]!.quantity += 1;
      notifyListeners();
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
    }
  }

  int getQuantity(String cartKey) {
    return cartItems[cartKey]?.quantity ?? 0;
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}
