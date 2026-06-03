import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_colors.dart';
import 'package:paani/ui/components/custom_field.dart';
import 'package:paani/ui/components/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/utils/utils.dart';
import '../../components/phone_formatter.dart';

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
                  hintText: 'Enter Phone Number',
                  keyType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PhoneNumberFormatter(),
                  ],
                ),
                10.height,
                RoundButton(
                  width: double.maxFinite,
                  title: 'Sign In',
                  buttonColor: AppColor.appColor1,
                  isLoading: authVC.isLoading,
                  onPress: () async {
                    if (authVC.emailPhoneController.text.isEmpty) {
                      Utils.showSnackBar(
                        context,
                        'Please enter your phone number',
                      );
                      return;
                    }

                    await authVC.login(context);
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
