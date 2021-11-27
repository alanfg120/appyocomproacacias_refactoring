import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';

class ResponsePublicaciones extends ResponseHttp {

  final List<Publicacion>? publicaciones;
  final bool? like, comento,delete,update;
  final int? idNewPublicacion;
  final Publicacion? publicacion;

  ResponsePublicaciones(
      {this.publicaciones, 
       this.like, 
       this.comento,
       this.delete, 
       this.update,
       this.idNewPublicacion,
       this.publicacion});
}
