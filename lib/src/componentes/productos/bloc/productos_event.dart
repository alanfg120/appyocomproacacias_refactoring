part of 'productos_bloc.dart';

abstract class ProductosEvent extends Equatable {
  const ProductosEvent();
  @override
  List<Object?> get props => [];
}

class GetProductosEvent extends ProductosEvent {}

class GetInitialData extends ProductosEvent {}

class GetNewProductosEvent extends ProductosEvent {}

class GetCategoriasProductoEvent extends ProductosEvent {}

class GetProductosByUsuarioEvent extends ProductosEvent {}



class GetOfertasProductosEvent extends ProductosEvent {
  final bool news;
  GetOfertasProductosEvent({this.news = false});
}

class SearchProductoEvent extends ProductosEvent {
 final String texto;
  SearchProductoEvent(this.texto);
  @override
  List<Object?> get props => [texto];
}
class GetProductosByCategoriaEvent extends ProductosEvent {
  final int idCategoria;
  GetProductosByCategoriaEvent(this.idCategoria);
  @override
  List<Object?> get props => [idCategoria];
}
class AddProductoEvent extends ProductosEvent {
  final Producto producto;
  AddProductoEvent(this.producto);
  @override
  List<Object?> get props => [producto];
}


