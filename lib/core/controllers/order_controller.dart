import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../models/order_model.dart';

class OrderController extends ChangeNotifier {
  final Dio _dio = Dio();
  List<Order> _orders = [];
  bool _isLoading = true;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders(String entityNo) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.request(
        '${Constants.baseUrl}tsm_daily_report.php?is_external_client=1&entity_no=$entityNo',
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        final orderResponse = OrderResponse.fromJson(response.data);
        _orders = orderResponse.orders;
      } else {
        debugPrint('Error fetching orders: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Exception fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
