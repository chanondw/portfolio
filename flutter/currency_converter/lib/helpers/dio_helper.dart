import 'package:dio/dio.dart';

class DioHelper {
  Dio getDio() {
    final dio = Dio(BaseOptions(
        baseUrl: "http://api.exchangeratesapi.io/v1",
        queryParameters: {"access_key": "9bcfaa4351be307324d28a1ecceb30e9"}));

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}
