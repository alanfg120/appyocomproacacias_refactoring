import 'package:equatable/equatable.dart';

class LoginUsuario extends Equatable {

  final String? password;
  final String socialId;
  final String usuario;
  final String nombre;
  final String? cedula;

  LoginUsuario(
      {
       required this.nombre,
       required this.usuario,
       this.cedula,
       this.password,
       required this.socialId
       });
     

  @override
  List<Object?> get props => [
    nombre,
    cedula,
    usuario,
    password,
    socialId
  ];
}
