// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:paani/core/extensions/routes.dart';
import 'package:paani/ui/view/auth/change_password_view.dart';
import 'package:paani/ui/view/auth/otp_verification_view.dart';
import 'package:paani/ui/view/dashboard/dashboard_view.dart';
import 'package:paani/ui/view/splash_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/view/auth/login_view.dart';
import '../constants/app_constants.dart';
import '../resources/app_colors.dart';
import '../utils/utils.dart';

class AuthController extends ChangeNotifier {
  var isLoading = false;

  bool isObscured = true;
  void setObscure(value) {
    isObscured = value;
    notifyListeners();
  }

  bool isAcceptedTerms = false;
  void acceptTerms(value) {
    isAcceptedTerms = value;
    notifyListeners();
  }

  // ================================================================ Login =================================================================

  final emailPhoneController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final formData = {
        'tag': 'login',
        'email': emailPhoneController.text.trim(),
        'password': passwordController.text.trim(),
      };

      final dio = Dio();

      final response = await dio.post(
        '${Constants.baseUrl}login_api_cspmobile.php',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['error'] == 0) {
          Utils.showSnackBar(
            context,
            data['error_msg']?.toString() ?? 'Login successful!',
          );

          await saveUserData(data);

          AppRoutes.pushAndRemoveAll(DashboardView(initialIndex: 0));

          emailPhoneController.clear();
          passwordController.clear();
        } else {
          Utils.showSnackBar(context, data['error_msg'] ?? 'Login failed');
        }
      }
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data}');

      Utils.showSnackBar(
        context,
        e.response?.data?['error_msg'] ?? 'Login failed. Check credentials',
      );
    } catch (e) {
      log('Unexpected error: $e');

      Utils.showSnackBar(context, 'Something went wrong');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString('token', data['token'] ?? '');
    await sp.setString('entityID', data['ENTITY_NO'] ?? '');
    await sp.setString('entityName', data['ENTITY_NAME'] ?? '');
    await sp.setString('phone', data['CELL_NUM'] ?? '');
    await sp.setString('personName', data['CONTACT_PERSON'] ?? '');

    Constants.token = data['token'] ?? '';
    Constants.entityID = data['ENTITY_NO'] ?? '';
    Constants.entityName = data['ENTITY_NAME'] ?? '';
    Constants.phone = data['CELL_NUM'] ?? '';
    Constants.personName = data['CONTACT_PERSON'] ?? '';

    await loadUserDetail();
  }

  Future<void> loadUserDetail() async {
    final sp = await SharedPreferences.getInstance();

    Constants.token = sp.getString('token') ?? '';
    Constants.entityID = sp.getString('entityID') ?? '';
    Constants.entityName = sp.getString('entityName') ?? '';
    Constants.phone = sp.getString('phone') ?? '';
    Constants.personName = sp.getString('personName') ?? '';

    log('Token: ${Constants.token}');
    log('ID: ${Constants.entityID}');
    log('Entity: ${Constants.entityName}');
    log('Phone: ${Constants.phone}');
    log('Name: ${Constants.personName}');
  }

  // ================================================================ Forgot Password =================================================================

  final forgotPasswordController = TextEditingController();

  bool? isSucceed;
  Future<void> forgotPassword(
    BuildContext context,
    String email,
    bool isFromLogin,
  ) async {
    bool dialogShown = false;

    try {
      isLoading = true;
      notifyListeners();

      if (isFromLogin == false) {
        if (!context.mounted) return;
        loadingDialog(context);
        dialogShown = true;
      }

      final params = {'email': email};

      final dio = Dio();
      final response = await dio.request(
        '${Constants.baseUrl}auth/forgot-password',
        options: Options(
          method: 'POST',
          headers: {'Accept': 'application/json'},
        ),
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true) {
          if (dialogShown && context.mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
            dialogShown = false;
          }

          if (!context.mounted) return;

          Utils.showSnackBar(
            context,
            data['message']?.toString() ?? 'OTP sent successfully!',
          );
          isSucceed = true;

          if (isFromLogin == true) {
            AppRoutes.push(OTPView(email: email));
          } else {}
        } else {
          Utils.showSnackBar(
            context,
            data['message']?.toString() ??
                'Failed to send OTP. Please try again',
          );
          isSucceed = false;
        }
        log('Forgot Password successful: $data');
      }
    } on DioException catch (e) {
      log('Dio error during forgot password: $e');
      Utils.showSnackBar(context, 'Failed to send OTP. Please try again');
      isSucceed = false;
    } catch (e) {
      log('Unexpected error during forgot password: $e');
      Utils.showSnackBar(
        context,
        'An unexpected error occurred. Please try again',
      );
      isSucceed = false;
    } finally {
      isLoading = false;
      notifyListeners();
      if (dialogShown && context.mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  // ================================================================ OTP Verification =================================================================

  final pinController = TextEditingController();
  final pinFocusNode = FocusNode();

  bool canResend = false;
  int resendTimer = 60;
  Timer? _timer;
  String? errorMessage;

  void startTimer() {
    canResend = false;
    resendTimer = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer > 0) {
        resendTimer--;
      } else {
        canResend = true;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void onNumberPressed(String number) {
    if (pinController.text.length < 6) {
      pinController.text += number;
      errorMessage = null;
      notifyListeners();
    }
  }

  void onBackspacePressed() {
    if (pinController.text.isNotEmpty) {
      pinController.text = pinController.text.substring(
        0,
        pinController.text.length - 1,
      );
      notifyListeners();
    }
  }

  void onClearPressed() {
    pinController.clear();
    errorMessage = null;
    notifyListeners();
  }

  Future<void> verifyOTP(BuildContext context, String email) async {
    if (pinController.text.length < 4) {
      errorMessage = "Please enter complete OTP";
      notifyListeners();
      return;
    }

    bool dialogShown = false;

    try {
      isLoading = true;
      notifyListeners();

      if (!context.mounted) return;
      loadingDialog(context);
      dialogShown = true;

      final dio = Dio();
      final response = await dio.post(
        '${Constants.baseUrl}auth/verify-otp',
        data: {"email": email, "otp": pinController.text},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data;

      if (response.statusCode == 200 && data['success'] == true) {
        if (dialogShown && context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
          dialogShown = false;
        }

        if (!context.mounted) return;

        Utils.showSnackBar(context, data['message'] ?? 'OTP verified');

        AppRoutes.pushReplacement(const ChangePasswordView());

        pinController.clear();
        pinFocusNode.unfocus();
      } else {
        errorMessage = data['message'] ?? "Invalid OTP";
        notifyListeners();
      }
    } on DioException catch (e) {
      log("OTP error: $e");
      errorMessage = "Failed to verify OTP";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();

      if (dialogShown && context.mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  // ================================================================ Change Password =================================================================

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> changePassword(
    BuildContext context,
    String email,
    String otp,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final dio = Dio();
      final response = await dio.post(
        '${Constants.baseUrl}auth/reset-password',
        data: {
          "email": email,
          "otp": otp,
          "password": newPasswordController.text.trim(),
          "password_confirmation": confirmPasswordController.text.trim(),
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data;

      if (response.statusCode == 200 && data['success'] == true) {
        Utils.showSnackBar(
          context,
          data['message'] ?? 'Password changed successfully',
        );

        AppRoutes.pushAndRemoveAll(LoginView());

        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        Utils.showSnackBar(
          context,
          data['message'] ?? 'Failed to change password',
        );
      }
    } on DioException catch (e) {
      log("Change Password error: $e");
      Utils.showSnackBar(context, 'Failed to change password');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==================================================================> Dispose

  @override
  void dispose() {
    emailPhoneController.dispose();
    passwordController.dispose();
    forgotPasswordController.dispose();
    _timer?.cancel();
    pinController.dispose();
    pinFocusNode.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ================================================> Get user location Address

  var isLoadingAddress = false;

  Future<void> getAddress({
    required BuildContext context,
    TextEditingController? controller,
  }) async {
    try {
      isLoadingAddress = true;
      notifyListeners();

      PermissionStatus permission = await Permission.location.status;

      if (permission.isDenied) {
        permission = await Permission.location.request();
      }

      if (permission.isPermanentlyDenied) {
        Utils.showSnackBar(
          context,
          'Please enable location permission from settings',
        );
        await openAppSettings();
        return;
      }

      if (!permission.isGranted) {
        Utils.showSnackBar(context, 'Location permission is required');
        return;
      }

      if (!context.mounted) return;

      loadingDialog(context);

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception("No address found for this location");
      }

      Placemark place = placemarks[0];
      List<String> addressParts = [];
      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        addressParts.add(place.subLocality!);
      }
      if (place.locality != null && place.locality!.isNotEmpty) {
        addressParts.add(place.locality!);
      }
      if (place.administrativeArea != null &&
          place.administrativeArea!.isNotEmpty) {
        addressParts.add(place.administrativeArea!);
      }
      if (place.country != null && place.country!.isNotEmpty) {
        addressParts.add(place.country!);
      }
      String cleanAddress = addressParts.join(', ');
      if (cleanAddress.isEmpty) {
        cleanAddress = "${place.street ?? ''} ${place.locality ?? ''}".trim();
      }

      controller?.text = cleanAddress;
    } catch (e) {
      debugPrint("Error fetching location: $e");
    } finally {
      isLoadingAddress = false;
      notifyListeners();
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  // ================================================ Logout ===========================================================

  Future<void> logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();

    try {
      isLoading = true;
      notifyListeners();

      await sp.remove('token');
      await sp.remove('entityID');
      await sp.remove('entityName');
      await sp.remove('phone');
      await sp.remove('personName');

      Constants.token = '';
      Constants.entityID = '';
      Constants.entityName = '';
      Constants.phone = '';
      Constants.personName = '';

      await Phoenix.rebirth(context);

      if (!context.mounted) return;
      AppRoutes.pushAndRemoveAll(const SplashView());
    } catch (e) {
      debugPrint('Logout error: $e');

      if (context.mounted) {
        Utils.showSnackBar(context, "Logout failed");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void loadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColor.grey.withValues(alpha: .1),
                blurRadius: 3,
                spreadRadius: 2,
                offset: const Offset(0, .3),
              ),
            ],
          ),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
