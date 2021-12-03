part of 'productos_bloc.dart';

abstract class ProductosEvent extends Equatable {
  const ProductosEvent();
  @override
  List<Object> get props => [];
}

class GetProductosEvent extends ProductosEvent {}

class GetInitialData extends ProductosEvent {}

class GetNewProductosEvent extends ProductosEvent {}

class GetOfertasProductosEvent extends ProductosEvent {}

class GetCategoriasProductoEvent extends ProductosEvent {}

class SearchProductoEvent extends ProductosEvent {
 final String texto;
  SearchProductoEvent(this.texto);
  @override
  List<Object> get props => [texto];
}