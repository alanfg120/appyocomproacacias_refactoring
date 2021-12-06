part of 'pedidos_bloc.dart';

abstract class PedidosEvent extends Equatable {
  const PedidosEvent();
  @override
  List<Object?> get props => [];
}

class AddProductoEvent extends PedidosEvent {
 final int id;
 final Producto producto;

  AddProductoEvent({required this.producto,required this.id});

  @override
  List<Object?> get props => [producto];
}