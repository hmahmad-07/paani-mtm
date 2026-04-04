import 'package:flutter/material.dart';
import 'package:paani/core/extensions/routes.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_colors.dart';
import 'package:paani/ui/components/custom_field.dart';
import 'package:paani/ui/components/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/auth_controller.dart';
import 'login_view.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordView({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.height,
              Text(
                'Reset Password',
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              1.height,
              Text(
                'Create a new password for your account',
                style: TextStyle(
                  color: AppColor.darkGrey,
                  fontSize: 4.5.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
              10.height,

              CustomField(
                controller: authVC.newPasswordController,
                hintText: 'New Password',
                obscureText: authVC.isObscured,
                suffixIcon: GestureDetector(
                  onTap: () {
                    authVC.setObscure(!authVC.isObscured);
                  },
                  child: Icon(
                    size: 20,
                    authVC.isObscured ? Bootstrap.eye_slash : Bootstrap.eye,
                    color: AppColor.darkGrey,
                  ),
                ),
              ),

              CustomField(
                controller: authVC.confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: authVC.isObscured,
                suffixIcon: GestureDetector(
                  onTap: () {
                    authVC.setObscure(!authVC.isObscured);
                  },
                  child: Icon(
                    size: 20,
                    authVC.isObscured ? Bootstrap.eye_slash : Bootstrap.eye,
                    color: AppColor.darkGrey,
                  ),
                ),
              ),
              10.height,

              RoundButton(
                width: double.maxFinite,
                title: 'Reset Password',
                buttonColor: AppColor.appColor1,
                isLoading: authVC.isLoading,
                onPress: () async {
                  AppRoutes.pushAndRemoveAll(const LoginView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
