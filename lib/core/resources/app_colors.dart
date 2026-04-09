// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paani/core/extensions/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/view/splash_view.dart';

class AppColor {
  static Color red = const Color.fromARGB(255, 249, 84, 84);
  static Color green = const Color(0xFF4CAF50);
  static Color blue = const Color(0xFF2196F3);
  static Color orange = const Color(0xFFFF9800);
  static Color pink = const Color(0xFFE91E63);
  static Color lightBlue = const Color(0xFF03A9F4);
  static Color lightGrey = const Color(0xFFE3E3E3);
  static Color grey = const Color(0xFF696D75);
  static Color darkGrey = const Color(0xFF4B4B4B);
  static Color appColor1 = const Color(0xFF0089D8);
  static Color appColor2 = const Color.fromARGB(255, 239, 187, 45);
  static Color appDarkColor = const Color(0xFF181E4C);
  static Color appLightColor = const Color.fromARGB(255, 251, 246, 233);
  static Color black = const Color(0xFF111111);
  static Color white = const Color(0xFFFFFFFF);
  static Color transparent = Colors.transparent;

  static void swapColors() {
    final tempWhite = white;
    white = black;
    black = tempWhite;

    final tempLight = lightGrey;
    lightGrey = darkGrey;
    darkGrey = tempLight;

    final tempAppDark = appDarkColor;
    appDarkColor = appLightColor;
    appLightColor = tempAppDark;
  }
}

class ThemeManager with ChangeNotifier {
  bool _isSwapped = false;

  bool get isSwapped => _isSwapped;

  ThemeManager([bool initialSwapped = false]) {
    if (initialSwapped) {
      _isSwapped = true;
      AppColor.swapColors();
    }
  }

  Future<void> toggleTheme() async {
    _isSwapped = !_isSwapped;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSwapped', _isSwapped);
    AppColor.swapColors();
    AppRoutes.pushAndRemoveAll(const SplashView());
    notifyListeners();
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColor.appColor1,
      onPrimary: AppColor.white,
      secondary: AppColor.appColor2,
      onSecondary: AppColor.white,
      error: AppColor.red,
      onError: AppColor.white,
      surface: AppColor.white,
      onSurface: AppColor.black,
      surfaceContainerHighest: AppColor.lightGrey,
      outline: AppColor.grey,
      shadow: AppColor.black,
    ),
    scaffoldBackgroundColor: AppColor.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.appColor1,
      foregroundColor: AppColor.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColor.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: AppColor.white),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColor.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.appColor1,
        foregroundColor: AppColor.white,
        disabledBackgroundColor: AppColor.lightGrey,
        disabledForegroundColor: AppColor.grey,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.appColor1,
        side: BorderSide(color: AppColor.appColor1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColor.appColor1),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColor.appColor1,
      foregroundColor: AppColor.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.white,
      hintStyle: TextStyle(color: AppColor.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.appColor1, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.red),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColor.white,
      elevation: 2,
      shadowColor: AppColor.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: DividerThemeData(color: AppColor.lightGrey, thickness: 1),
    iconTheme: IconThemeData(color: AppColor.appDarkColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColor.white,
      selectedItemColor: AppColor.appColor1,
      unselectedItemColor: AppColor.grey,
      elevation: 8,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColor.appDarkColor,
        fontWeight: FontWeight.w800,
      ),
      displayMedium: TextStyle(
        color: AppColor.appDarkColor,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: TextStyle(
        color: AppColor.appDarkColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppColor.appDarkColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(color: AppColor.black, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
        color: AppColor.black,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(color: AppColor.black),
      bodyMedium: TextStyle(color: AppColor.darkGrey),
      bodySmall: TextStyle(color: AppColor.grey),
      labelLarge: TextStyle(color: AppColor.white, fontWeight: FontWeight.w600),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColor.lightGrey,
      selectedColor: AppColor.appColor1,
      labelStyle: TextStyle(color: AppColor.black),
      side: BorderSide(color: AppColor.lightGrey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.appDarkColor,
      contentTextStyle: TextStyle(color: AppColor.white),
      actionTextColor: AppColor.appColor2,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColor.appColor1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColor.appColor1
            : AppColor.grey,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColor.appColor1.withValues(alpha: 0.4)
            : AppColor.lightGrey,
      ),
    ),
  );
}
