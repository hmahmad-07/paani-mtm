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

class ChangePasswordView extends StatefulWidget {
  final String email;
  final String otp;
  const ChangePasswordView({super.key, required this.email, required this.otp});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
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
                'Change Password',
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
                title: 'Change Password',
                buttonColor: AppColor.appColor1,
                isLoading: authVC.isLoading,
                onPress: () async {
                  // final newPass = authVC.newPasswordController.text.trim();
                  // final confirmPass = authVC.confirmPasswordController.text
                  //     .trim();

                  // if (newPass.isEmpty || confirmPass.isEmpty) {
                  //   Utils.showSnackBar(context, 'Please fill all fields');
                  //   return;
                  // }

                  // if (newPass.length < 8) {
                  //   Utils.showSnackBar(
                  //     context,
                  //     'Password must be at least 8 characters',
                  //   );
                  //   return;
                  // }

                  // if (newPass != confirmPass) {
                  //   Utils.showSnackBar(
                  //     context,
                  //     'Password and Confirm Password do not match',
                  //   );
                  //   return;
                  // }
                  // await authVC.changePassword(
                  //   context,
                  //   widget.email,
                  //   widget.otp,
                  // );

                  AppRoutes.pushAndRemoveAll(LoginView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
