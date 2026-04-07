import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../../core/resources/app_colors.dart';
import '../../core/extensions/sizer.dart';
import '../../core/extensions/routes.dart';
import '../view/auth/change_password_view.dart';
import '../view/orders/order_tracking_view.dart';
import '../view/settings/privacy_policy_view.dart';
import '../view/settings/terms_conditions_view.dart';
import '../view/auth/login_view.dart';
import '../view/profile/profile_view.dart';
import '../view/dashboard/dashboard_view.dart';
import '../view/settings/support_view.dart';
import '../view/settings/about_us_view.dart';
import '../view/settings/contact_us_view.dart';

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
                    _sectionLabel("Navigation"),
                    customTile(
                      context: context,
                      icon: Iconsax.home_bold,
                      title: "Home",
                      onTap: () {
                        AppRoutes.pop();
                        if (onTabSelected != null) {
                          onTabSelected!(0);
                        } else {
                          AppRoutes.pushAndRemoveAll(
                            const DashboardView(initialIndex: 0),
                          );
                        }
                      },
                    ),
                    customTile(
                      context: context,
                      icon: Iconsax.box_bold,
                      title: "My Orders",
                      onTap: () {
                        AppRoutes.pop();
                        AppRoutes.push(
                          const OrderTrackingView(isStandalone: true),
                        );
                      },
                    ),

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
                    customTile(
                      context: context,
                      icon: Iconsax.headphone_bold,
                      title: "Support",
                      onTap: () {
                        AppRoutes.pop();
                        AppRoutes.push(const SupportView());
                      },
                    ),

                    _sectionLabel("Company"),
                    customTile(
                      context: context,
                      icon: Iconsax.info_circle_bold,
                      title: "About Us",
                      onTap: () {
                        AppRoutes.pop();
                        AppRoutes.push(const AboutUsView());
                      },
                    ),
                    customTile(
                      context: context,
                      icon: Iconsax.headphone_bold,
                      title: "Contact Us",
                      onTap: () {
                        AppRoutes.pop();
                        AppRoutes.push(const ContactUsView());
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

                    _sectionLabel("Settings"),
                    Consumer<ThemeManager>(
                      builder: (context, themeManager, _) {
                        return customTile(
                          context: context,
                          icon: themeManager.isSwapped
                              ? Iconsax.sun_1_bold
                              : Iconsax.moon_bold,
                          title: themeManager.isSwapped
                              ? "Light Mode"
                              : "Dark Mode",
                          onTap: () => themeManager.toggleTheme(),
                        );
                      },
                    ),

                    1.height,
                    Divider(color: AppColor.lightGrey),
                    customTile(
                      context: context,
                      clr2: AppColor.appDarkColor,
                      icon: Iconsax.logout_bold,
                      title: "Logout",
                      onTap: () => logOut(context),
                    ),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 7),
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
    Color? clr2,
  }) {
    final effectiveColor = clr2 ?? AppColor.appColor1;
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      leading: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 15, color: effectiveColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.black,
          fontSize: 4.2.sp,
          fontWeight: FontWeight.bold,
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
            child: Text("Logout", style: TextStyle(color: AppColor.red)),
          ),
        ],
      ),
    );
  }
}
