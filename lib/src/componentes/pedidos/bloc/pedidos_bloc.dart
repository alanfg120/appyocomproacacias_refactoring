import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/data/pedidos.repocitorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/models/pedido.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'pedidos_event.dart';
part 'pedidos_state.dart';

class PedidosBloc extends Bloc<PedidosEvent, PedidosState> {
  final PedidoRepocitorio repocitorio;
  final PreferenciasUsuario prefs;
  PedidosBloc({required this.repocitorio, required this.prefs})
      : super(PedidosState.initial()) {
    on<AddProductoEvent>((event, emit) {
      if (state.pedidos.length == 0) {
        emit(state.copyWith(
            pedidos: List.of(state.pedidos)
              ..add(_addNewPedido(event.producto.empresa, event.producto))));
      }
      if (state.pedidos.length > 0) {
        final index = _getIndexPedido(state.pedidos, event.id);
        if (index == -1) {
          emit(state.copyWith(
              pedidos: List.of(state.pedidos)
                ..add(_addNewPedido(event.producto.empresa, event.producto))));
        }
        if (index != -1) {
          final pedido = state.pedidos[index];
          final existProducto =
              _productoExist(event.producto, pedido.productos);
          if (existProducto) {
            final newProductos = _updateProductos(pedido, event.producto);
            final newPedido =
                state.pedidos[index].copyWith(productos: newProductos);
            emit(state.copyWith(
                pedidos: List.of(state.pedidos)
                  ..removeAt(index)
                  ..insert(index, newPedido)));
          } else {
            state.pedidos[index].productos.add(event.producto);
            emit(state.copyWith(pedidos: List.of(state.pedidos)));
          }
        }
      }
    });
  }

  List<Producto> _updateProductos(Pedido pedido, Producto producto) {
    final productos = pedido.productos.map((p) {
      if (p.id == producto.id) {
        final newproducto =
            p.copyWith(cantidad: p.cantidad + producto.cantidad);
        return newproducto;
      }
      return p;
    }).toList();
    return productos;
  }

  bool _productoExist(Producto producto, List<Producto> productos) {
    return productos.indexWhere((p) => p.id == producto.id) != -1;
  }

  int _getIndexPedido(List<Pedido> pedidos, int id) {
    return pedidos.indexWhere((pedido) => pedido.empresa.id == id);
  }

  Pedido _addNewPedido(Empresa empresa, Producto producto) => Pedido(
      id: Uuid().v4(),
      empresa: empresa,
      idUsuario: prefs.idUsuario,
      observacion: '',
      productos: [producto],
      realizado: false);
}
