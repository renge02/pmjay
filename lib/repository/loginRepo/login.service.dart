import 'package:dio/dio.dart';
import 'package:pmjay/remote/network/api.end.points.dart';
import 'package:pmjay/remote/network/dio.client.dart';


class LoginService {
  final dioClient = DioClient();

  Future<Response> login(String userName, String password) async {
    return await dioClient.post(
      ApiEndPoints.authEndPoint,
      headers: {
        "accept": "text/plain",
        "Content-Type": "application/json",
      },
      data: {
        "username": userName,
        "password": password,
      },
    );
  }
}
