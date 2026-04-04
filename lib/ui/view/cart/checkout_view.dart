import 'package:flutter/material.dart';
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
  int _selectedPayment = 0;
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartVC, child) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: const CustomAppBar(title: 'Checkout'),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Delivery Address'),
                    2.height,
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grey.withValues(alpha: .1),
                            blurRadius: 3,
                            spreadRadius: 2,
                            offset: const Offset(0, .3),
                          ),
                        ],
                      ),
                      child: CustomField(
                        controller: addressController,
                        hintText:
                            'Enter complete address (Building, Floor, Flat)',
                        keyType: TextInputType.streetAddress,
                      ),
                    ),
                    4.height,
                    _buildSectionTitle('Payment Method'),
                    2.height,
                    _buildPaymentOption('Cash on Delivery', Icons.money, 0),
                    2.height,
                    _buildPaymentOption(
                      'Credit/Debit Card',
                      Icons.credit_card,
                      1,
                    ),
                    4.height,
                    _buildSectionTitle('Order Summary'),
                    2.height,
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(12),
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  color: AppColor.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Rs. ${cartVC.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.appDarkColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          2.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Fee',
                                style: TextStyle(
                                  color: AppColor.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Rs. 2.00',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.appDarkColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.appDarkColor,
                                ),
                              ),
                              Text(
                                'Rs. ${(cartVC.totalAmount + 2.0).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.appColor1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    10.height,
                    RoundButton(
                      width: double.infinity,
                      title: 'Confirm Order',
                      buttonColor: AppColor.appColor1,
                      onPress: () {
                        cartVC.clearCart();
                        AppRoutes.pushAndRemoveAll(const DashboardView());

                        Utils.showSnackBar(
                          context,
                          'Order placed successfully!',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColor.appDarkColor,
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedPayment == value
                ? AppColor.appColor1
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.grey.withValues(alpha: .1),
              blurRadius: 3,
              spreadRadius: 2,
              offset: const Offset(0, .3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedPayment == value
                  ? AppColor.appColor1
                  : AppColor.grey,
            ),
            4.width,
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: _selectedPayment == value
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_selectedPayment == value)
              Icon(Icons.check_circle, color: AppColor.appColor1),
          ],
        ),
      ),
    );
  }
}
