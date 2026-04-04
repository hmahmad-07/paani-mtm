import 'package:flutter/material.dart';
import 'package:paani/core/utils/utils.dart';
import 'package:paani/ui/components/intl_phone_field.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_field.dart';
import '../../components/custom_button.dart';
import '../../components/custom_appbar.dart';
import 'checkout_view.dart';

class UserDetailsView extends StatefulWidget {
  const UserDetailsView({super.key});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    quantityController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(title: 'Delivery Details'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Information',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 7.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                0.5.height,
                Text(
                  'Please provide accurate details for a smooth delivery.',
                  style: TextStyle(
                    color: AppColor.darkGrey,
                    fontSize: 4.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                5.height,
                CustomField(
                  controller: nameController,
                  hintText: 'Full Name',
                  keyType: TextInputType.name,
                ),
                CustomField(
                  controller: emailController,
                  hintText: 'Email Address',
                  keyType: TextInputType.emailAddress,
                ),
                IntlField(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  onChanged: (phone) {},
                ),
                CustomField(
                  controller: addressController,
                  hintText: 'Complete Address',
                  keyType: TextInputType.streetAddress,
                ),
                CustomField(
                  controller: quantityController,
                  hintText: 'Quantity',
                  keyType: TextInputType.number,
                ),
                CustomField(
                  controller: noteController,
                  hintText: 'Additional Note (Optional)',
                  maxLine: 3,
                ),
                10.height,
                RoundButton(
                  width: double.infinity,
                  title: 'Proceed to Payment',
                  buttonColor: AppColor.appColor1,
                  onPress: () {
                    Utils.showSnackBar(
                      context,
                      'Please fill in all required fields',
                    );
                    AppRoutes.push(const CheckoutView());
                  },
                ),
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
