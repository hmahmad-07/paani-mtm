import 'package:flutter/material.dart';
import 'package:paani/core/utils/utils.dart';
import 'package:paani/ui/components/intl_phone_field.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_field.dart';
import '../../components/custom_button.dart';
import '../../components/custom_appbar.dart';

class UpdateProfileView extends StatelessWidget {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(title: 'Update Profile'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                1.height,
                Text(
                  'Update your personal information',
                  style: TextStyle(
                    color: AppColor.darkGrey,
                    fontSize: 4.5.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                8.height,
                CustomField(
                  controller: TextEditingController(text: 'John Doe'),
                  hintText: 'Full Name',
                ),
                IntlField(
                  controller: TextEditingController(text: '+1234567890'),
                  hintText: 'Phone Number',
                  onChanged: (phone) {},
                ),
                CustomField(
                  controller: TextEditingController(
                    text: 'johndoe@example.com',
                  ),
                  hintText: 'Email Address',
                  keyType: TextInputType.emailAddress,
                ),
                CustomField(
                  controller: TextEditingController(
                    text: '123 Main Street, Unit 4B',
                  ),
                  hintText: 'Address',
                  keyType: TextInputType.streetAddress,
                ),
                10.height,
                RoundButton(
                  width: double.infinity,
                  title: 'Save Changes',
                  buttonColor: AppColor.appColor1,
                  onPress: () {
                    Utils.showSnackBar(
                      context,
                      'Profile updated successfully!',
                    );
                    Navigator.pop(context);
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
