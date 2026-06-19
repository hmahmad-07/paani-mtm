import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:paani/core/controllers/cart_controller.dart';
import 'package:provider/provider.dart';
import '../extensions/routes.dart';

class ConnectivityController extends ChangeNotifier {
  ConnectivityController() {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<dynamic>? _subscription;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  Future<void> _init() async {
    try {
      final initial = await _connectivity.checkConnectivity();
      _applyResults(initial, notify: false);
      notifyListeners();
    } catch (_) {
      _isOnline = true;
      notifyListeners();
    }

    _subscription = _connectivity.onConnectivityChanged.listen(
      _applyResults,
      onError: (_) {
        _isOnline = true;
        notifyListeners();
      },
    );
  }

  void _applyResults(dynamic resultOrList, {bool notify = true}) {
    final next = _resultsIndicateConnection(resultOrList);
    final wasOffline = !_isOnline;
    if (next == _isOnline) {
      if (notify) notifyListeners();
      return;
    }
    _isOnline = next;
    if (notify) notifyListeners();

    if (_isOnline && wasOffline) {
      _bestEffortRefreshAfterReconnect();
    }
  }

  static bool _resultsIndicateConnection(dynamic resultOrList) {
    if (resultOrList is ConnectivityResult) {
      return resultOrList != ConnectivityResult.none;
    }
    if (resultOrList is List<ConnectivityResult>) {
      if (resultOrList.isEmpty) return true;
      return resultOrList.any((r) => r != ConnectivityResult.none);
    }
    return true;
  }

  void _bestEffortRefreshAfterReconnect() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = AppRoutes.navigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      try {
        ctx.read<CartController>().fetchProducts();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
