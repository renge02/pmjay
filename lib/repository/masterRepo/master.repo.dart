import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmjay/database/database_helper.dart';
import 'package:pmjay/models/masterModel/master.model.dart';
import 'package:pmjay/repository/masterRepo/master.service.dart';
import '../../utils/logger.dart';

class MasterProvider extends ChangeNotifier {
  final MasterService _service = MasterService();

  bool isLoading = false;
  String? error;
  dynamic data;

  Future<void> masterAPI(String token, int pageNumber, int pageSize) async {
    try {
      isLoading = true;
      error = null;
      data = null;
      notifyListeners();

      final response = await _service.master(
        token,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (response.statusCode == 200) {
        data = response.data;

        logger("Login Response: ${jsonEncode(data)}");
        if (response.data['success'] == true) {
          final beneficiaries =
          (response.data['data']['beneficiaries'] as List)
              .map((e) => Beneficiary.fromJson(e))
              .toList();

          await DatabaseHelper.instance
              .insertBeneficiaries(beneficiaries);
        }
        notifyListeners();
        // logger("Login Response: ${data['preAuthToken']}");
        return response.data;
      //  await SecureStorage().saveToken(data['data']?['preAuthToken']);
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
        error = e.response?.data['message'] ?? "Validation failed";
        break;

      case 500:
        error = e.response?.data?['message'] ?? "Internal Server Error";
        break;
      case 503:
        error = e.response?.data?['message'] ?? "Service Unavailable";
        break;
      default:
        error =
            e.response?.data?['message'] ?? e.message ?? "Something went wrong";
    }

    logger("Status Code: ${e.response?.statusCode}");
    logger("Response: ${e.response?.data}");
  }
}
