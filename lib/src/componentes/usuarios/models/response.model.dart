import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';

class UsuarioResponse extends ResponseHttp {
  final bool? update;
  final bool? sendReporte;

  UsuarioResponse({this.update,this.sendReporte});
}