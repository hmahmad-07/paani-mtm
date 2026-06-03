import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paani/core/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/controllers/order_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/order_model.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';
import '../../../core/extensions/routes.dart';
import '../dashboard/dashboard_view.dart';

class OrderDetailView extends StatelessWidget {
  final Order order;

  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(title: 'Order Details'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            2.height,
            _buildSection(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          color: AppColor.appColor1.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          color: AppColor.appColor1,
                          size: 8.r,
                        ),
                      ),
                      4.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #ORD-${order.id}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColor.appDarkColor,
                              ),
                            ),
                            Text(
                              order.orderDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      2.width,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: .5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.r),
                          border: Border.all(
                            color: AppColor.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Confirmed',
                              style: TextStyle(
                                color: AppColor.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 3.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            3.height,
            Row(
              children: [
                Icon(Icons.shopping_bag, size: 6.r, color: AppColor.appColor2),
                2.width,
                Text(
                  'Items Ordered',
                  style: TextStyle(
                    fontSize: 5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.appDarkColor,
                  ),
                ),
              ],
            ),
            1.height,
            _buildSection(
              child: Consumer<CartController>(
                builder: (context, cartVC, child) {
                  return Column(
                    children: order.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isLast = index == order.items.length - 1;

                      final product = cartVC.productList.firstWhere(
                        (p) => p['ITEM_ID'].toString() == item.itemId,
                        orElse: () => {},
                      );
                      final imageUrl = product['IMAGE_URL'] ?? '';

                      return Column(
                        children: [
                          _buildItemRow(
                            item.itemName,
                            '${item.qtyPcs}x',
                            item.totalAmount,
                            item.itemName.toLowerCase().contains('refill'),
                            imageUrl,
                          ),
                          if (!isLast) const Divider(height: 30),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            3.height,
            Row(
              children: [
                Icon(Icons.payments, size: 6.r, color: AppColor.appColor2),
                2.width,
                Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.appDarkColor,
                  ),
                ),
              ],
            ),
            1.height,
            _buildSection(
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', order.totalAmount),
                  1.height,
                  _buildSummaryRow('Delivery Fee', 0.00),
                  const Divider(height: 30),
                  _buildSummaryRow('Total', order.totalAmount, isTotal: true),
                ],
              ),
            ),
            10.height,
            RoundButton(
              width: double.maxFinite,
              buttonColor: AppColor.appColor1,
              textColor: AppColor.white,
              title: 'Reorder Now',
              onPress: () async {
                final cartVC = context.read<CartController>();
                _showLoadingDialog(context);

                try {
                  cartVC.clearCart();
                  bool addedAny = false;
                  for (var item in order.items) {
                    final product = cartVC.productList.firstWhere(
                      (p) => p['ITEM_ID'].toString() == item.itemId,
                      orElse: () => {},
                    );
                    if (product.isNotEmpty) {
                      cartVC.addToCart(product, quantity: item.qtyPcs);
                      addedAny = true;
                    }
                  }

                  if (!addedAny) {
                    Navigator.pop(context);
                    Utils.showSnackBar(
                      context,
                      'Could not find items for reorder.',
                    );
                    return;
                  }

                  final success = await cartVC.placeOrder();

                  if (context.mounted) {
                    Navigator.pop(context);
                    if (success) {
                      Utils.showSnackBar(
                        context,
                        'Reorder placed successfully!',
                      );
                      // Trigger a refresh of the orders history
                      context.read<OrderController>().fetchOrders(
                        Constants.entityID,
                      );

                      AppRoutes.pushAndRemoveAll(
                        const DashboardView(initialIndex: 2),
                      );
                    } else {
                      Utils.showSnackBar(
                        context,
                        'Reorder failed. Please try again.',
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    Utils.showSnackBar(context, 'Error: $e');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: .1),
            blurRadius: 3,
            spreadRadius: 2,
            offset: const Offset(0, .3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildItemRow(
    String name,
    String qty,
    double price,
    bool isRefill,
    String imageUrl,
  ) {
    return Row(
      children: [
        Container(
          height: 12.w,
          width: 12.w,
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: AppColor.lightGrey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/1.5-litr.webp',
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset('assets/1.5-litr.webp', fit: BoxFit.contain),
          ),
        ),
        4.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColor.appDarkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isRefill) ...[
                    2.width,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.appColor2.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Refill',
                        style: TextStyle(
                          color: AppColor.appColor1,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(qty, style: TextStyle(fontSize: 12, color: AppColor.grey)),
            ],
          ),
        ),
        Text(
          'Rs. ${price.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColor.appDarkColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColor.appDarkColor : AppColor.grey,
          ),
        ),
        Text(
          'Rs. ${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 13,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            color: isTotal ? AppColor.appColor1 : AppColor.appDarkColor,
          ),
        ),
      ],
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                2.height,
                const Text(
                  'Processing Reorder...',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
