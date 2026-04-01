import 'package:flutter/material.dart';
import 'package:paani/core/extensions/sizer.dart';
import '../../core/resources/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: .1),
            offset: const Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        foregroundColor: AppColor.black,
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,

        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 6.5.sp,
            color: AppColor.black,
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(9.h);
}
