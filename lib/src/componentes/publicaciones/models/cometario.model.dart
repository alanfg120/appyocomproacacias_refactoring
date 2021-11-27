import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Comentario extends Equatable{

  final int?    id;
  final String  comentario,fecha;
  final Usuario usuario;

  Comentario(
      {this.id,
       required this.comentario,
       required this.usuario,
       required this.fecha});

  factory Comentario.toJson(Map<String,dynamic> json)
          => Comentario(
             id            : json['id']         ?? 0,
             comentario    : json['comentario'] ?? '',
             fecha         : json['fecha']      ?? '',
             usuario       : Usuario?.toJson(json['usuario']) 
          );
    String formatFecha() => DateFormat("dd MMMM 'del' yyyy  h:mm a")
                          .format(DateTime.parse(this.fecha));

  @override
  List<Object?> get props => [
       id,
       comentario,
       usuario,
       fecha
  ];
}
