// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/extensions/routes.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/resources/app_colors.dart';
import 'reset_password_view.dart';

class OTPView extends StatefulWidget {
  final String email;

  const OTPView({super.key, required this.email});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  late AuthController authVC;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AuthController>().startTimer();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authVC = context.watch<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 16.w,
      height: 16.w,
      textStyle: TextStyle(
        fontSize: 6.sp,
        fontWeight: FontWeight.bold,
        color: AppColor.black,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.darkGrey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColor.appColor1, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColor.appColor1, width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColor.red, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    5.height,
                    Text(
                      'Verify OTP',
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    1.height,
                    Text(
                      'Enter the 4-digit code sent to:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColor.darkGrey,
                        fontSize: 4.5.sp,
                      ),
                    ),
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColor.black, fontSize: 5.sp),
                    ),
                    10.height,
                    Pinput(
                      controller: authVC.pinController,
                      focusNode: authVC.pinFocusNode,
                      length: 4,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      errorPinTheme: errorPinTheme,
                      forceErrorState: authVC.errorMessage != null,
                      errorText: authVC.errorMessage,
                      errorTextStyle: TextStyle(
                        color: AppColor.red,
                        fontSize: 4.sp,
                      ),
                      showCursor: true,
                      readOnly: true,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        // authVC.verifyOTP(context, widget.email);
                        AppRoutes.pushReplacement(
                          ResetPasswordView(
                            email: 'example@gmail.com',
                            otp: '1234',
                          ),
                        );
                      },
                    ),

                    5.height,

                    if (authVC.canResend)
                      Text(
                        "Didn't receive code?",
                        style: TextStyle(
                          color: AppColor.darkGrey,
                          fontSize: 5.sp,
                        ),
                      ),

                    TextButton(
                      onPressed: authVC.canResend
                          ? () async {
                              // await authVC.forgotPassword(
                              //   context,
                              //   widget.email,
                              //   false,
                              // );
                              // if (authVC.isSucceed == true) {
                              //   authVC.startTimer();
                              // }
                            }
                          : null,
                      child: Text(
                        authVC.canResend
                            ? 'Resend OTP'
                            : 'Resend OTP in ${authVC.resendTimer} seconds',
                        style: TextStyle(
                          color: authVC.canResend
                              ? AppColor.appColor1
                              : AppColor.darkGrey,
                          fontSize: 4.5.sp,
                          fontWeight: FontWeight.bold,
                          decoration: authVC.canResend
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          decorationColor: authVC.canResend
                              ? AppColor.appColor1
                              : AppColor.darkGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(
                left: 2.w,
                right: 2.w,
                bottom: 5.h,
                top: 1.h,
              ),
              color: AppColor.lightGrey,
              child: Column(
                children: [
                  _row(['1', '2', '3']),
                  1.height,
                  _row(['4', '5', '6']),
                  1.height,
                  _row(['7', '8', '9']),
                  1.height,
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          'Clear',
                          null,
                          onPressed: authVC.onClearPressed,
                        ),
                      ),
                      2.width,
                      Expanded(child: _numberButton('0')),
                      2.width,
                      Expanded(
                        child: _actionButton(
                          null,
                          Icons.backspace_outlined,
                          onPressed: authVC.onBackspacePressed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(List<String> numbers) {
    return Row(
      children: numbers
          .map(
            (e) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: _numberButton(e),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _numberButton(String number) {
    return InkWell(
      onTap: () => authVC.onNumberPressed(number),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 15.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.r),
          color: AppColor.white,
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 7.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    String? text,
    IconData? icon, {
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        height: 15.w,
        child: Center(
          child: text != null
              ? Text(
                  text,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
              : Icon(icon, size: 7.sp, color: AppColor.black),
        ),
      ),
    );
  }
}
