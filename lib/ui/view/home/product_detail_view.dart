// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paani/ui/view/dashboard/dashboard_view.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';
import '../../components/item_stepper.dart';
import '../cart/cart_view.dart';

class ProductDetailView extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isRefill;

  const ProductDetailView({
    super.key,
    required this.product,
    this.isRefill = false,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final String itemName = widget.product['ITEM_NAME'] ?? '';
    final String description = widget.product['DESCRIPTION'] ?? '';
    final String imageUrl = widget.product['IMAGE_URL'] ?? '';
    final double price = double.tryParse(widget.product['PRICE'] ?? '0') ?? 0.0;
    final bool isRefill = widget.isRefill;

    return WillPopScope(
      onWillPop: () async {
        AppRoutes.pushAndRemoveAll(const DashboardView(initialIndex: 0));
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: CustomAppBar(title: itemName),
        body: Consumer<CartController>(
          builder: (context, cartVC, child) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 38.h,
                            color: AppColor.lightGrey.withValues(alpha: 0.3),
                            padding: EdgeInsets.all(5.w),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Skeletonizer(
                                enabled: true,
                                effect: ShimmerEffect(
                                  baseColor: AppColor.lightGrey.withValues(
                                    alpha: 0.3,
                                  ),
                                  highlightColor: AppColor.white.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                child: Container(
                                  color: AppColor.lightGrey.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColor.grey,
                                size: 40,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ---- Refill Badge ----
                                if (isRefill)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.green.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColor.green.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.refresh_rounded,
                                          size: 14,
                                          color: AppColor.green,
                                        ),
                                        6.width,
                                        Text(
                                          'Refill — Water Only',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // ---- Name & Price ----
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        itemName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: AppColor.appDarkColor,
                                        ),
                                      ),
                                    ),
                                    2.width,
                                    Text(
                                      'Rs. ${(price * _quantity).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.appColor1,
                                      ),
                                    ),
                                  ],
                                ),
                                3.height,

                                // ---- Quantity Selector ----
                                Row(
                                  children: [
                                    Text(
                                      'Quantity:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.darkGrey,
                                      ),
                                    ),
                                    4.width,
                                    ItemStepper(
                                      quantity: _quantity,
                                      onIncrement: () {
                                        setState(() => _quantity++);
                                      },
                                      onDecrement: () {
                                        if (_quantity > 1) {
                                          setState(() => _quantity--);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                6.height,

                                // ---- Description ----
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.appDarkColor,
                                  ),
                                ),
                                2.height,
                                Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.darkGrey,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---- Bottom Action Bar ----
                  Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.grey.withValues(alpha: .1),
                          blurRadius: 3,
                          spreadRadius: 2,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: RoundButton(
                            width: double.maxFinite,
                            buttonColor: AppColor.appDarkColor,
                            textColor: AppColor.white,
                            title: 'Back',
                            onPress: () => AppRoutes.pop(),
                          ),
                        ),
                        5.width,
                        Expanded(
                          child: RoundButton(
                            width: double.maxFinite,
                            buttonColor: AppColor.appColor1,
                            textColor: AppColor.white,
                            title: 'Add to Cart',
                            onPress: () {
                              cartVC.addToCart(
                                widget.product,
                                isRefill: widget.isRefill,
                                quantity: _quantity,
                              );
                              _showSuccessAndNavigate(context, itemName);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSuccessAndNavigate(BuildContext context, String itemName) {
    // Utils.showSnackBar(context, '$_quantity x $itemName added to cart!');
    AppRoutes.push(
      Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomAppBar(title: 'My Cart'),
        body: const CartView(),
      ),
    );
  }
}
