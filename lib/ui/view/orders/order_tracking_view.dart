import 'package:flutter/material.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';


class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 14.h),
        children: [
          _buildOrderCard(
            orderId: '#ORD-987654',
            date: '04 Apr, 10:30 AM',
            status: 'Out for Delivery',
            itemsCount: 3,
            totalAmount: 18.50,
            statusColor: AppColor.appColor2,
            activeStep: 2,
          ),
          4.height,
          _buildOrderCard(
            orderId: '#ORD-987123',
            date: '01 Apr, 02:15 PM',
            status: 'Delivered',
            itemsCount: 1,
            totalAmount: 3.50,
            statusColor: Colors.green,
            activeStep: 3,
          ),
          4.height,
          _buildOrderCard(
            orderId: '#ORD-986001',
            date: '28 Mar, 09:00 AM',
            status: 'Cancelled',
            itemsCount: 5,
            totalAmount: 25.00,
            statusColor: AppColor.red,
            activeStep: -1,
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
    required int activeStep,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColor.appDarkColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          2.height,
          Text(
            date,
            style: TextStyle(color: AppColor.grey, fontSize: 12),
          ),
          2.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$itemsCount Items',
                style: TextStyle(color: AppColor.darkGrey, fontWeight: FontWeight.w600, fontSize: 12),
              ),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.w900, color: AppColor.appColor1, fontSize: 14),
              ),
            ],
          ),
          if (activeStep >= 0) ...[
            3.height,
            const Divider(),
            3.height,
            Row(
              children: [
                _buildTrackingStep('Pending', activeStep >= 0),
                _buildTrackingLine(activeStep >= 1),
                _buildTrackingStep('Confirmed', activeStep >= 1),
                _buildTrackingLine(activeStep >= 2),
                _buildTrackingStep('On the way', activeStep >= 2),
                _buildTrackingLine(activeStep >= 3),
                _buildTrackingStep('Delivered', activeStep >= 3),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String title, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColor.appColor1 : AppColor.lightGrey,
            ),
          ),
          1.height,
          Text(
            title,
            style: TextStyle(fontSize: 10, color: isActive ? AppColor.black : AppColor.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingLine(bool isActive) {
    return Container(
      width: 20,
      height: 2,
      color: isActive ? AppColor.appColor1 : AppColor.lightGrey,
      margin: const EdgeInsets.only(bottom: 15),
    );
  }
}

