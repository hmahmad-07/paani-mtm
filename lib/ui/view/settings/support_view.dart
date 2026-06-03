import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/utils/utils.dart';
import '../../components/custom_appbar.dart';

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
            2.height,
            Text(
              "Get in Touch",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.appDarkColor,
              ),
              textAlign: TextAlign.center,
            ),
            1.height,
            Text(
              "We're here to help and answer any question you might have. We look forward to hearing from you.",
              style: TextStyle(fontSize: 14, color: AppColor.grey),
              textAlign: TextAlign.center,
            ),
            4.height,
            _buildSupportCard(
              title: "Call Us",
              subtitle: "+92 333 6597676",
              icon: Iconsax.call_bold,
              color: AppColor.blue,
              onTap: () => Utils.makePhoneCall("+923336597676"),
            ),
            2.height,
            _buildSupportCard(
              title: "Email Us",
              subtitle: "customercare@paanisoulhealing.com",
              icon: Iconsax.sms_search_outline,
              color: AppColor.orange,
              onTap: () => Utils.sendEmail("customercare@paanisoulhealing.com"),
            ),
            2.height,
            _buildSupportCard(
              title: "Our Office",
              subtitle: "24D, Batala Colony, Faisalabad.",
              icon: Iconsax.location_bold,
              color: AppColor.red,
              onTap: () => Utils.launchURL(
                "https://www.google.com/maps/search/?api=1&query=24D,+Batala+Colony,+Faisalabad",
              ),
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
            3.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(
                  Brand(Brands.facebook),
                  () => Utils.launchURL(
                    "https://www.facebook.com/paani.officiall/",
                  ),
                ),
                5.width,
                _socialIcon(
                  Brand(Brands.instagram),
                  () => Utils.launchURL(
                    "https://www.instagram.com/paani.officiall/",
                  ),
                ),
                5.width,
                _socialIcon(
                  Brand(Brands.linkedin),
                  () => Utils.launchURL(
                    "https://www.linkedin.com/company/paani-76",
                  ),
                ),
                5.width,
                _socialIcon(
                  Brand(Brands.whatsapp),
                  () => Utils.openWhatsApp("+923336597676"),
                ),
              ],
            ),
            4.height,
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.grey.withValues(alpha: .15),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: SizedBox(height: 12.w, width: 12.w, child: icon),
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
