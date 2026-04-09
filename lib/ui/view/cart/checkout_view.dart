import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_field.dart';
import '../../components/custom_button.dart';
import '../../components/custom_appbar.dart';
import '../dashboard/dashboard_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartVC, child) {
        final items = cartVC.cartItems.entries.toList();
        const double deliveryFee = 50.0;
        final double total = cartVC.totalAmount + deliveryFee;

        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: const CustomAppBar(title: 'Checkout'),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          'Delivery Address',
                          Iconsax.location_bold,
                        ),
                        2.height,
                        Container(
                          decoration: _cardDecoration(),
                          padding: EdgeInsets.only(
                            right: 4.w,
                            left: 4.w,
                            bottom: 4.5.w,
                          ),
                          child: CustomField(
                            controller: addressController,
                            hintText: 'Enter complete address',
                            keyType: TextInputType.streetAddress,
                            maxLine: 3,
                          ),
                        ),
                        3.height,
                        _sectionTitle('Order Items', Iconsax.box_bold),
                        2.height,
                        Container(
                          decoration: _cardDecoration(),
                          child: Column(
                            children: [
                              ...items.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final cartItem = entry.value.value;
                                final product = cartItem.product;

                                // ---------- Raw Map Fields ----------
                                final String itemName =
                                    product['ITEM_NAME'] ?? '';
                                final double price =
                                    double.tryParse(product['PRICE'] ?? '0') ??
                                    0.0;

                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 1.5.h,
                                      ),
                                      child: Row(
                                        children: [
                                          // ---- Product Image ----
                                          Container(
                                            height: 14.w,
                                            width: 14.w,
                                            decoration: BoxDecoration(
                                              color: AppColor.lightGrey
                                                  .withValues(alpha: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(1.w),
                                              child: Image.asset(
                                                'assets/19-litr-bottle.webp', // default — replace with Image.network when real URL comes
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          3.width,

                                          // ---- Product Info ----
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  itemName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13,
                                                    color:
                                                        AppColor.appDarkColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (cartItem.isRefill)
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          top: 3,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 7,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColor.green
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      'Refill',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: AppColor.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),

                                          // ---- Quantity & Price ----
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'x${cartItem.quantity}',
                                                style: TextStyle(
                                                  color: AppColor.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                'Rs. ${(price * cartItem.quantity).toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColor.appColor1,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (idx < items.length - 1)
                                      Divider(
                                        height: 1,
                                        color: AppColor.lightGrey,
                                        indent: 4.w,
                                        endIndent: 4.w,
                                      ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        3.height,
                        _sectionTitle('Order Summary', Iconsax.document_bold),
                        2.height,
                        Container(
                          decoration: _cardDecoration(),
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            children: [
                              _summaryRow(
                                'Subtotal',
                                'Rs. ${cartVC.totalAmount.toStringAsFixed(0)}',
                              ),
                              2.height,
                              _summaryRow(
                                'Delivery Fee',
                                'Rs. ${deliveryFee.toStringAsFixed(0)}',
                              ),
                              Divider(height: 3.h, color: AppColor.lightGrey),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColor.appDarkColor,
                                    ),
                                  ),
                                  Text(
                                    'Rs. ${total.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColor.appColor1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        3.height,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.appColor2.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColor.appColor2.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Iconsax.info_circle_bold,
                                size: 16,
                                color: AppColor.appColor2,
                              ),
                              2.width,
                              Expanded(
                                child: Text(
                                  'Payment is due at the end of the month or as per your agreed billing schedule with PAANI.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColor.darkGrey,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        3.height,
                      ],
                    ),
                  ),
                ),

                // ---- Confirm Button ----
                Container(
                  padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 2.h),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.grey.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: RoundButton(
                    width: double.infinity,
                    title: 'Confirm Order  •  Rs. ${total.toStringAsFixed(0)}',
                    buttonColor: AppColor.appColor1,
                    onPress: () {
                      cartVC.clearCart();
                      AppRoutes.pushAndRemoveAll(const DashboardView());
                      Utils.showSnackBar(
                        context,
                        '🎉 Order placed successfully!',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColor.appColor1),
        2.width,
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColor.appDarkColor,
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: AppColor.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColor.appDarkColor,
          ),
        ),
      ],
    );
  }
}
