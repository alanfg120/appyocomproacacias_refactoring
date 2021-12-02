part of 'productos_bloc.dart';

abstract class ProductosEvent extends Equatable {
  const ProductosEvent();
  @override
  List<Object> get props => [];
}

class GetProductosEvent extends ProductosEvent {}

class GetCategoriasProductoEvent extends ProductosEvent {}