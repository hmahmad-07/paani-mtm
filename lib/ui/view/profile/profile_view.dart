import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_appbar.dart';
import 'update_profile_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(
        title: 'My Profile',
        actions: [
          IconButton(
            onPressed: () {
              AppRoutes.push(const UpdateProfileView());
            },
            icon: Icon(Iconsax.edit_2_outline, color: AppColor.appColor1),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          child: Column(
            children: [
              2.height,
              Container(
                padding: EdgeInsets.all(4.w),
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
                child: Column(
                  children: [
                    _detailTile(
                      icon: Iconsax.user_outline,
                      title: 'John Doe',
                      subtitle: 'Full Name',
                    ),
                    const Divider(height: 30),
                    _detailTile(
                      icon: Iconsax.sms_outline,
                      title: 'johndoe@example.com',
                      subtitle: 'Email Address',
                    ),
                    const Divider(height: 30),
                    _detailTile(
                      icon: Iconsax.call_outline,
                      title: '+1234567890',
                      subtitle: 'Phone Number',
                    ),
                    const Divider(height: 30),
                    _detailTile(
                      icon: Bootstrap.geo_alt,
                      title: '123 Main Street, Unit 4B',
                      subtitle: 'Delivery Address',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.appColor1.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColor.appColor1, size: 24),
        ),
        4.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: TextStyle(color: AppColor.grey, fontSize: 12),
              ),
              2.height,
              Text(
                title,
                style: TextStyle(
                  color: AppColor.appDarkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
