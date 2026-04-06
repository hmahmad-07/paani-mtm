// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
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

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
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
                          Container(
                            width: double.infinity,
                            height: 40.h,
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
                                      'Rs. ${(widget.product.price * _quantity).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.appColor1,
                                      ),
                                    ),
                                  ],
                                ),
                                3.height,
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
                            onPress: () {
                              AppRoutes.pop();
                            },
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
                              if (widget.product.id == '2') {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(6.w),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Select Order Type',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.appDarkColor,
                                            ),
                                          ),
                                          .5.h.height,
                                          _buildSelectionOption(
                                            title: 'New Order (Bottle + Water)',
                                            subtitle:
                                                'Rs. ${widget.product.price.toStringAsFixed(0)}',
                                            icon: Iconsax.box_add_bold,
                                            onTap: () {
                                              cartVC.addToCart(
                                                widget.product,
                                                isRefill: false,
                                                quantity: _quantity,
                                              );
                                              AppRoutes.pop();
                                              _showSuccessAndNavigate(context);
                                            },
                                          ),
                                          .2.h.height,
                                          _buildSelectionOption(
                                            title: 'Refill (Water Only)',
                                            subtitle:
                                                'Rs. ${widget.product.refillPrice?.toStringAsFixed(0)}',
                                            icon: Iconsax.refresh_bold,
                                            onTap: () {
                                              cartVC.addToCart(
                                                widget.product,
                                                isRefill: true,
                                                quantity: _quantity,
                                              );
                                              AppRoutes.pop();
                                              _showSuccessAndNavigate(context);
                                            },
                                          ),
                                          .2.h.height,
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                cartVC.addToCart(
                                  widget.product,
                                  isRefill: false,
                                  quantity: _quantity,
                                );
                                _showSuccessAndNavigate(context);
                              }
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

  Widget _buildSelectionOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppColor.appColor2.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColor.appColor1),
            ),
            4.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColor.appColor1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
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
