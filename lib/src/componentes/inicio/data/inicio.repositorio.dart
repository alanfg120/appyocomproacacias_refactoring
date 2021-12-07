import 'dart:convert';

import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/inicioReesponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/videos.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class InicioRepositorio {

  final _dio = DioHttp().dio;

  Future<ResponseHttp> getVideosYoutbe() async {
    Map<String, dynamic> options = {
      'channelId': 'UCAPP8tro1pewJCHQ2zCkcuA',
      "part": "snippet",
      'order': 'date',
      "maxResults": "10",
      "key": "AIzaSyAmvIdl1EiTbeVgC5ulmnIij47jES4kL7E",
    };
    final headers = {"Accept": "application/json"};
    Uri url = new Uri.https("www.googleapis.com", "youtube/v3/search", options);
    var res = await http.get(url, headers: headers);
    var jsonData = json.decode(res.body);
    final videos = jsonData['items'].map<YouTubeVideoView>((data) {
      return YouTubeVideoView(
          fecha: data['snippet']['publishedAt'],
          url: "https://www.youtube.com/watch?v=${data['id']['videoId']}",
          urlImagen: data['snippet']['thumbnails']['high']['url']
      );
    }).toList();
    return InicioResponse(videos: videos);
  }

  Future<ResponseHttp> getTop10Empresas() async {
    try {
      final response = await _dio.get('/empresas/top');
      final empresas = response.data
          .map<Empresa>((empresa) => Empresa.toJson(empresa))
          .toList();
      return InicioResponse(empresas: empresas);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> getNotificaciones(int idUsuario) async {
    try {
      final response = await _dio.get('/notificaciones/$idUsuario');
      final notificaciones = response.data
          .map<Notificacion>(
              (notificacion) => Notificacion.toJson(notificacion))
          .toList();
      return InicioResponse(notificaciones: notificaciones);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }
 
  Future<ResponseHttp> leerNotificacion(int idNotificacion) async {
    try {
      final response = await _dio.put('/notificaciones/leida',
          data: {"id_notificacion": idNotificacion});
      return InicioResponse(leida: response.data['leida']);
    }on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

 Future<ResponseHttp> registrarTokenPush(token, idUsuario) async {
    FormData data = FormData.fromMap({"id_usuario": idUsuario, "token": token});
    try {
      final response = await _dio.put('/usuarios/add/token', data: data);
      return InicioResponse(registroToken: response.data);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

}
