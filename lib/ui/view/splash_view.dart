// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_images.dart';
// import 'package:paani/ui/view/auth/login_view.dart';
// import 'package:paani/ui/view/home/home_view.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../core/controllers/auth_controller.dart';
import '../../core/extensions/routes.dart';
import '../../core/resources/app_colors.dart';
import 'onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTime();
    });
    super.initState();
  }

  Future<void> _checkFirstTime() async {
    await Future.delayed(const Duration(seconds: 3));
    AppRoutes.pushReplacement(const OnboardingView());
  }

  // Future<void> _checkFirstTime() async {
  //   final sp = await SharedPreferences.getInstance();
  //   var token = sp.getString('token') ?? '';
  //   var isFirstTime = sp.getBool('isFirstTime') ?? true;

  //   await Future.delayed(const Duration(seconds: 3));

  //   if (!mounted) return;

  //   if (isFirstTime) {
  //     AppRoutes.pushReplacement(const OnboardingView());
  //   } else if (token.isEmpty) {
  //     AppRoutes.pushReplacement(const LoginView());
  //   } else {
  //     final authController = context.read<AuthController>();
  //     await authController.getProfile(context, token);

  //     if (!mounted) return;
  //     AppRoutes.pushReplacement(const HomeView());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Image.asset(ImageAssets.splash),
          ),
        ),
      ),
    );
  }
}
