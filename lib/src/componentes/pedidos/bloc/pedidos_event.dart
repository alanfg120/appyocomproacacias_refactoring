part of 'pedidos_bloc.dart';

abstract class PedidosEvent extends Equatable {
  const PedidosEvent();
  @override
  List<Object?> get props => [];
}

class AddProductoEvent extends PedidosEvent {
  final int id;
  final Producto producto;

  AddProductoEvent({required this.producto, required this.id});
  @override
  List<Object?> get props => [producto];
}

class AddCantidadProductoEvent extends PedidosEvent {
  final int indexPedido;
  final int idProducto;

  AddCantidadProductoEvent({required this.indexPedido, required this.idProducto});
  @override
  List<Object?> get props => [idProducto,indexPedido];
}
class DeleteCantidadProductoEvent extends PedidosEvent {
  final int indexPedido;
  final int idProducto;

  DeleteCantidadProductoEvent({required this.indexPedido, required this.idProducto});
  @override
  List<Object?> get props => [idProducto,indexPedido];
}
class DeletePedidoEvent extends PedidosEvent {
  final int indexPedido;
  DeletePedidoEvent({required this.indexPedido});
  @override
  List<Object?> get props => [indexPedido];
}
class SendPedidoEvent extends PedidosEvent {
  final Pedido pedido;
  final String nombreUsuario;
  SendPedidoEvent({required this.pedido,required this.nombreUsuario});
  @override
  List<Object?> get props => [pedido];
}





