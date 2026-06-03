// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:paani/core/extensions/routes.dart';
import 'package:paani/ui/view/dashboard/dashboard_view.dart';
import 'package:paani/ui/view/splash_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> login(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final formData = {
        'tag': 'login',
        'email': emailPhoneController.text.trim(),
        'password': '1234',
      };

      final dio = Dio();

      final response = await dio.post(
        '${Constants.baseUrl}login_api_cspmobile_cust.php',
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

  // ==================================================================> Dispose

  @override
  void dispose() {
    emailPhoneController.dispose();
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
