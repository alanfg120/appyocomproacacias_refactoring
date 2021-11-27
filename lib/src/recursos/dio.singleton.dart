import 'dart:io';
import 'package:dio/dio.dart';

class DioHttp {

  final Dio dio;

  static final DioHttp _instancia = new DioHttp._internal(Dio());

  factory DioHttp() {
    return _instancia;
  }

  initDio(String url, String token) {
    dio.options.baseUrl = url;
    dio.options.contentType = Headers.jsonContentType;
    if(token.isNotEmpty)
    dio.options.headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
  }

  setToken(String token){
    dio.options.headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
  }

  DioHttp._internal(this.dio);
}
