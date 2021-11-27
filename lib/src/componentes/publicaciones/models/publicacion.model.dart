import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/cometario.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/like.model.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Publicacion extends Equatable {

  final int?                   id;
  final String                fecha;
  final String                 texto;
  final Empresa                empresa;
  final List<Comentario>      comentarios;
  final List<String>           imagenes;
  final List<LikePublicacion> usuariosLike;
  final bool                   megusta,editar;

  Publicacion( 
      {this.id,
      required this.texto,
      required this.fecha,
      required this.empresa,
      required this.imagenes,
      required this.comentarios, 
      required this.usuariosLike,
      required this.megusta,
      required this.editar});

      

factory Publicacion.toJson(Map<String,dynamic> json)
   =>Publicacion(
     id                : json['id'] ?? 0,
     texto             : json['texto'] ?? '',
     imagenes          : json['imagenes'].map<String>((imagen)=>'${imagen['nombre']}').toList() ?? '',
     fecha             : json['fecha'] ?? '',
     megusta           : json['megusta'] ?? false,
     editar            : json['edit'] ?? false,
     empresa           : Empresa?.toJson(json['empresa']),
     comentarios       : json['data_comentarios']?.map<Comentario>((comentario)=> Comentario.toJson(comentario))?.toList() ?? [],
     usuariosLike      : json["likes_usuarios"]?.map<LikePublicacion>((like)=> LikePublicacion.toJson(like))?.toList() ?? []
   );

   String formatFecha() => DateFormat("dd MMMM 'del' yyyy  h:mm a")
                          .format(DateTime.parse(this.fecha));
  
   Publicacion copyWith(
     {int? id, 
      int? likes, 
      int? numeroComentarios,
      String?  texto, 
      String? fecha,
      Empresa? empresa,
      List<Comentario>? comentarios,
      List<String>? imagenes,
      List<LikePublicacion>? usuariosLike,
      bool? megusta,
      bool? editar
     }
   ) => Publicacion(
        id                : id                ?? this.id,
        texto             : texto             ?? this.texto,
        fecha             : fecha             ?? this.fecha,
        empresa           : empresa           ?? this.empresa,
        comentarios       : comentarios       ?? this.comentarios,
        imagenes          : imagenes          ?? this.imagenes,
        usuariosLike      : usuariosLike      ?? this.usuariosLike,
        megusta           : megusta           ?? this.megusta,
        editar            : editar            ?? this.editar
    );

 Map<String,dynamic> toMap() => {
  "id"          : id ?? null,
  "texto"       : texto,
  "fecha"       : fecha,
  "id_empresa"  : empresa.id
 };

  @override
  List<Object?> get props => [
      id, 
      texto, 
      fecha,
      empresa,
      comentarios,
      imagenes,
      usuariosLike,
      megusta,
      editar
  ];
}
        