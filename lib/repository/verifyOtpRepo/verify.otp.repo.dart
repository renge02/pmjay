import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmjay/repository/verifyOtpRepo/verify.otp.service.dart';

import '../../utils/logger.dart';
import '../../utils/secure.storage.dart';


class VerifyOTPProvider extends ChangeNotifier {
  final VerifYOTPService _service = VerifYOTPService();

  bool isLoading = false;
  String? error;
  dynamic data;

  Future<void> verifyOTP(String preAuthToken, String otp) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.verifyOTP(preAuthToken, otp);

      data = response.data;
      logger("Verify OTP Response: ${jsonEncode(data)}");
      // check if data is valid save in local storage
      // await SecureStorage().saveToken(data['preAuthToken']);
      // await SecureStorage().saveRefreshToken(data['refresh_token']);
      // await SecureStorage().saveUserData(jsonEncode(data['UserRequest']));
    }on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        error = "Bad Request";
        break;

      case 401:
        error = "Invalid username or password";
        break;

      case 403:
        error = "Access denied";
        break;

      case 404:
        error = "API not found";
        break;

      case 415:
        error = "Unsupported Media Type";
        break;

      case 422:
        error = e.response?.data['message'] ??
            "Validation failed";
        break;

      case 500:
        error = e.response?.data?['message'] ??"Internal Server Error";
        break;
      case 503:
        error = e.response?.data?['message'] ??"Service Unavailable";
        break;
      default:
        error = e.response?.data?['message'] ??
            e.message ??
            "Something went wrong";
    }

    logger(
      "Status Code: ${e.response?.statusCode}",
    );
    logger(
      "Response: ${e.response?.data}",
    );
  }

}


