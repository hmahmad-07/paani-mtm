import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:paani/core/extensions/routes.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_colors.dart';
import 'package:paani/ui/components/custom_field.dart';
import 'package:paani/ui/components/custom_button.dart';
import 'package:paani/ui/view/auth/forgot_password_view.dart';
import 'package:paani/ui/view/auth/user_signup_view.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/auth_controller.dart';
import '../dashboard/dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                1.height,
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    color: AppColor.darkGrey,
                    fontSize: 4.5.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                5.height,
                CustomField(
                  controller: authVC.emailPhoneController,
                  hintText: 'Enter Email or Phone Number',
                  keyType: TextInputType.emailAddress,
                ),
                CustomField(
                  controller: authVC.passwordController,
                  hintText: 'Enter Password',
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

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      AppRoutes.push(ForgotPasswordView());
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColor.appColor2,
                        fontSize: 4.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                5.height,

                RoundButton(
                  width: double.maxFinite,
                  title: 'Sign In',
                  buttonColor: AppColor.appColor1,
                  isLoading: authVC.isLoading,
                  onPress: () async {
                    AppRoutes.pushAndRemoveAll(const DashboardView());
                  },
                ),
                3.height,
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColor.grey, thickness: .5),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: AppColor.darkGrey,
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppColor.grey, thickness: .5),
                    ),
                  ],
                ),
                3.height,
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Don't have an account?",
                      style: TextStyle(
                        color: AppColor.darkGrey,
                        fontSize: 4.5.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: '  Sign Up',
                          style: TextStyle(
                            color: AppColor.appColor2,
                            fontSize: 4.5.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AppRoutes.push(UserSignupView());
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
