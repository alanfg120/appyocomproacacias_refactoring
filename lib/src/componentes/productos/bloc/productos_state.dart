part of 'productos_bloc.dart';


class ProductosState extends Equatable {
  
  final List<Producto> productos;
  final List<Producto> resulProductos;
  final List<CategoriaProducto> categorias;
  final bool getInitaialData,loadingProductos,loadingCategorias;
  final int paginaProductos;
 
  const ProductosState(
        {required this.productos,
        required this.resulProductos,
        required  this.categorias,
        required this.getInitaialData,
        required this.loadingProductos,
        required this.loadingCategorias,
        required this.paginaProductos});
  
  factory ProductosState.initial() => 
          ProductosState(
          productos        : [],
          resulProductos   : [],
          categorias       : [],
          paginaProductos  : 0,
          getInitaialData  : false,
          loadingProductos : true,
          loadingCategorias: false
          );

  ProductosState copyWith(
                  {List<Producto>? productos,
                   List<Producto>? resulProductos,
                   List<CategoriaProducto>? categorias,
                   int? paginaProductos,
                   bool? getInitaialData,
                   bool? loadingProductos, 
                   bool? loadingCategorias}) 
                   => ProductosState(
                      productos         : productos         ?? this.productos,
                      resulProductos    : resulProductos    ?? this.resulProductos,
                      categorias        : categorias        ?? this.categorias,
                      paginaProductos   : paginaProductos   ?? this.paginaProductos,
                      getInitaialData   : getInitaialData   ?? this.getInitaialData,
                      loadingProductos  : loadingProductos  ?? this.loadingProductos,
                      loadingCategorias : loadingCategorias ?? this.loadingCategorias
                   );

  @override
  List<Object> get props 
         => [productos,
             resulProductos,
             categorias,
             paginaProductos,
             getInitaialData,
             loadingProductos,
             loadingCategorias];
}


