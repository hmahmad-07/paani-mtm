import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/controllers/order_controller.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/models/order_model.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_appbar.dart';
import 'order_detail_view.dart';

class OrderTrackingView extends StatefulWidget {
  final bool isStandalone;
  const OrderTrackingView({super.key, this.isStandalone = false});

  @override
  State<OrderTrackingView> createState() => _OrderTrackingViewState();
}

class _OrderTrackingViewState extends State<OrderTrackingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderController>().fetchOrders(Constants.entityID);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isStandalone) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomAppBar(title: 'My Orders'),
        body: _buildBody(),
      );
    }
    return _buildBody();
  }

  Widget _buildBody() {
    return Consumer2<OrderController, CartController>(
      builder: (context, orderVC, cartVC, child) {
        if (orderVC.isLoading && orderVC.orders.isEmpty) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                8.w,
                2.h,
                8.w,
                widget.isStandalone ? 4.h : 14.h,
              ),
              itemCount: 5,
              itemBuilder: (context, index) => _buildOrderCard(
                order: Order(
                  id: '0000',
                  entityNo: '',
                  entityName: '',
                  isProductive: true,
                  orderDate: 'Loading...',
                  createdAt: '',
                  items: [],
                ),
                cartVC: cartVC,
              ),
            ),
          );
        }

        if (orderVC.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.box_outline, size: 64, color: AppColor.grey),
                2.height,
                Text(
                  'No orders found',
                  style: TextStyle(color: AppColor.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => orderVC.fetchOrders(Constants.entityID),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(
              8.w,
              2.h,
              8.w,
              widget.isStandalone ? 4.h : 14.h,
            ),
            itemCount: orderVC.orders.length,
            itemBuilder: (context, index) {
              final order = orderVC.orders[index];
              return _buildOrderCard(order: order, cartVC: cartVC);
            },
          ),
        );
      },
    );
  }

  Widget _buildOrderCard({
    required Order order,
    required CartController cartVC,
  }) {
    // Get images for items
    List<String> imageUrls = [];
    for (var item in order.items) {
      final product = cartVC.productList.firstWhere(
        (p) => p['ITEM_ID'].toString() == item.itemId,
        orElse: () => {},
      );
      if (product.isNotEmpty && product['IMAGE_URL'] != null) {
        imageUrls.add(product['IMAGE_URL']);
      }
    }

    return GestureDetector(
      onTap: () {
        AppRoutes.push(OrderDetailView(order: order));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.8.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.grey.withValues(alpha: .1),
              blurRadius: 3,
              spreadRadius: 2,
              offset: const Offset(0, .3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 35.w,
                  width: 32.w,
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: imageUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrls.first,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/1.5-litr.webp',
                              fit: BoxFit.fill,
                            ),
                          )
                        : Image.asset('assets/1.5-litr.webp', fit: BoxFit.fill),
                  ),
                ),
                if (order.items.length > 1)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor.appColor1,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${order.items.length}',
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            4.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#ORD-${order.id}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColor.appDarkColor,
                    ),
                  ),
                  1.height,
                  Row(
                    children: [
                      Icon(
                        Iconsax.calendar_1_bold,
                        size: 14,
                        color: AppColor.appColor2,
                      ),
                      0.5.w.width,
                      Text(
                        order.orderDate,
                        style: TextStyle(color: AppColor.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  0.1.h.height,
                  Row(
                    children: [
                      Icon(
                        Iconsax.box_1_bold,
                        size: 14,
                        color: AppColor.appColor2,
                      ),
                      0.5.w.width,
                      Text(
                        '${order.items.length} Items',
                        style: TextStyle(color: AppColor.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  .3.h.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColor.appColor1,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppColor.lightGrey.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.arrow_right_3_outline,
                          size: 14,
                          color: AppColor.appColor1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
