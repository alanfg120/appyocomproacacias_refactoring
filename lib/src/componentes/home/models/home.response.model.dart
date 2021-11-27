import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';

class HomeResponseHttp extends ResponseHttp {
 final Usuario? usuario;
 final String? token;
 HomeResponseHttp({this.usuario,this.token});
}