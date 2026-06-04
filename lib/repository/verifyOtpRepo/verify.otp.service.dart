import 'package:dio/dio.dart';
import 'package:pmjay/remote/network/api.end.points.dart';
import 'package:pmjay/remote/network/dio.client.dart';


class VerifYOTPService {
  final dioClient = DioClient();

  Future<Response> verifyOTP(String preAuthToken, String otp) async {
    return await dioClient.post(
      ApiEndPoints.verifyOTPEndPoint,
      headers: {
        "accept": "text/plain",
        "Content-Type": "application/json",
      },
      data: {
        "preAuthToken": preAuthToken,
        "otp": otp,
      },
    );
  }
}
