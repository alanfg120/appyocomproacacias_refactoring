import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';

class LoginResponseHttp extends ResponseHttp {

  final Usuario? usuario;
  final String? token;
  final int? idUsuario;
  final String? codigoRecuperacion;
  final bool? updatePassword;
  LoginResponseHttp({
     this.usuario,
     this.token,
     this.idUsuario,
     this.updatePassword,
     this.codigoRecuperacion});

  factory LoginResponseHttp.toJson(Map<String, dynamic> json)
      => LoginResponseHttp(
         usuario            : json['usuario'] != null ? Usuario.toJson(json['usuario']) : null,
         token              : json['token'] ?? '',
         codigoRecuperacion : json['codigo_recuperacion'] ?? '',
         idUsuario          : json['id'] ?? 0 
        ); 
}