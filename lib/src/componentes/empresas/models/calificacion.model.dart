import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:equatable/equatable.dart';

class Calificacion extends Equatable {
  final Usuario? usuario;
  final int extrellas;
  final String comentario;

  Calificacion(
      {this.usuario,
      required this.extrellas,
      required this.comentario});

  factory Calificacion.toJson(Map<String, dynamic>? json) => Calificacion(
      usuario    : json!['usuario'] != null
                   ? Usuario.toJson(json['usuario'])
                   : null,
      extrellas  : json['extrellas'] ?? 0,
      comentario : json['comentario'] ?? ''
  );

  Calificacion copyWith({
    int? idEmpresa,
    Usuario? usuario,
    int? extrellas,
    String? comentario,
  }) =>
      Calificacion(
          usuario    : usuario    ?? this.usuario,
          extrellas  : extrellas  ?? this.extrellas,
          comentario : comentario ?? this.comentario);

  @override
  List<Object?> get props => [usuario, extrellas, comentario];
}
