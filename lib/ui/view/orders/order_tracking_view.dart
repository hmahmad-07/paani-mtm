import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_appbar.dart';
import 'order_detail_view.dart';

class OrderTrackingView extends StatelessWidget {
  final bool isStandalone;
  const OrderTrackingView({super.key, this.isStandalone = false});

  @override
  Widget build(BuildContext context) {
    if (isStandalone) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomAppBar(title: 'My Orders'),
        body: _buildBody(),
      );
    }
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      color: AppColor.white,
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, isStandalone ? 4.h : 14.h),
        children: [
          _buildOrderCard(
            orderId: '#ORD-987654',
            date: '04 Apr, 10:30 AM',
            status: 'Out for Delivery',
            itemsCount: 3,
            totalAmount: 18.50,
            statusColor: AppColor.appColor2,
            icon: Iconsax.truck_fast_outline,
            imagePath: 'assets/1.5-litr.webp',
          ),
          2.height,
          _buildOrderCard(
            orderId: '#ORD-987123',
            date: '01 Apr, 02:15 PM',
            status: 'Delivered',
            itemsCount: 1,
            totalAmount: 3.50,
            statusColor: AppColor.green,
            icon: Iconsax.box_tick_outline,
            imagePath: 'assets/19-litr-bottle.webp',
          ),
          2.height,
          _buildOrderCard(
            orderId: '#ORD-986001',
            date: '28 Mar, 09:00 AM',
            status: 'Cancelled',
            itemsCount: 5,
            totalAmount: 25.00,
            statusColor: AppColor.red,
            icon: Iconsax.box_remove_outline,
            imagePath: 'assets/200-ml-Cup.webp',
          ),
          2.height,
          _buildOrderCard(
            orderId: '#ORD-985900',
            date: '25 Mar, 11:20 AM',
            status: 'Delivered',
            itemsCount: 2,
            totalAmount: 10.00,
            statusColor: AppColor.green,
            icon: Iconsax.box_tick_outline,
            imagePath: 'assets/500-ml.webp',
          ),
          2.height,
          _buildOrderCard(
            orderId: '#ORD-985880',
            date: '22 Mar, 04:45 PM',
            status: 'Delivered',
            itemsCount: 4,
            totalAmount: 14.20,
            statusColor: AppColor.green,
            icon: Iconsax.box_tick_outline,
            imagePath: 'assets/6-litr-bottle.webp',
          ),
          2.height,
          _buildOrderCard(
            orderId: '#ORD-985777',
            date: '20 Mar, 08:30 AM',
            status: 'Pending',
            itemsCount: 1,
            totalAmount: 5.00,
            statusColor: AppColor.grey,
            icon: Iconsax.clock_outline,
            imagePath: 'assets/1.5-litr.webp',
          ),
          2.height,
          _buildOrderCard(
            orderId: '#ORD-985666',
            date: '18 Mar, 01:10 PM',
            status: 'Delivered',
            itemsCount: 6,
            totalAmount: 42.00,
            statusColor: AppColor.green,
            icon: Iconsax.box_tick_outline,
            imagePath: 'assets/19-litr-bottle.webp',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String date,
    required String status,
    required int itemsCount,
    required double totalAmount,
    required Color statusColor,
    required IconData icon,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        AppRoutes.push(
          OrderDetailView(
            orderId: orderId,
            date: date,
            status: status,
            totalAmount: totalAmount,
            statusColor: statusColor,
            imagePath: imagePath,
          ),
        );
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
            Container(
              height: 35.w,
              width: 32.w,
              decoration: BoxDecoration(
                color: AppColor.lightGrey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(imagePath),
                ),
              ),
            ),
            4.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          orderId,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColor.appDarkColor,
                          ),
                        ),
                      ),
                      2.width,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  0.2.h.height,
                  Row(
                    children: [
                      Icon(
                        Iconsax.calendar_1_bold,
                        size: 14,
                        color: AppColor.appColor2,
                      ),
                      0.5.w.width,
                      Text(
                        date,
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
                        '$itemsCount Items',
                        style: TextStyle(color: AppColor.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  .3.h.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs. ${totalAmount.toStringAsFixed(0)}',
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
