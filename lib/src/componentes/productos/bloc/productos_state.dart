part of 'productos_bloc.dart';


class ProductosState extends Equatable {
  
  final List<Producto> productos;
  final List<Producto> resulProductos;
  final List<Producto> ofertas;
  final List<CategoriaProducto> categorias;
  final bool getInitaialData,
             loadingProductos,
             loadingCategorias,
             loadingSearch,
             loadingOfertas;
  final int paginaProductos,paginaOfertas;
 
  const ProductosState({
        required this.productos,
        required this.resulProductos,
        required this.ofertas,
        required this.categorias,
        required this.getInitaialData,
        required this.loadingProductos,
        required this.loadingCategorias,
        required this.loadingSearch,
        required this.loadingOfertas,
        required this.paginaProductos,
        required this.paginaOfertas});
  
  factory ProductosState.initial() => 
          ProductosState(
          productos         : [],
          resulProductos    : [],
          ofertas           : [],
          categorias        : [],
          paginaProductos   : 0,
          paginaOfertas     : 0,
          loadingProductos  : true,
          loadingOfertas    : true,
          getInitaialData   : false,
          loadingCategorias : false,
          loadingSearch     : false,
          );

  ProductosState copyWith(
                  {List<Producto>? productos,
                   List<Producto>? resulProductos,
                   List<Producto>? ofertas,
                   List<CategoriaProducto>? categorias,
                   int? paginaProductos,
                   int? paginaOfertas,
                   bool? getInitaialData,
                   bool? loadingProductos, 
                   bool? loadingCategorias,
                   bool? loadingSearch,
                   bool? loadingOfertas}) 
                   => ProductosState(
                      productos         : productos         ?? this.productos,
                      resulProductos    : resulProductos    ?? this.resulProductos,
                      ofertas           : ofertas           ?? this.ofertas,
                      categorias        : categorias        ?? this.categorias,
                      paginaProductos   : paginaProductos   ?? this.paginaProductos,
                      paginaOfertas     : paginaOfertas     ?? this.paginaOfertas,
                      getInitaialData   : getInitaialData   ?? this.getInitaialData,
                      loadingProductos  : loadingProductos  ?? this.loadingProductos,
                      loadingCategorias : loadingCategorias ?? this.loadingCategorias,
                      loadingSearch     : loadingSearch     ?? this.loadingSearch, 
                      loadingOfertas    : loadingOfertas    ?? this.loadingOfertas  
                   );

  @override
  List<Object> get props 
         => [productos,
             resulProductos,
             ofertas,
             categorias,
             paginaProductos,
             paginaOfertas,
             getInitaialData,
             loadingProductos,
             loadingCategorias,
             loadingSearch,
             loadingOfertas];
}


