

import 'dart:convert';
import 'dart:io';

import 'package:appyocomproacacias_refactoring/src/componentes/login/models/dataRecovery.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/models/login.response.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:dio/dio.dart';

class LoginRepositorio {
  final _dio = DioHttp().dio;

  Future<ResponseHttp> login(String correo, String password,[String? socialId]) async {
    try {
      final response = await this
          ._dio
          .post('/usuarios/login', data: {"usuario": correo, "password": password,"social_id": socialId});
      return LoginResponseHttp.toJson(response.data);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

Future<ResponseHttp> addUsuario(Map<String, dynamic> usuario) async {
     FormData formData = new FormData.fromMap(usuario);
     try {
     final response = await this._dio.post('/usuarios/add',data:formData);
      return LoginResponseHttp.toJson(response.data); 
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }
Future<ResponseHttp> sendEmailRecovery(String email) async {
     FormData formData = new FormData.fromMap({
       "email" : email
     });
     try {
     final response = await this._dio.post('/usuarios/get/codigo_recuperacion',data:formData);
      return LoginResponseHttp.toJson(response.data); 
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
}
Future<ResponseHttp> changePassword(DataRecoveryPassword dataRecovery,String password) async {
     final update = {"password": password};
     final data = jsonEncode({"update": update,"id":dataRecovery.idUsuario});
     try {
     final response = await this._dio.put('/usuarios/update',data:data,options: Options(
       headers: {HttpHeaders.authorizationHeader: 'Bearer ${dataRecovery.token}'}
     ));
      return LoginResponseHttp(updatePassword: response.data['update']);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
}
}
