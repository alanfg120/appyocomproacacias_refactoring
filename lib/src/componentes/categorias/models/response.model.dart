import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/categoria.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';

class ResponseCategorias extends ResponseHttp {
  
  final List<Categoria>? categorias;
  final List<Empresa>?  empresas;
  ResponseCategorias({this.categorias,this.empresas});
}
