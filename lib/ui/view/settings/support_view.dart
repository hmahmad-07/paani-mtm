import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(title: 'Customer Support'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColor.appColor1.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.headphone_bold,
                size: 60,
                color: AppColor.appColor1,
              ),
            ),
            4.height,
            Text(
              "How can we help you?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.appDarkColor,
              ),
              textAlign: TextAlign.center,
            ),
            1.height,
            Text(
              "Our team is available 24/7 to assist you with your water delivery needs.",
              style: TextStyle(
                fontSize: 14,
                color: AppColor.grey,
              ),
              textAlign: TextAlign.center,
            ),
            6.height,
            _buildSupportCard(
              title: "Contact Us",
              subtitle: "Call us directly at +92 300 0000000",
              icon: Iconsax.call_bold,
              color: Colors.blue,
              onTap: () {},
            ),
            2.height,
            _buildSupportCard(
              title: "WhatsApp",
              subtitle: "Chat with us for quick support",
              icon: Iconsax.message_2_bold,
              color: Colors.green,
              onTap: () {},
            ),
            2.height,
            _buildSupportCard(
              title: "Email Us",
              subtitle: "support@paani.com",
              icon: Iconsax.sms_bold,
              color: Colors.orange,
              onTap: () {},
            ),
            6.height,
            RoundButton(
              width: double.maxFinite,
              title: "Visit Help Center",
              buttonColor: AppColor.appDarkColor,
              onPress: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColor.appDarkColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: AppColor.grey),
        ),
        onTap: onTap,
      ),
    );
  }
}
