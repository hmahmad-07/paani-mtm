import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_appbar.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(
        title: 'Notifications',
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        children: [
          _buildNotificationCard(
            title: 'Order Completed',
            message: 'Your order #ORD-987123 has been delivered successfully. Enjoy your PAANI!',
            time: '2 hours ago',
            icon: Iconsax.box_tick_bold,
            isNew: true,
          ),
          2.height,
          _buildNotificationCard(
            title: 'Out for Delivery',
            message: 'Your order #ORD-987654 is out for delivery. Our rider will reach you shortly.',
            time: '4 hours ago',
            icon: Iconsax.truck_fast_bold,
            isNew: true,
          ),
          2.height,
          _buildNotificationCard(
            title: 'Promo Code!',
            message: 'Get 10% off on your next 19L bottle order. Use code: PAANILOVE',
            time: '1 day ago',
            icon: Iconsax.discount_shape_bold,
            isNew: false,
            color: AppColor.appColor2,
          ),
          2.height,
          _buildNotificationCard(
            title: 'System Update',
            message: 'App maintenance scheduled for tomorrow 2:00 AM to 4:00 AM.',
            time: '3 days ago',
            icon: Iconsax.info_circle_bold,
            isNew: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required bool isNew,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: isNew ? Border.all(color: AppColor.appColor1.withValues(alpha: 0.4), width: 1.5) : null,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (color ?? AppColor.appColor1).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color ?? AppColor.appColor1, size: 24),
          ),
          4.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppColor.appDarkColor,
                        ),
                      ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColor.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                1.height,
                Text(
                  message,
                  style: TextStyle(
                    color: AppColor.darkGrey,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                2.height,
                Text(
                  time,
                  style: TextStyle(
                    color: AppColor.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
