import 'dart:io';

import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:dio/dio.dart';


class ErrorResponseHttp  extends ResponseHttp{
  
  final DioError error;
  ErrorResponseHttp(this.error);

  String get getError {
   if(error.error is SocketException)
      return this.error.error.osError.message;
   return error.response!.data['error'];
  }

  factory ErrorResponseHttp.toJson(Map<String,dynamic> json)
    => ErrorResponseHttp(json['error']);
}
