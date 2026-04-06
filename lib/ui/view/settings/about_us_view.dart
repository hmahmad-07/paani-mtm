import 'package:flutter/material.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_appbar.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(title: 'About Us'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(8.w, 0.h, 8.w, 2.h),
        child: Column(
          children: [
            Container(
              height: 30.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.appColor1.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/appIcon.png', height: 80, width: 80),
                    2.height,
                    Text(
                      'PAANI Premium',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColor.appColor1,
                      ),
                    ),
                    Text(
                      'Pure. Refreshing. Guaranteed.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.appDarkColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            4.height,
            _buildInfoCard(
              title: "Our Mission",
              content:
                  "At PAANI, our mission is simple: to provide clean, safe, and premium drinking water to every household and office in Pakistan. We believe that hydration is the foundation of health, and we are committed to upholding the highest standards of purification and hygiene.",
            ),
            2.height,
            _buildInfoCard(
              title: "Why Choose Us?",
              content:
                  "• Reverse Osmosis & UV Treatment\n• Modern Filtration Standards\n• On-time Home Delivery\n• Recyclable Packaging\n• 24/7 Quality Monitoring",
            ),
            2.height,
            _buildInfoCard(
              title: "Our Journey",
              content:
                  "Started in 2024, PAANI grew from a small local project to a trusted name in water delivery. We take pride in our service efficiency and the trust thousands of families put in us every day.",
            ),
            4.height,
            Text(
              "Version 1.0.0",
              style: TextStyle(color: AppColor.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: .1),
            blurRadius: 3,
            spreadRadius: 2,
            offset: const Offset(0, .3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColor.appDarkColor,
            ),
          ),
          1.5.height,
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.darkGrey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
