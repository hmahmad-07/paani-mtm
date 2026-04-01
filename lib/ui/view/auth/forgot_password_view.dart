import 'package:flutter/material.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_colors.dart';
import 'package:paani/ui/components/custom_field.dart';
import 'package:paani/ui/components/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/extensions/routes.dart';
import 'otp_verification_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late AuthController authVC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authVC = context.watch<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.height,
              Text(
                'Forgot Password?',
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              1.height,
              Text(
                'Enter your email to receive OTP',
                style: TextStyle(
                  color: AppColor.darkGrey,
                  fontSize: 4.5.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
              10.height,
              CustomField(
                controller: authVC.forgotPasswordController,
                hintText: 'Enter Email',
                keyType: TextInputType.emailAddress,
              ),
              10.height,
              RoundButton(
                width: double.maxFinite,
                title: 'Send OTP',
                buttonColor: AppColor.appColor1,
                isLoading: authVC.isLoading,
                onPress: () async {
                  // String email = authVC.forgotPasswordController.text.trim();

                  // if (email.isEmpty) {
                  //   Utils.showSnackBar(
                  //     context,
                  //     'Please enter a valid email address',
                  //   );
                  //   return;
                  // }
                  // await authVC.forgotPassword(context, email, true);
                  // if (authVC.isSucceed == true) {
                  //   authVC.forgotPasswordController.clear();
                  // }

                  AppRoutes.push(OTPView(email: 'example@gmail.com'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
