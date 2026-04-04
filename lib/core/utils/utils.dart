import 'package:flutter/material.dart';
import 'package:paani/core/extensions/sizer.dart';
import '../resources/app_colors.dart';
import '../resources/app_images.dart';

class Utils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: AppColor.white,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(ImageAssets.appIcon, height: 20, width: 20),
            ),
            4.width,
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 4.2.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  static String getInitials(String name) {
    if (name.isEmpty) return '??';
    List<String> names = name.split(' ');
    if (names.length > 1) {
      return (names[0][0] + names[names.length - 1][0]).toUpperCase();
    }
    return names[0][0].toUpperCase();
  }

  static Future<void> launchURL(String url) async {
    // ignore: deprecated_member_use
    // if (await canLaunch(url)) {
    //   await launch(url);
    // }
  }
}
