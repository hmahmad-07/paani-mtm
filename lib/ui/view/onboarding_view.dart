import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paani/core/extensions/routes.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_colors.dart';
import 'package:paani/core/resources/app_images.dart';
import 'package:paani/ui/components/custom_button.dart';
import 'package:paani/ui/view/auth/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final double imageHeight = 50.h;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: ClipPath(
                clipper: _BottomCurveClipper(),
                child: Image.asset(
                  ImageAssets.onboarding,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Expanded(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      2.height,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Paani',
                              style: TextStyle(
                                color: AppColor.appDarkColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            TextSpan(
                              text: '.',
                              style: TextStyle(
                                color: AppColor.appColor1,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.height,
                      Text(
                        'Pure Water,\nDelivered to You.',
                        style: TextStyle(
                          color: AppColor.appDarkColor,
                          fontSize: 6.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      2.height,
                      Text(
                        'We deliver trust, quality, and convenience in every drop.'
                        'From your home to your office, our pure water reaches you fresh and fast.'
                        'Drink with confidence, stay refreshed, and let us handle the rest —'
                        'every single day, without any hassle.',
                        style: TextStyle(
                          color: AppColor.darkGrey,
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      ),
                      5.height,
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: const [
                          _ProductChip(label: '19L Bottle'),
                          _ProductChip(label: '6L Bottle'),
                          _ProductChip(label: '1.5L Bottle'),
                          _ProductChip(label: '500ml'),
                          _ProductChip(label: '200ml Cup'),
                        ],
                      ),
                      const Spacer(),
                      RoundButton(
                        width: double.maxFinite,
                        title: 'Get Started',
                        buttonColor: AppColor.appColor1,
                        onPress: () async {
                          final sp = await SharedPreferences.getInstance();
                          await sp.setBool('isFirstTime', false);
                          AppRoutes.pushAndRemoveAll(LoginView());
                        },
                      ),
                      2.height,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ProductChip extends StatelessWidget {
  final String label;
  const _ProductChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: AppColor.appColor1.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.appColor1.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.water_drop_rounded,
            size: 4.5.sp,
            color: AppColor.appColor1,
          ),
          1.5.width,
          Text(
            label,
            style: TextStyle(
              color: AppColor.appDarkColor,
              fontSize: 4.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
