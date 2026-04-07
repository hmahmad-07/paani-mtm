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
      appBar: const CustomAppBar(title: 'Notifications'),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: 4,
        separatorBuilder: (context, index) => Divider(
          color: AppColor.lightGrey.withValues(alpha: 0.3),
          indent: 16.w,
        ),
        itemBuilder: (context, index) {
          final notifications = [
            {
              'title': 'Order Completed',
              'message':
                  'Your order #ORD-987123 has been delivered successfully. Enjoy your PAANI!',
              'time': '2 hours ago',
              'icon': Iconsax.box_tick_bold,
              'isNew': true,
              'color': AppColor.green,
            },
            {
              'title': 'Out for Delivery',
              'message':
                  'Your order #ORD-987654 is out for delivery. Our rider will reach you shortly.',
              'time': '4 hours ago',
              'icon': Iconsax.truck_fast_bold,
              'isNew': true,
              'color': AppColor.appColor2,
            },
            {
              'title': 'Promo Code!',
              'message':
                  'Get 10% off on your next 19L bottle order. Use code: PAANILOVE',
              'time': '1 day ago',
              'icon': Iconsax.discount_shape_bold,
              'isNew': false,
              'color': AppColor.appColor1,
            },
            {
              'title': 'System Update',
              'message':
                  'App maintenance scheduled for tomorrow 2:00 AM to 4:00 AM.',
              'time': '3 days ago',
              'icon': Iconsax.info_circle_bold,
              'isNew': false,
              'color': AppColor.darkGrey,
            },
          ];

          final item = notifications[index];
          return _buildNotificationItem(
            title: item['title'] as String,
            message: item['message'] as String,
            time: item['time'] as String,
            icon: item['icon'] as IconData,
            isNew: item['isNew'] as bool,
            color: item['color'] as Color,
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required bool isNew,
    required Color color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isNew ? FontWeight.w800 : FontWeight.w600,
              fontSize: 14,
              color: AppColor.appDarkColor,
            ),
          ),
          if (isNew)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColor.appColor1,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.5.height,
          Text(
            message,
            style: TextStyle(
              color: AppColor.darkGrey,
              fontSize: 12,
              height: 1.3,
            ),
          ),
          1.height,
          Text(time, style: TextStyle(color: AppColor.grey, fontSize: 10)),
        ],
      ),
    );
  }
}
