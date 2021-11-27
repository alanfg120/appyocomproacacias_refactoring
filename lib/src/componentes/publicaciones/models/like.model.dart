import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class LikePublicacion  extends Equatable{
  
  final String  fecha;
  final Usuario usuario;

  LikePublicacion({required this.fecha, required this.usuario});

  factory LikePublicacion.toJson(Map<String,dynamic> json)
      =>   LikePublicacion(
           fecha   : json['fecha'],
           usuario : Usuario.toJson(json['usuario'])
         );

  String formatFecha() => DateFormat("dd MMMM 'del' yyyy  h:mm a")
                          .format(DateTime.parse(this.fecha));

  @override
  List<Object?> get props => [
        fecha, 
        usuario
  ];
}
