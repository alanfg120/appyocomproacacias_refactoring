import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/models/pedido.model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pedidos_event.dart';
part 'pedidos_state.dart';

class PedidosBloc extends Bloc<PedidosEvent, PedidosState> {
  PedidosBloc() : super(PedidosState.initial()) {

  }
}
