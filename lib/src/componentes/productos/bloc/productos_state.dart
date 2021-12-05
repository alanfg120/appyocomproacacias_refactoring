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
             loadingDelete,
             loadingForm;
  final double progress;
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
        required this.loadingForm,
        required this.paginaProductos,
        required this.paginaOfertas,
        required this.progress});
  
  factory ProductosState.initial() => 
          ProductosState(
          productos          : [],
          resulProductos     : [],
          ofertas            : [],
          productosOfUsuario : [],
          categorias         : [],
          paginaProductos    : 0,
          paginaOfertas      : 0,
          progress           : 0.0,
          loadingProductos   : true,
          loadingOfertas     : true,
          getInitaialData    : false,
          loadingCategorias  : false,
          loadingSearch      : false,
          loadingProdUsuario : false,
          loadingDelete      : false,
          loadingForm        : false
          );

  ProductosState copyWith(
                  {List<Producto>? productos,
                   List<Producto>? resulProductos,
                   List<Producto>? ofertas,
                   List<Producto>? productosOfUsuario,
                   List<CategoriaProducto>? categorias,
                   int? paginaProductos,
                   int? paginaOfertas,
                   double? progress,
                   bool? getInitaialData,
                   bool? loadingProductos, 
                   bool? loadingCategorias,
                   bool? loadingSearch,
                   bool? loadingOfertas,
                   bool? loadingProdUsuario,
                   bool? loadingDelete,
                   bool? loadingForm}) 
                   => ProductosState(
                      productos          : productos          ?? this.productos,
                      resulProductos     : resulProductos     ?? this.resulProductos,
                      ofertas            : ofertas            ?? this.ofertas,
                      productosOfUsuario : productosOfUsuario ?? this.productosOfUsuario,
                      categorias         : categorias         ?? this.categorias,
                      paginaProductos    : paginaProductos    ?? this.paginaProductos,
                      paginaOfertas      : paginaOfertas      ?? this.paginaOfertas,
                      progress           : progress           ?? this.progress,
                      getInitaialData    : getInitaialData    ?? this.getInitaialData,
                      loadingProductos   : loadingProductos   ?? this.loadingProductos,
                      loadingCategorias  : loadingCategorias  ?? this.loadingCategorias,
                      loadingSearch      : loadingSearch      ?? this.loadingSearch, 
                      loadingOfertas     : loadingOfertas     ?? this.loadingOfertas,  
                      loadingProdUsuario : loadingProdUsuario ?? this.loadingProdUsuario, 
                      loadingDelete      : loadingDelete      ?? this.loadingDelete,
                      loadingForm        : loadingForm        ?? this.loadingForm
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
             progress,
             getInitaialData,
             loadingProductos,
             loadingCategorias,
             loadingSearch,
             loadingOfertas,
             loadingProdUsuario,
             loadingDelete,
             loadingForm];
}


