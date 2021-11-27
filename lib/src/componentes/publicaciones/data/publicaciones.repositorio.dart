import 'dart:convert';

import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:dio/dio.dart';

class PublicacionesRepositorio {
  Dio _dio = DioHttp().dio;

  Future<ResponseHttp> getPublicacionesByEmpresa(
      int idEmpresa, int idUsuario) async {
    try {
      final response = await _dio.get('/publicaciones/empresa/$idEmpresa',
          queryParameters: {'id': idUsuario});
      final publicaciones =
          response.data.map<Publicacion>((e) => Publicacion.toJson(e)).toList();
      return ResponsePublicaciones(publicaciones: publicaciones);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp?> addPublicacion(
      Publicacion publicacion, List<ImageFile> imagenes,
      {Function(double)? onProgress}) async {
    FormData data = FormData.fromMap({...publicacion.toMap()});
    imagenes.forEach((imagen) async {
      data.files.add(MapEntry(
        imagen.nombre,
        MultipartFile.fromFileSync(imagen.file!.path, filename: imagen.nombre),
      ));
    });
    try {
      final response = await _dio.post(
        '/publicaciones/add',
        data: data,
        onSendProgress: (int received, int total) {
          final progress = (received / total);
          onProgress?.call(progress);
        },
      );
      if (response.statusCode == 200)
        return ResponsePublicaciones(idNewPublicacion: response.data);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> updatePublicacion(
      Publicacion publicacion, List<ImageFile> imagenes,
      {Function(double)? onProgress}) async {
    FormData data = FormData.fromMap({...publicacion.toMap()});
    imagenes.forEach((imagen) async {
      if (imagen.isaFile)
        data.files.add(MapEntry(
          imagen.nombre,
          MultipartFile.fromFileSync(imagen.file!.path,
              filename: imagen.nombre),
        ));
    });
    try {
      final response = await _dio.put(
        '/publicaciones/update',
        data: data,
        onSendProgress: (int received, int total) {
          final progress = (received / total);
          onProgress?.call(progress);
        },
      );
      return ResponsePublicaciones(update: response.data['update']);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> getPublicaciones(int page, int id) async {
    try {
      final response = await _dio
          .get('/publicaciones', queryParameters: {'page': page, 'id': id});
      final publicaciones = response.data
          .map<Publicacion>((publicacion) => Publicacion.toJson(publicacion))
          .toList();
      return ResponsePublicaciones(publicaciones: publicaciones);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> meGustaPublicacion(
      int idPublicacion, int idUsuario, int idUsuarioDestinatario) async {
    try {
      final data = jsonEncode({
        'id_usuario': idUsuario,
        'id_publicacion': idPublicacion,
        "id_usuario_destinatario": idUsuarioDestinatario
      });
      final response = await _dio.post('/likes/add', data: data);
      return ResponsePublicaciones(like: response.data);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> noMeGustaPublicacion(
      int idPublicacion, int idUsuario) async {
    try {
      final data = jsonEncode({
        'id_usuario': idUsuario,
        'id_publicacion': idPublicacion,
      });
      final response = await _dio.delete('/likes/delete', data: data);
      return ResponsePublicaciones(like: response.data);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> comentarPublicacion(String comentario, int idPublicacion,
      int idUsuario, int idDestinatario) async {
    try {
      final data = jsonEncode({
        'comentario': comentario,
        'id_publicacion': idPublicacion,
        'id_usuario': idUsuario,
        'id_usuario_destinatario': idDestinatario
      });
      final response = await _dio.post('/comentarios/add', data: data);
      return ResponsePublicaciones(comento: response.data['add']);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> deletePublicacion(int idPublicacion) async {
    try {
      final response = await _dio.delete('/publicaciones/$idPublicacion');
      return ResponsePublicaciones(delete: response.data['delete']);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> getPublicacionById(int idPublicacion) async {
    try {
      final response = await _dio.get('/publicaciones/$idPublicacion');
      final publicacion = Publicacion.toJson(response.data);
      return ResponsePublicaciones(publicacion: publicacion);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  /* Future<ResponseModel> getPublicacionById(int idPublicacion) async {
    try {
      final response = await _dio
          .get('/publicaciones/$idPublicacion');
      final publicacion =  Publicacion.toJson(response.data);
      return  ResponsePublicacion(publicacion: publicacion);
    } catch (error) {
      return  ErrorResponse(error);
    }
  }

  Future meGustaPublicacion(
      int idPublicacion, int idUsuario, int idUsuarioDestinatario) async {
    final data = jsonEncode({
      'id_usuario': idUsuario,
      'id_publicacion': idPublicacion,
      "id_usuario_destinatario": idUsuarioDestinatario
    });
    final response = await _dio.post('/likes/add', data: data);
    return response.data;
  }

  Future noMeGustaPublicacion(int idPublicacion, int idUsuario) async {
    final data = jsonEncode({
      'id_usuario': idUsuario,
      'id_publicacion': idPublicacion,
    });
    final response = await _dio.delete('/likes/delete', data: data);
    return response.data;
  }

  Future comentarPublicacion(
      String comentario, int idPublicacion, int idUsuario,int idDestinatario) async {
    final data = jsonEncode({
      'comentario': comentario,
      'id_publicacion': idPublicacion,
      'id_usuario': idUsuario,
      'id_usuario_destinatario':idDestinatario
    });
    try {
      final response = await _dio.post('/comentarios/add', data: data);
      return response.data;
    } on DioError catch (error) {
      return error.response.data;
    }
  }

  Future<List<Publicacion>> getPublicacionesByEmpresa(
      int idEmpresa, int idUsuario) async {
    await new Future.delayed(new Duration(milliseconds: 500));
    final response = await _dio.get('/publicaciones/empresa/$idEmpresa',
        queryParameters: {'id': idUsuario});
    final publicaciones = response.data;
    return publicaciones
        .map<Publicacion>((e) => Publicacion.toJson(e))
        .toList();
  }

  Future<ResponseModel> addPublicacion(
      Publicacion publicacion, List<ImageFile> imagenes) async {
    FormData data = FormData.fromMap({...publicacion.toMap()});
    imagenes.forEach((imagen) async {
      data.files.add(MapEntry(
        imagen.nombre,
        MultipartFile.fromFileSync(imagen.file.path, filename: imagen.nombre),
      ));
    });
    try {
      final response = await _dio.post('/publicaciones/add', data: data);
      return ResponsePublicacion(id: response.data);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> updatePublicacion(
      Publicacion publicacion, List<ImageFile> imagenes) async {
    FormData data = FormData.fromMap({...publicacion.toMap()});
    imagenes.forEach((imagen) async {
      if (imagen.isaFile)
        data.files.add(MapEntry(
          imagen.nombre,
          MultipartFile.fromFileSync(imagen.file.path, filename: imagen.nombre),
        ));
    });
    try {
      final response = await _dio.put('/publicaciones/update', data: data);
      return ResponsePublicacion(update: response.data['update']);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> deletePublicacion(int idPublicacion) async {
    try {
      final response = await _dio.delete('/publicaciones/$idPublicacion');
      return ResponsePublicacion(delete: response.data['delete']);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  } */
}
