import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_appbar.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(title: 'Contact Us'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: Column(
          children: [
            _buildContactHeader(),
            4.height,
            _buildContactCard(
              title: "Address",
              content: "Main Gulshan Road, Block 4, Karachi, Pakistan",
              icon: Iconsax.location_bold,
              color: AppColor.appColor1,
            ),
            2.height,
            _buildContactCard(
              title: "Phone",
              content: "+92 21 00000000\n+92 300 0000000",
              icon: Iconsax.call_bold,
              color: Colors.blue,
            ),
            2.height,
            _buildContactCard(
              title: "Email",
              content: "info@paani.com\nsales@paani.com",
              icon: Iconsax.sms_bold,
              color: Colors.orange,
            ),
            2.height,
            _buildContactCard(
              title: "Working Hours",
              content: "Mon - Sat: 08:00 AM - 10:00 PM\nSun: 10:00 AM - 06:00 PM",
              icon: Iconsax.clock_bold,
              color: AppColor.appDarkColor,
            ),
            6.height,
            Text(
              "Follow Us",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.appDarkColor,
              ),
            ),
            2.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Brands.facebook, Colors.blue),
                6.width,
                _buildSocialIcon(Brands.instagram, Colors.pink),
                6.width,
                _buildSocialIcon(Brands.twitter, Colors.lightBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColor.appDarkColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Iconsax.headphone_bold, color: AppColor.white, size: 50),
          2.height,
          Text(
            "We're here for you!",
            style: TextStyle(
              color: AppColor.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          1.height,
          Text(
            "Get in touch with us for any inquiries or support related to our services.",
            style: TextStyle(
              color: AppColor.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: .1),
            blurRadius: 3,
            spreadRadius: 2,
            offset: const Offset(0, .3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          4.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColor.appDarkColor,
                  ),
                ),
                1.height,
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.darkGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String iconPath, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Brand(iconPath, size: 24),
    );
  }
}
