import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/videos.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';

class InicioResponse extends ResponseHttp {
  final List<YouTubeVideoView>? videos;
  final List<Empresa>? empresas;
  final List<Notificacion>? notificaciones;

  InicioResponse({this.videos,this.empresas,this.notificaciones});
}