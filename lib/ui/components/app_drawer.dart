import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:paani/core/utils/utils.dart';
import '../../core/resources/app_colors.dart';
import '../../core/extensions/sizer.dart';
import '../../core/extensions/routes.dart';
import '../view/auth/change_password_view.dart';
import '../view/settings/privacy_policy_view.dart';
import '../view/settings/terms_conditions_view.dart';
import '../view/auth/login_view.dart';
import '../view/profile/profile_view.dart';

class AppDrawer extends StatelessWidget {
  final Function(int)? onTabSelected;
  const AppDrawer({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Drawer(
        backgroundColor: AppColor.white,
        width: 85.w,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 20,
                16,
                20,
              ),
              color: AppColor.appColor1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColor.appDarkColor,
                    child: Text(
                      Utils.getInitials("John Doe"),
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  2.height,
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColor.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'johndoe@example.com',
                    style: TextStyle(
                      color: AppColor.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel("Account"),
                    customTile(
                      context: context,
                      icon: Iconsax.user_bold,
                      title: "My Profile",
                      onTap: () {
                        AppRoutes.pop();
                        AppRoutes.push(const ProfileView());
                      },
                    ),
                    customTile(
                      context: context,
                      icon: Iconsax.lock_bold,
                      title: "Change Password",
                      onTap: () {
                        AppRoutes.pop();
                        AppRoutes.push(const ChangePasswordView());
                      },
                    ),

                    _sectionLabel("Legal"),
                    customTile(
                      context: context,
                      icon: Iconsax.shield_tick_bold,
                      title: "Privacy Policy",
                      onTap: () {
                        AppRoutes.pop();
                        AppRoutes.push(const PrivacyPolicyView());
                      },
                    ),
                    customTile(
                      context: context,
                      icon: Iconsax.document_text_bold,
                      title: "Terms & Conditions",
                      onTap: () {
                        AppRoutes.pop();
                        AppRoutes.push(const TermsConditionsView());
                      },
                    ),

                    15.height,
                    customTile(
                      context: context,
                      clr2: AppColor.appDarkColor,
                      icon: Iconsax.logout_bold,
                      title: "Logout",
                      onTap: () => logOut(context),
                    ),
                    customTile(
                      context: context,
                      clr2: Colors.red,
                      icon: CupertinoIcons.delete_solid,
                      title: "Delete Account",
                      onTap: () => deleteAccount(context),
                    ),
                    20.height,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          color: AppColor.grey,
          letterSpacing: 1.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget customTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color clr2 = const Color(0xFF0089D8),
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: clr2.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: clr2),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  void logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.white,
        title: const Text("Logout?"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppRoutes.pushAndRemoveAll(const LoginView());
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.white,
        title: const Text(
          "Delete Account?",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          "This action cannot be undone. All your data will be permanently deleted.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppRoutes.pushAndRemoveAll(const LoginView());
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
