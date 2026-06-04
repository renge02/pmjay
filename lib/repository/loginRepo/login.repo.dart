import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';
import '../../utils/secure.storage.dart';
import 'login.service.dart';

class LoginProvider extends ChangeNotifier {
  final LoginService _service = LoginService();

  bool isLoading = false;
  String? error;
  dynamic data;

  Future<void> login(String userName, String password) async {
    try {
      isLoading = true;
      error = null;
      data = null;
      notifyListeners();

      final response = await _service.login(userName, password);

      if (response.statusCode == 200) {
        data = response.data;

        logger("Login Response: ${jsonEncode(data)}");

          logger("Login Response: ${data['preAuthToken']}");
        if(data['data']?["requiresOtp"]==false){
          await SecureStorage().saveAccessToken(
            data['data']?['accessToken'],          );
        }else{
          await SecureStorage().saveToken(
            data['data']?['preAuthToken'],          );
        }


        }

    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      error = e.toString();
      logger("Unexpected Error: $error");
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