part of 'productos_bloc.dart';


class ProductosState extends Equatable {
  
  final List<Producto> productos,
                       resulProductos,
                       productosOfUsuario,
                       ofertas;
  final List<CategoriaProducto> categorias;
  final bool getInitaialData,
             loadingProductos,
             loadingCategorias,
             loadingSearch,
             loadingOfertas,
             loadingProdUsuario,
             loadingDelete;

  final int paginaProductos,paginaOfertas;
 
  const ProductosState({
        required this.productos,
        required this.resulProductos,
        required this.ofertas,
        required this.productosOfUsuario,
        required this.categorias,
        required this.getInitaialData,
        required this.loadingProductos,
        required this.loadingCategorias,
        required this.loadingSearch,
        required this.loadingOfertas,
        required this.loadingProdUsuario,
        required this.loadingDelete,
        required this.paginaProductos,
        required this.paginaOfertas});
  
  factory ProductosState.initial() => 
          ProductosState(
          productos          : [],
          resulProductos     : [],
          ofertas            : [],
          productosOfUsuario : [],
          categorias         : [],
          paginaProductos    : 0,
          paginaOfertas      : 0,
          loadingProductos   : true,
          loadingOfertas     : true,
          getInitaialData    : false,
          loadingCategorias  : false,
          loadingSearch      : false,
          loadingProdUsuario : false,
          loadingDelete      : false 
          );

  ProductosState copyWith(
                  {List<Producto>? productos,
                   List<Producto>? resulProductos,
                   List<Producto>? ofertas,
                   List<Producto>? productosOfUsuario,
                   List<CategoriaProducto>? categorias,
                   int? paginaProductos,
                   int? paginaOfertas,
                   bool? getInitaialData,
                   bool? loadingProductos, 
                   bool? loadingCategorias,
                   bool? loadingSearch,
                   bool? loadingOfertas,
                   bool? loadingProdUsuario,
                   bool? loadingDelete}) 
                   => ProductosState(
                      productos          : productos          ?? this.productos,
                      resulProductos     : resulProductos     ?? this.resulProductos,
                      ofertas            : ofertas            ?? this.ofertas,
                      productosOfUsuario : productosOfUsuario ?? this.productosOfUsuario,
                      categorias         : categorias         ?? this.categorias,
                      paginaProductos    : paginaProductos    ?? this.paginaProductos,
                      paginaOfertas      : paginaOfertas      ?? this.paginaOfertas,
                      getInitaialData    : getInitaialData    ?? this.getInitaialData,
                      loadingProductos   : loadingProductos   ?? this.loadingProductos,
                      loadingCategorias  : loadingCategorias  ?? this.loadingCategorias,
                      loadingSearch      : loadingSearch      ?? this.loadingSearch, 
                      loadingOfertas     : loadingOfertas     ?? this.loadingOfertas,  
                      loadingProdUsuario : loadingProdUsuario ?? this.loadingProdUsuario, 
                      loadingDelete      : loadingDelete      ?? this.loadingDelete  
                   );

  @override
  List<Object> get props 
         => [productos,
             resulProductos,
             ofertas,
             productosOfUsuario,
             categorias,
             paginaProductos,
             paginaOfertas,
             getInitaialData,
             loadingProductos,
             loadingCategorias,
             loadingSearch,
             loadingOfertas,
             loadingProdUsuario,
             loadingDelete];
}


