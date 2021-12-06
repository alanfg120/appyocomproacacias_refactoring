import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/models/pedido.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:dio/dio.dart';

class PedidoRepocitorio {

   final _dio = DioHttp().dio;

   Future<ResponseHttp> addPedido(Pedido pedido) async {
    try {
      final response = await this._dio.post('/pedidos/add',data: {...pedido.toMap()});
      return ResponsePedido(addPedido: response.data);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  } 
}