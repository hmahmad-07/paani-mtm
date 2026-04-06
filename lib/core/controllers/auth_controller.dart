// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:paani/core/extensions/routes.dart';
import 'package:paani/ui/view/auth/change_password_view.dart';
import 'package:paani/ui/view/auth/otp_verification_view.dart';
import 'package:paani/ui/view/home/home_view.dart';
import 'package:paani/ui/view/splash_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/view/auth/login_view.dart';
import '../constants/app_constants.dart';
import '../models/user_profile_model.dart';
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

  // ============================================================ Registration ============================================================

  final userNameController = TextEditingController();
  final userPhoneController = TextEditingController();
  final userEmailController = TextEditingController();
  final userAddressController = TextEditingController();
  final userPasswordController = TextEditingController();
  final userConfirmPasswordController = TextEditingController();

  Future<void> register(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final formData = {
        'name': userNameController.text.trim(),
        'phone_number': userPhoneController.text.trim(),
        'email': userEmailController.text.trim(),
        'address': userAddressController.text.trim(),
        'password': userPasswordController.text.trim(),
        'password_confirmation': userConfirmPasswordController.text.trim(),
      };

      final dio = Dio();
      final response = await dio.request(
        '${Constants.baseUrl}auth/register',
        options: Options(
          method: 'POST',
          headers: {'Accept': 'application/json'},
        ),
        queryParameters: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true) {
          Utils.showSnackBar(
            context,
            data['message']?.toString() ?? 'Registration successful!',
          );

          AppRoutes.pushReplacement(LoginView());

          userNameController.clear();
          userPhoneController.clear();
          userEmailController.clear();
          userAddressController.clear();
          userPasswordController.clear();
          userConfirmPasswordController.clear();
        } else {
          Utils.showSnackBar(
            context,
            data['message']?.toString() ??
                'Registration failed. Please try again',
          );
        }
        log('Registration successful: $data');
      }
    } on DioException catch (e) {
      log('Dio error during registration: ${e.response?.data}');

      final responseData = e.response?.data;

      if (responseData != null && responseData['error'] != null) {
        final errors = responseData['error'];

        String errorMessage = '';

        if (errors['name'] != null &&
            errors['name'] is List &&
            errors['name'].isNotEmpty) {
          errorMessage = errors['name'][0].toString();
        } else if (errors['phone_number'] != null &&
            errors['phone_number'] is List &&
            errors['phone_number'].isNotEmpty) {
          errorMessage = errors['phone_number'][0].toString();
        } else if (errors['email'] != null &&
            errors['email'] is List &&
            errors['email'].isNotEmpty) {
          errorMessage = errors['email'][0].toString();
        } else if (errors['address'] != null &&
            errors['address'] is List &&
            errors['address'].isNotEmpty) {
          errorMessage = errors['address'][0].toString();
        } else if (errors['password'] != null &&
            errors['password'] is List &&
            errors['password'].isNotEmpty) {
          errorMessage = errors['password'][0].toString();
        } else if (errors['password_confirmation'] != null &&
            errors['password_confirmation'] is List &&
            errors['password_confirmation'].isNotEmpty) {
          errorMessage = errors['password_confirmation'][0].toString();
        }

        if (errorMessage.isNotEmpty) {
          Utils.showSnackBar(context, errorMessage);
        } else {
          Utils.showSnackBar(
            context,
            'Registration failed. Please check your input',
          );
        }
      } else {
        Utils.showSnackBar(context, 'Registration failed. Please try again');
      }
    } catch (e) {
      log('Unexpected error during registration: $e');
      Utils.showSnackBar(
        context,
        'An unexpected error occurred. Please try again',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================================================ Login =================================================================

  final emailPhoneController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final sp = await SharedPreferences.getInstance();

      final formData = {
        'login': emailPhoneController.text.trim(),
        'password': passwordController.text.trim(),
      };

      final dio = Dio();
      final response = await dio.request(
        '${Constants.baseUrl}auth/login',
        options: Options(
          method: 'POST',
          headers: {'Accept': 'application/json'},
        ),
        queryParameters: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true) {
          Utils.showSnackBar(
            context,
            data['message']?.toString() ?? 'Login successful!',
          );

          await sp.setString('token', data['data']['token']);
          Constants.token = sp.getString('token') ?? '';

          await getProfile(context, Constants.token);

          AppRoutes.pushAndRemoveAll(HomeView());

          emailPhoneController.clear();
          passwordController.clear();
        } else {
          Utils.showSnackBar(
            context,
            data['message']?.toString() ?? 'Login failed. Please try again',
          );
        }
        log('Login successful: $data');
      }
    } on DioException catch (e) {
      log('Dio error during login: ${e.response?.data}');

      final responseData = e.response?.data;

      if (responseData != null && responseData['error'] != null) {
        String errorMessage = responseData['error'];

        if (errorMessage.isNotEmpty) {
          Utils.showSnackBar(context, errorMessage);
        } else {
          Utils.showSnackBar(
            context,
            'Login failed. Please check your credentials',
          );
        }
      } else if (responseData != null && responseData['message'] != null) {
        Utils.showSnackBar(context, responseData['message'].toString());
      } else {
        Utils.showSnackBar(context, 'Invalid credentials. Please try again');
      }
    } catch (e) {
      log('Unexpected error during login: $e');
      Utils.showSnackBar(
        context,
        'An unexpected error occurred. Please try again',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================================================ Profile =================================================================

  UserProfileModel? userProfile;

  Future<void> getProfile(BuildContext context, String token) async {
    try {
      isLoading = true;
      notifyListeners();

      log('Token: $token');

      final dio = Dio();

      final response = await dio.get(
        '${Constants.baseUrl}auth/user',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        userProfile = UserProfileModel.fromJson(data);

        if (userProfile!.success == true) {
          Constants.currentUser = userProfile!.data.user;

          log('Profile fetched successfully: ${Constants.currentUser}');
        } else {
          log('Failed to fetch profile');
          Utils.showSnackBar(context, 'Failed to fetch profile');
        }
      }
    } on DioException catch (e) {
      log('Dio error during profile fetch: ${e.response?.data ?? e.message}');
      Utils.showSnackBar(context, 'Network error while fetching profile');
    } catch (e) {
      log('Unexpected error during profile fetch: $e');
      Utils.showSnackBar(context, 'Something went wrong');
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
    userNameController.dispose();
    userPhoneController.dispose();
    userEmailController.dispose();
    userAddressController.dispose();
    userPasswordController.dispose();
    userConfirmPasswordController.dispose();
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

      (controller ?? userAddressController).text = cleanAddress;
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

      if (!context.mounted) return;
      loadingDialog(context);

      final token = sp.getString('token') ?? '';

      final dio = Dio();

      final response = await dio.post(
        '${Constants.baseUrl}auth/logout',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint("Logout API success: ${response.data}");

        await sp.remove('token');
        Constants.token = '';
        Constants.currentUser = null;

        await Phoenix.rebirth(context);

        debugPrint('User credentials cleared from SharedPreferences.');

        if (!context.mounted) return;
        AppRoutes.pushAndRemoveAll(const SplashView());
      } else {
        throw Exception(response.statusMessage ?? "Logout failed");
      }
    } catch (e) {
      debugPrint('Logout error: $e');

      if (context.mounted) {
        Utils.showSnackBar(context, "Logout failed: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
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
            color: Colors.white,
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
