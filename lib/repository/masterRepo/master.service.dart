import 'package:pmjay/remote/network/api.end.points.dart';
import 'package:pmjay/remote/network/dio.client.dart';

class MasterService {
  final dioClient = DioClient();

  Future<dynamic> master(
      String token, {
        int pageNumber = 1,
        int pageSize = 500,
      }) async {
    return await dioClient.get(
      ApiEndPoints.masterAPIEndPoint,
      headers: {
        "accept": "text/plain",
        "Authorization": "Bearer $token",
      },
      queryParams: {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      },
    );
  }
}