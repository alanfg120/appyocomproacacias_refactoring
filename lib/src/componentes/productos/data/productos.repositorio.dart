
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/categoriaProducto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:dio/dio.dart';



class ProductosRepositorio {

  final _dio = DioHttp().dio;

   Future<ResponseHttp> getAllProductos(int page,{bool oferta = false}) async {
    try {
      final response = await this._dio.get('/productos',queryParameters: {'page': page,'oferta' : oferta});
      final productos = response.data.map<Producto>((producto)=>Producto.toJson(producto)).toList();
      return ResponseProductos(productos: productos);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

   Future<ResponseHttp> searchProductos(String texto) async {
    try {
      final response = await this._dio.get('/productos/search/$texto');
      final productos = response.data.map<Producto>((producto)=>Producto.toJson(producto)).toList();
      return ResponseProductos(productos: productos);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> getCategorias() async {
    try {
      final response = await this._dio.get('/categorias_producto');
      final categorias = response.data
          .map<CategoriaProducto>(
              (categoria) => CategoriaProducto.toJson(categoria))
          .toList();
      return ResponseProductos(categorias: categorias);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

   Future<ResponseHttp> getAllProductosByCategoria(int idCategoria) async {
    try {
      final response = await this._dio.get('/productos/categoria/$idCategoria');
      final productos = response.data.map<Producto>((producto)=>Producto.toJson(producto)).toList();
      return ResponseProductos(productos: productos);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }

  Future<ResponseHttp> getProductoByUsuario(int idUsuario) async {
    try {
      await Future.delayed(Duration(seconds: 5));
      final response = await this._dio.get('/productos/usuarios/$idUsuario');
      final productos = response.data
          .map<Producto>((producto) => Producto.toJson(producto))
          .toList();
      return ResponseProductos(productos: productos);
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  } 
  Future<ResponseHttp> addProducto(
      Producto producto, int idEmpresa, List<ImageFile> imagenes,{Function(double)? onProgress}) async {
    try {
      FormData data = FormData.fromMap({...producto.toMap(idEmpresa)});
      imagenes.forEach((imagen) async {
        data.files.add(MapEntry(
          imagen.nombre,
          MultipartFile.fromFileSync(imagen.file!.path, filename: imagen.nombre),
        ));
      });
      final response = await this._dio.post('/productos/add', data: data,onSendProgress: (int received, int total) {
          final progress = (received / total);
          onProgress?.call(progress);
        },);
      return ResponseProductos(producto: Producto.toJson(response.data));
    } on DioError catch (error) {
      return ErrorResponseHttp(error);
    }
  }
  /* Future<ResponseModel> addProducto(
      Producto producto, int idEmpresa, List<ImageFile> imagenes) async {
    try {
      FormData data = FormData.fromMap({...producto.toMap(idEmpresa)});
      imagenes.forEach((imagen) async {
        data.files.add(MapEntry(
          imagen.nombre,
          MultipartFile.fromFileSync(imagen.file.path, filename: imagen.nombre),
        ));
      });
      final response = await this._dio.post('/productos/add', data: data);
      return ResponseProducto(producto: Producto.toJson(response.data));
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }
  Future<ResponseModel> getAllProductos(int page,{bool oferta}) async {
    try {
      //await Future.delayed(Duration(seconds: 20));
      final response = await this._dio.get('/productos',queryParameters: {'page': page,'oferta' : oferta});
      final productos = response.data.map<Producto>((producto)=>Producto.toJson(producto)).toList();
      return ResponseProducto(productos: productos);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }
  Future<ResponseModel> getAllProductosByCategoria(int page,int idCategoria) async {
    try {
      final response = await this._dio.get('/productos/categoria/$idCategoria',queryParameters: {'page': page,});
      final productos = response.data.map<Producto>((producto)=>Producto.toJson(producto)).toList();
      return ResponseProducto(productos: productos);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> updateProducto(
      Producto producto, int idEmpresa, List<ImageFile> imagenes) async {
    try {
      FormData data = FormData.fromMap({...producto.toMap(idEmpresa,producto.id)});
      imagenes.forEach((imagen) async {
        if(imagen.isaFile)
        data.files.add(MapEntry(
          imagen.nombre,
          MultipartFile.fromFileSync(imagen.file.path, filename: imagen.nombre),
        ));
      });
      final response = await this._dio.put('/productos/update', data: data);
      return ResponseProducto(update: response.data);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> deleteProducto(int idProducto) async {
    try {
      final response = await this._dio.delete('/productos/delete/$idProducto');
      return ResponseProducto(delete: response.data);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> getCategorias() async {
    try {
      final response = await this._dio.get('/categorias_producto');
      final categorias = response.data
          .map<CategoriaProducto>(
              (categoria) => CategoriaProducto.toJson(categoria))
          .toList();
      return ResponseProducto(categorias: categorias);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }

  Future<ResponseModel> getProductoByUsuario(int idUsuario) async {
    try {
      final response = await this._dio.get('/productos/usuarios/$idUsuario');
      final productos = response.data
          .map<Producto>((producto) => Producto.toJson(producto))
          .toList();
      return ResponseProducto(productos: productos);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  } 
  Future<ResponseModel> getProductoByEmpresa(int idEmpresa) async {
    try {
      final response = await this._dio.get('/productos/empresa/$idEmpresa');
      final productos = response.data
          .map<Producto>((producto) => Producto.toJson(producto))
          .toList();
      return ResponseProducto(productos: productos);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  } 

  Future<ResponseModel> addPedido(Pedido pedido) async {
    try {
      final response = await this._dio.post('/pedidos/add',data: {...pedido.toMap()});
      return ResponseProducto(addPedido: response.data);
    } on DioError catch (error) {
      return ErrorResponse(error);
    }
  }  */
}
