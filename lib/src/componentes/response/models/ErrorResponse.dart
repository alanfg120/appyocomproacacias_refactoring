import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';

class ErrorResponse  extends ResponseHttp{
  final Object error;

  ErrorResponse(this.error);
}