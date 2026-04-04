import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';

class OrderDetailView extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;
  final double totalAmount;
  final Color statusColor;
  final String imagePath;

  const OrderDetailView({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.statusColor,
    required this.imagePath,
  });

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderId,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.appDarkColor,
                            ),
                          ),
                          0.5.height,
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            3.height,
            Text(
              'Items Ordered',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.appDarkColor,
              ),
            ),
            1.height,
            _buildSection(
              child: Column(
                children: [
                  _buildItemRow('1.5 Litre Water Bottle', '2x', 3.00),
                  const Divider(height: 30),
                  _buildItemRow('19 Litre Water Bottle', '1x', 8.00),
                ],
              ),
            ),
            3.height,
            Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.appDarkColor,
              ),
            ),
            1.height,
            _buildSection(
              child: Row(
                children: [
                  Icon(Iconsax.location_outline, color: AppColor.appColor1),
                  4.width,
                  Expanded(
                    child: Text(
                      'Flat 402, Al-Rehman Heights, Gulshan-e-Iqbal, Karachi',
                      style: TextStyle(fontSize: 13, color: AppColor.darkGrey),
                    ),
                  ),
                ],
              ),
            ),
            3.height,
            Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.appDarkColor,
              ),
            ),
            1.height,
            _buildSection(
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', 11.00),
                  1.height,
                  _buildSummaryRow('Delivery Fee', 2.00),
                  const Divider(height: 30),
                  _buildSummaryRow('Total', 13.00, isTotal: true),
                ],
              ),
            ),
            10.height,
            RoundButton(
              width: double.maxFinite,
              buttonColor: AppColor.appColor1,
              textColor: AppColor.white,
              title: 'Reorder',
              onPress: () {},
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

  Widget _buildItemRow(String name, String qty, double price) {
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
          child: Image.asset('assets/1.5-litr.webp', fit: BoxFit.contain),
        ),
        4.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.appDarkColor,
                ),
              ),
              Text(qty, style: TextStyle(fontSize: 12, color: AppColor.grey)),
            ],
          ),
        ),
        Text(
          'Rs. ${price.toStringAsFixed(2)}',
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
          'Rs. ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 13,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            color: isTotal ? AppColor.appColor1 : AppColor.appDarkColor,
          ),
        ),
      ],
    );
  }
}
