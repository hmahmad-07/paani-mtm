// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:paani/core/utils/utils.dart';
import 'package:paani/ui/view/dashboard/dashboard_view.dart';
import 'package:provider/provider.dart';

import '../../../core/models/product_model.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';
import '../../components/item_stepper.dart';
import '../cart/cart_view.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;
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
    final isRefill = widget.isRefill;
    final price = isRefill && widget.product.refillPrice != null
        ? widget.product.refillPrice!
        : widget.product.price;

    return WillPopScope(
      onWillPop: () async {
        AppRoutes.pushAndRemoveAll(const DashboardView(initialIndex: 0));
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: CustomAppBar(title: widget.product.name),
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
                          // Product Image
                          Container(
                            width: double.infinity,
                            height: 38.h,
                            color: AppColor.lightGrey.withValues(alpha: 0.3),
                            padding: EdgeInsets.all(5.w),
                            child: Image.asset(
                              widget.product.imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Order type badge (for 19L with refill)
                                if (widget.product.refillPrice != null)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isRefill
                                          ? AppColor.green.withValues(alpha: 0.1)
                                          : AppColor.appColor1.withValues(
                                              alpha: 0.1,
                                            ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isRefill
                                            ? AppColor.green.withValues(
                                                alpha: 0.3,
                                              )
                                            : AppColor.appColor1.withValues(
                                                alpha: 0.3,
                                              ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isRefill
                                              ? Icons.refresh_rounded
                                              : Icons.inventory_2_rounded,
                                          size: 14,
                                          color: isRefill
                                              ? AppColor.green
                                              : AppColor.appColor1,
                                        ),
                                        6.width,
                                        Text(
                                          isRefill
                                              ? 'Refill — Water Only'
                                              : 'New Order — Bottle + Water',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isRefill
                                                ? AppColor.green
                                                : AppColor.appColor1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Name and price row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.product.name,
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

                                // Quantity selector
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
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                      onDecrement: () {
                                        if (_quantity > 1) {
                                          setState(() {
                                            _quantity--;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                6.height,

                                // Description
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
                                  widget.product.description,
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

                  // Bottom action bar
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
                              _showSuccessAndNavigate(context);
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

  void _showSuccessAndNavigate(BuildContext context) {
    Utils.showSnackBar(
      context,
      '$_quantity x ${widget.product.name} added to cart!',
    );
    AppRoutes.push(
      Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomAppBar(title: 'My Cart'),
        body: const CartView(),
      ),
    );
  }
}
