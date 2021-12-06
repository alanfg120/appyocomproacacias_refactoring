part of 'pedidos_bloc.dart';

class PedidosState extends Equatable {

  final List<Pedido> pedidos;
  final bool loading;
  
  const PedidosState({required this.pedidos,required this.loading});
  
  factory PedidosState.initial() 
          => PedidosState(
             pedidos: [],
             loading: false
          );

  PedidosState copyWith(
              {List<Pedido>? pedidos,
               bool? loading})
               => PedidosState(
                  pedidos: pedidos ?? this.pedidos,
                  loading: loading ?? this.loading
               );

  @override
  List<Object> get props => [pedidos];
}


