import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:paani/core/constants/app_constants.dart';
import 'package:paani/core/controllers/auth_controller.dart';
import 'package:paani/core/utils/utils.dart';
import 'package:paani/ui/components/intl_phone_field.dart';
import 'package:provider/provider.dart';
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
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Constants.currentUser;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phoneNumber;
      addressController.text = user.address;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
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
                  suffixIcon: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      context.read<AuthController>().getAddress(
                        context: context,
                        controller: addressController,
                      );
                    },
                    child: Icon(Bootstrap.geo_alt_fill, color: AppColor.red),
                  ),
                ),
                CustomField(
                  controller: noteController,
                  hintText: 'Additional Note (Optional)',
                  maxLine: 7,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
