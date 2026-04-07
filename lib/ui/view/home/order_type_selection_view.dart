import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../core/models/product_model.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_appbar.dart';
import 'product_detail_view.dart';

class OrderTypeSelectionView extends StatelessWidget {
  final ProductModel product;

  const OrderTypeSelectionView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: product.name),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColor.appColor1.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColor.appColor1.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      product.imagePath,
                      height: 22.h,
                      fit: BoxFit.contain,
                    ),
                    2.height,
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColor.appDarkColor,
                      ),
                    ),
                    0.5.height,
                    Text(
                      product.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              4.height,

              Text(
                'Select Order Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColor.appDarkColor,
                ),
              ),
              1.height,
              Text(
                'Choose how you would like to order',
                style: TextStyle(fontSize: 12, color: AppColor.grey),
              ),

              3.height,

              // New Order Card
              _OrderOptionCard(
                label: 'New Order',
                description: 'Full bottle + fresh water delivery',
                badge: 'Bottle + Water',
                price: 'Rs. ${product.price.toStringAsFixed(0)}',
                badgeColor: AppColor.appColor1,
                icon: Iconsax.box_add_bold,
                imagePath: product.imagePath,
                isRefill: false,
                onTap: () => AppRoutes.push(
                  ProductDetailView(product: product, isRefill: false),
                ),
              ),

              3.height,

              // Refill Card
              _OrderOptionCard(
                label: 'Refill',
                description: 'Water refill only, bring your bottle',
                badge: 'Water Only',
                price: 'Rs. ${product.refillPrice?.toStringAsFixed(0) ?? '-'}',
                badgeColor: AppColor.green,
                icon: Iconsax.refresh_bold,
                imagePath: product.imagePath,
                isRefill: true,
                onTap: () => AppRoutes.push(
                  ProductDetailView(product: product, isRefill: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderOptionCard extends StatelessWidget {
  final String label;
  final String description;
  final String badge;
  final String price;
  final Color badgeColor;
  final IconData icon;
  final String imagePath;
  final bool isRefill;
  final VoidCallback onTap;

  const _OrderOptionCard({
    required this.label,
    required this.description,
    required this.badge,
    required this.price,
    required this.badgeColor,
    required this.icon,
    required this.imagePath,
    required this.isRefill,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: badgeColor.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 28.w,
              width: 28.w,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            4.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 4.5.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.appDarkColor,
                        ),
                      ),
                      3.width,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  1.height,
                  Text(
                    description,
                    style: TextStyle(fontSize: 4.sp, color: AppColor.grey),
                  ),
                  1.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Iconsax.arrow_right_3_bold,
                          size: 4.5.r,
                          color: AppColor.white,
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
