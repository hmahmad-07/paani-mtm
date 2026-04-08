import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:paani/core/controllers/auth_controller.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_colors.dart';
import 'package:paani/ui/components/custom_field.dart';
import 'package:paani/ui/components/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/routes.dart';
import '../../components/intl_phone_field.dart';
import 'login_view.dart';

class UserSignupView extends StatefulWidget {
  const UserSignupView({super.key});

  @override
  State<UserSignupView> createState() => _UserSignupViewState();
}

class _UserSignupViewState extends State<UserSignupView> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                1.height,
                Text(
                  'Sign up',
                  style: TextStyle(
                    color: AppColor.darkGrey,
                    fontSize: 4.5.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                5.height,

                CustomField(
                  controller: TextEditingController(),
                  hintText: 'Full Name',
                  keyType: TextInputType.name,
                ),

                IntlField(
                  controller: TextEditingController(),
                  hintText: 'Phone Number',
                  onChanged: (phone) {},
                ),

                CustomField(
                  controller: TextEditingController(),
                  hintText: 'Email Address',
                  keyType: TextInputType.emailAddress,
                ),

                CustomField(
                  controller: TextEditingController(),
                  hintText: 'Address',
                  keyType: TextInputType.streetAddress,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      authVC.getAddress(context: context);
                    },
                    child: Icon(Bootstrap.geo_alt_fill, color: AppColor.red),
                  ),
                ),

                CustomField(
                  controller: TextEditingController(),
                  hintText: 'Password',
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
                  controller: TextEditingController(),
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

                Row(
                  children: [
                    Checkbox(
                      value: authVC.isAcceptedTerms,
                      onChanged: (value) {
                        authVC.acceptTerms(value);
                      },
                      activeColor: AppColor.appColor1,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I accept the ',
                          style: TextStyle(
                            color: AppColor.darkGrey,
                            fontSize: 4.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                color: AppColor.appColor2,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                5.height,
                RoundButton(
                  width: double.maxFinite,
                  title: 'Sign Up',
                  buttonColor: AppColor.appColor1,
                  isLoading: authVC.isLoading,
                  onPress: () async {
                    AppRoutes.pushReplacement(LoginView());
                  },
                ),
                3.height,
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Already have an account?',
                      style: TextStyle(
                        color: AppColor.darkGrey,
                        fontSize: 4.5.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: '  Sign In',
                          style: TextStyle(
                            color: AppColor.appColor2,
                            fontSize: 4.5.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
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
