import 'dart:convert';

import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:dio/dio.dart';

class UsuarioRepocitorio {
  final _dio = DioHttp().dio;

  Future<ResponseHttp> updateImagen(String path, int idUsuario) async {
    FormData data = FormData.fromMap({
      "id_usuario": idUsuario,
      "file": await MultipartFile.fromFile(path, filename: "imagen.jpg")
    });
    try {
      final response = await _dio.put('/usuarios/update/image', data: data);
      return UsuarioResponse(update: response.data['update']);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> updatePassword(
      int idUsuario,String currentPassword, String newPassword) async {
    final update = {"password": newPassword};
    final data = jsonEncode({
      "update"          : update,
      "id"              : idUsuario,
      "currentPassword" : currentPassword
    });
    try {
      final response = await this._dio.put('/usuarios/update', data: data);
      return UsuarioResponse(update: response.data['update']);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> updateData(
      int idUsuario,Map<String,dynamic> update) async {
    final data = jsonEncode({
      "update"          : update,
      "id"              : idUsuario,
    });
    try {
      final response = await this._dio.put('/usuarios/update', data: data);
      return UsuarioResponse(update: response.data['update']);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> sendReporte(int idUsuario,int motivo,String detalle) async {
    final data = jsonEncode(
      {"id_usuario": idUsuario, "motivo": motivo, "detalles": detalle}
    );
    try {
      final response = await this._dio.post('/reportes/add', data: data);
      return UsuarioResponse(sendReporte: response.data['reporte']);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  /* Future<ResponseModel> updateUsuario(int id, Map<String, dynamic> update,
      [String currentPassword, String token]) async {
    this._verificarToken(token);
    String data;
    if (currentPassword == null)
      data = jsonEncode({"update": update, "id": id});
    else
      data = jsonEncode(
          {"update": update, "id": id, "currentPassword": currentPassword});
    try {
      final response = await this._dio.put('/usuarios/update', data: data);
      return UsuarioResponse.toJson(response.data);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }
  Future<ResponseModel> sendReporte(Reporte reporte) async {
    final data = jsonEncode(
     reporte.toMap()
    );
    try {
      final response = await this._dio.post('/reportes/add', data: data);
      return UsuarioResponse.toJson(response.data);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  

  void _verificarToken(String token) {
    if (!GetStorage().hasData('token') && !token.isNullOrBlank) 
      this._dio.options.headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token'
    };
  } */
}
