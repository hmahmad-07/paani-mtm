// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_images.dart';
import 'package:paani/ui/view/dashboard/dashboard_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:paani/ui/view/auth/login_view.dart';
// import 'package:paani/ui/view/home/home_view.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../core/controllers/auth_controller.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/extensions/routes.dart';
import '../../core/resources/app_colors.dart';
import 'auth/login_view.dart';
import 'onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<void> _checkFirstTime() async {
    final sp = await SharedPreferences.getInstance();

    final token = sp.getString('token') ?? '';
    final isFirstTime = sp.getBool('isFirstTime') ?? true;

    if (!mounted) return;

    if (isFirstTime) {
      AppRoutes.pushReplacement(const OnboardingView());
    } else if (token.isEmpty) {
      AppRoutes.pushReplacement(const LoginView());
    } else {
      await context.read<AuthController>().loadUserDetail();
      AppRoutes.pushReplacement(const DashboardView(initialIndex: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(ImageAssets.splash, width: 60.w),
                2.height,
                SizedBox(
                  width: double.infinity,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 6.sp,
                      color: AppColor.appDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Center(
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TyperAnimatedText(
                            'Bottled Drinking Water',
                            textStyle: TextStyle(
                              fontSize: 6.sp,
                              color: AppColor.appDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                            speed: const Duration(milliseconds: 150),
                          ),
                        ],
                        onFinished: _checkFirstTime,
                      ),
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
