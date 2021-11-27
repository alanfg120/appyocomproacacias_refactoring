import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/categoria.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:dio/dio.dart';

class CategoriaRepositorio {
  Dio _dio = DioHttp().dio;

  Future<ResponseHttp> getEmpresasByCategoria(
      String categoria, int page) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      final response = await _dio.get('/empresas/categoria/$categoria',
          queryParameters: {'page': page});
      final empresas = response.data
          ?.map<Empresa>((empresa) => Empresa.toJson(empresa))
          ?.toList();
      return ResponseCategorias(empresas: empresas);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> getCategorias() async {
    try {
      final response = await _dio.get('/categorias');
      final categorias = response.data
          ?.map<Categoria>((categoria) => Categoria.toJson(categoria))
          ?.toList();
      return ResponseCategorias(categorias: categorias);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> buscarEmpresasPorCategoria(
      String categoria, String texto) async {
    try {
      final response = await _dio.get('/categorias/search/$categoria/$texto');
      final empresas = response.data
          .map<Empresa>((empresa) => Empresa.toJson(empresa))
          .toList();
      return ResponseCategorias(empresas: empresas);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }
}
