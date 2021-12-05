import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/categoriaProducto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';

class ResponseProductos extends ResponseHttp {
  final List<Producto>? productos;
  final List<CategoriaProducto>? categorias;
  final Producto? producto;
  final bool? delete, update;

  ResponseProductos(
      {this.productos, this.categorias, this.producto, this.delete,this.update});
}
