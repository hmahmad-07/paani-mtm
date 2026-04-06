import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';

import '../../components/custom_button.dart';
import '../../components/item_stepper.dart';
import '../home/product_detail_view.dart';
import 'user_details_view.dart';

class CartView extends StatelessWidget {
  final bool showBottomPadding;
  const CartView({super.key, this.showBottomPadding = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartVC, child) {
        final cartItems = cartVC.cartItems.values.toList();

        return Container(
          color: AppColor.white,
          height: double.infinity,
          width: double.infinity,
          child: cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: AppColor.lightGrey,
                      ),
                      2.height,
                      Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18, color: AppColor.grey),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 14.h),
                          itemCount: cartVC.cartItems.length,
                          separatorBuilder: (context, index) => 2.height,
                          itemBuilder: (context, index) {
                            final cartKey = cartVC.cartItems.keys.elementAt(index);
                            final cartItem = cartVC.cartItems[cartKey]!;
                            final product = cartItem.product;
                            final price = (cartItem.isRefill && product.refillPrice != null)
                                ? product.refillPrice!
                                : product.price;

                            return GestureDetector(
                              onTap: () {
                                AppRoutes.push(
                                  ProductDetailView(product: product),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.grey.withValues(
                                        alpha: .1,
                                      ),
                                      blurRadius: 3,
                                      spreadRadius: 2,
                                      offset: const Offset(0, .3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 25.w,
                                      width: 25.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color: AppColor.lightGrey.withValues(
                                          alpha: 0.3,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Image.asset(
                                        product.imagePath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    4.width,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: AppColor.appDarkColor,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (cartItem.isRefill) ...[
                                            0.5.height,
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColor.appColor2
                                                    .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'Refill',
                                                style: TextStyle(
                                                  color: AppColor.appColor1,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                          1.height,
                                          Text(
                                            'Rs. ${price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14,
                                              color: AppColor.appColor1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ItemStepper(
                                      quantity: cartItem.quantity,
                                      size: 24,
                                      onIncrement: () =>
                                          cartVC.incrementQuantity(cartKey),
                                      onDecrement: () =>
                                          cartVC.decrementQuantity(cartKey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          6.w,
                          6.w,
                          6.w,
                          showBottomPadding ? 12.h : 6.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.grey.withValues(alpha: .1),
                              blurRadius: 3,
                              spreadRadius: 2,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.grey,
                                  ),
                                ),
                                Text(
                                  'Rs. ${cartVC.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.appDarkColor,
                                  ),
                                ),
                              ],
                            ),
                            1.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.grey,
                                  ),
                                ),
                                Text(
                                  'Rs. 2.00',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.appDarkColor,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColor.lightGrey.withValues(alpha: 0.5),
                              height: 4.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.appDarkColor,
                                  ),
                                ),
                                Text(
                                  'Rs. ${(cartVC.totalAmount + 2.0).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColor.appColor1,
                                  ),
                                ),
                              ],
                            ),
                            3.height,
                            RoundButton(
                              width: double.maxFinite,
                              title: 'Proceed to Checkout',
                              buttonColor: AppColor.appColor1,
                              onPress: () {
                                AppRoutes.push(const UserDetailsView());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
