import 'package:appyocomproacacias_refactoring/src/componentes/home/models/home.response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:dio/dio.dart';

class HomeRepocitorio {
  final _dio = DioHttp().dio;

  Future<ResponseHttp> getUsuario(int idUsuario) async {
    try {
      final response = await _dio.get('/usuarios/$idUsuario');
      final usuario = Usuario.toJson(response.data);
      return HomeResponseHttp(usuario: usuario);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }
  Future<ResponseHttp> getTokenAnonimo  () async {
    try {
      final response  = await _dio.get('/usuarios/anonimo/token');
      return HomeResponseHttp(token: response.            data);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  
/*   Future<ResponseModel> updateImagen(String path, int idUsuario) async {
    FormData data = FormData.fromMap({
      "id_usuario": idUsuario,
      "file": await MultipartFile.fromFile(path, filename: "imagen.jpg")
    });
    try {
      final response = await _dio.put('/usuarios/update/image', data: data);
      return HomeResponse(update: response.data['update']);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> registroActividad(int idUsuario) async {
    try {
      await _dio.post('/ingresos/add', data: {"id_usuario": idUsuario});
      return HomeResponse(addIngreso: true);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> leerNotificacion(int idNotificacion) async {
    try {
      final response = await _dio.put('/notificaciones/leida',
          data: {"id_notificacion": idNotificacion});
      return ResponseHome(notificacionLeida: response.data['leida']);
    } catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> getVideosYoutbe() async {
    List<YT_API> result = [];
    final String tokenYoutube = 'AIzaSyAmvIdl1EiTbeVgC5ulmnIij47jES4kL7E';
    YoutubeAPI ytApi = YoutubeAPI(tokenYoutube);
    try {
      result = await ytApi.channel('UCAPP8tro1pewJCHQ2zCkcuA');
      final videos = result
          .map((video) => YouTubeVideo(
              url: video.url,
              urlImagen: video.thumbnail['high']['url'],
              fecha: video.publishedAt))
          .toList();
      return HomeResponse(videos: videos);
    } catch (error) {
      print(error);
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> getTop10Empresas() async {
    try {
      final response = await _dio.get('/empresas/top');
      final empresas = response.data
          .map<Empresa>((empresa) => Empresa.toJson(empresa))
          .toList();
      return ResponseEmpresa(empresas: empresas);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> registrarTokenPush(token, idUsuario) async {
    FormData data = FormData.fromMap({"id_usuario": idUsuario, "token": token});
    try {
      final response = await _dio.put('/usuarios/add/token', data: data);
      return ResponseHome(registrarToken: response.data);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> getTokenAnonimo() async {
    try {
      final response = await _dio.get('/usuarios/anonimo/token');
      return ResponseHome(tokenAnonimo: response.data);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> getNotificaciones(int idUsuario) async {
    try {
      final response = await _dio.get('/notificaciones/$idUsuario');
      final notificaciones = response.data
          .map<Notificacion>(
              (notificacion) => Notificacion.toJson(notificacion))
          .toList();
      return ResponseHome(notificaciones: notificaciones);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  } */
}
