class OrderResponse {
  final int error;
  final String errorMsg;
  final String entityNo;
  final String date;
  final int totalOrders;
  final List<Order> orders;

  OrderResponse({
    required this.error,
    required this.errorMsg,
    required this.entityNo,
    required this.date,
    required this.totalOrders,
    required this.orders,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      error: json['error'] ?? 0,
      errorMsg: json['error_msg'] ?? '',
      entityNo: json['entity_no'] ?? '',
      date: json['date'] ?? '',
      totalOrders: json['total_orders'] ?? 0,
      orders:
          (json['orders'] as List?)?.map((i) => Order.fromJson(i)).toList() ??
          [],
    );
  }
}

class Order {
  final String id;
  final String entityNo;
  final String entityName;
  final bool isProductive;
  final String? remarks;
  final String orderDate;
  final String createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.entityNo,
    required this.entityName,
    required this.isProductive,
    this.remarks,
    required this.orderDate,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      entityNo: json['entity_no'] ?? '',
      entityName: json['entity_name'] ?? '',
      isProductive: json['is_productive'] ?? false,
      remarks: json['remarks'],
      orderDate: json['order_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      items:
          (json['items'] as List?)
              ?.map((i) => OrderItem.fromJson(i))
              .toList() ??
          [],
    );
  }

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.totalAmount);
  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.qtyPcs + (item.qtyBox * 0));
}

class OrderItem {
  final String id;
  final String itemId;
  final String itemName;
  final int qtyPcs;
  final int qtyBox;
  final int qtyFoc;
  final double rate;
  final double totalAmount;

  OrderItem({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.qtyPcs,
    required this.qtyBox,
    required this.qtyFoc,
    required this.rate,
    required this.totalAmount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      itemId: json['item_id'] ?? '',
      itemName: json['item_name'] ?? '',
      qtyPcs: json['qty_pcs'] ?? 0,
      qtyBox: json['qty_box'] ?? 0,
      qtyFoc: json['qty_foc'] ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
