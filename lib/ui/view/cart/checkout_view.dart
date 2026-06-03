import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_button.dart';
import '../../components/custom_appbar.dart';
import '../../../core/utils/utils.dart';
import '../dashboard/dashboard_view.dart';
import '../../../core/extensions/routes.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartVC, child) {
        final items = cartVC.cartItems.entries.toList();
        final double total = cartVC.totalAmount;
        final int totalItems = cartVC.cartItems.values.fold(
          0,
          (sum, item) => sum + item.quantity,
        );

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
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    product['IMAGE_URL'] ?? '',
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) =>
                                                    Skeletonizer(
                                                      enabled: true,
                                                      effect: ShimmerEffect(
                                                        baseColor: AppColor
                                                            .lightGrey
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                        highlightColor: AppColor
                                                            .white
                                                            .withValues(
                                                              alpha: 0.8,
                                                            ),
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: AppColor
                                                              .lightGrey
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Icon(
                                                      Icons
                                                          .image_not_supported_outlined,
                                                      color: AppColor.grey
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                      size: 20,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          3.width,
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${idx + 1}. $itemName',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                                (price * cartItem.quantity)
                                                    .toStringAsFixed(0),
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
                              _summaryRow('Total Items', '$totalItems'),
                              1.h.height,
                              _summaryRow(
                                'Subtotal',
                                cartVC.totalAmount.toStringAsFixed(0),
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
                                    total.toStringAsFixed(0),
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
                    title:
                        'Confirm Order  •  $totalItems Item${totalItems > 1 ? 's' : ''}  •  ${total.toStringAsFixed(0)}',
                    buttonColor: AppColor.appColor1,
                    onPress: () async {
                      _showLoadingDialog(context);
                      final success = await cartVC.placeOrder();
                      if (context.mounted) {
                        Navigator.pop(context);
                        if (success) {
                          _showSuccessDialog(context);
                        } else {
                          Utils.showSnackBar(
                            context,
                            '❌ Failed to place order. Try again.',
                          );
                        }
                      }
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: AppColor.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColor.appDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor.appColor1,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    Icon(
                      Iconsax.shopping_cart_bold,
                      color: AppColor.appColor1,
                      size: 24,
                    ),
                  ],
                ),
                3.height,
                Text(
                  'Processing Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColor.appDarkColor,
                  ),
                ),
                1.height,
                Text(
                  'Please wait while we confirm your order...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColor.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        final scale = Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim1, curve: Curves.elasticOut));
        return ScaleTransition(
          scale: scale,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColor.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.tick_circle_bold,
                    color: AppColor.green,
                    size: 50,
                  ),
                ),
                3.height,
                Text(
                  'Order Placed!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColor.appDarkColor,
                  ),
                ),
                1.h.height,
                Text(
                  'Your water order has been successfully placed. We will notify you soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.darkGrey,
                    height: 1.4,
                  ),
                ),
                4.height,
                RoundButton(
                  width: double.infinity,
                  title: 'Back to Home',
                  buttonColor: AppColor.appColor1,
                  onPress: () {
                    AppRoutes.pushAndRemoveAll(
                      const DashboardView(initialIndex: 0),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
