part of 'productos_bloc.dart';


class ProductosState extends Equatable {
  
  final List<Producto> productos;
  final List<CategoriaProducto> categorias;
  final bool getInitaialData,loadingProductos,loadingCategorias;
  final int paginaProductos;
 
  const ProductosState(
        {required this.productos,
        required  this.categorias,
        required this.getInitaialData,
        required this.loadingProductos,
        required this.loadingCategorias,
        required this.paginaProductos});
  
  factory ProductosState.initial() => 
          ProductosState(
          productos        : [],
          categorias       : [],
          paginaProductos  : 0,
          getInitaialData  : false,
          loadingProductos : false,
          loadingCategorias : false
          );

  ProductosState copyWith(
                  {List<Producto>? productos,
                   List<CategoriaProducto>? categorias,
                   int? paginaProductos,
                   bool? getInitaialData,
                   bool? loadingProductos, 
                   bool? loadingCategorias}) 
                   => ProductosState(
                      productos         : productos        ?? this.productos,
                      categorias        : categorias       ?? this.categorias,
                      paginaProductos   : paginaProductos  ?? this.paginaProductos,
                      getInitaialData   : getInitaialData  ?? this.getInitaialData,
                      loadingProductos  : loadingProductos ?? this.loadingProductos,
                      loadingCategorias : loadingCategorias ?? this.loadingCategorias
                   );

  @override
  List<Object> get props 
         => [productos,
             categorias,
             paginaProductos,
             getInitaialData,
             loadingProductos,
             loadingCategorias];
}


