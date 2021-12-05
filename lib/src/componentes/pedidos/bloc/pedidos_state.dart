part of 'pedidos_bloc.dart';

class PedidosState extends Equatable {
  final List<Pedido> pedidos;
  
  const PedidosState({required this.pedidos});
  
  factory PedidosState.initial() 
          => PedidosState(
             pedidos: []
          );

  PedidosState copyWith({List<Pedido>? pedidos})
               => PedidosState(pedidos: pedidos ?? this.pedidos);

  @override
  List<Object> get props => [pedidos];
}


