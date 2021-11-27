import 'package:appyocomproacacias_refactoring/src/componentes/login/models/login_user.model.dart';

class ResponseSocialAuth {

final bool error;
final LoginUsuario? usuario;

ResponseSocialAuth({this.error = false,this.usuario});

}