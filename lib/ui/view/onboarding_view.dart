import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paani/core/extensions/routes.dart';
import 'package:paani/core/extensions/sizer.dart';
import 'package:paani/core/resources/app_colors.dart';
import 'package:paani/core/resources/app_images.dart';
import 'package:paani/ui/components/custom_button.dart';
import 'package:paani/ui/view/auth/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
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
              height: 45.h,
              width: double.infinity,
              child: ClipPath(
                clipper: _BottomCurveClipper(),
                child: Image.asset(ImageAssets.onboarding, fit: BoxFit.cover),
              ),
            ),

            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      3.height,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Paani',
                              style: TextStyle(
                                color: AppColor.appDarkColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '. ',
                              style: TextStyle(
                                color: AppColor.appColor1,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '\nPure Water, Delivered to You.',
                              style: TextStyle(
                                color: AppColor.appDarkColor,
                                fontSize: 6.sp,
                                fontWeight: FontWeight.normal,
                                height: 1.3,
                              ),
                            ),
                          ],
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
                      Text(
                        'Why Choose Us',
                        style: TextStyle(
                          color: AppColor.appDarkColor,
                          fontSize: 4.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      2.height,
                      Wrap(
                        spacing: 2.5.w,
                        runSpacing: 1.5.h,
                        children: const [
                          _ProductChip(label: 'Pure', icon: Icons.water_drop),
                          _ProductChip(
                            label: 'Filtered',
                            icon: Icons.filter_alt,
                          ),
                          _ProductChip(
                            label: 'Mineral',
                            icon: Icons.health_and_safety,
                          ),
                          _ProductChip(
                            label: 'Hygienic',
                            icon: Icons.clean_hands,
                          ),
                          _ProductChip(label: 'Fresh', icon: Icons.eco),
                          _ProductChip(label: 'Trusted', icon: Icons.verified),
                          _ProductChip(label: 'Healthy', icon: Icons.favorite),
                          _ProductChip(label: 'Safe', icon: Icons.shield),
                          _ProductChip(label: 'Clean', icon: Icons.sanitizer),
                          _ProductChip(label: 'Quality', icon: Icons.star),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
            child: RoundButton(
              width: double.maxFinite,
              title: 'Get Started',
              buttonColor: AppColor.appColor1,
              onPress: () async {
                final sp = await SharedPreferences.getInstance();
                await sp.setBool('isFirstTime', false);
                AppRoutes.pushAndRemoveAll(LoginView());
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ProductChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
          Icon(icon, size: 4.5.sp, color: AppColor.appColor1),
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
