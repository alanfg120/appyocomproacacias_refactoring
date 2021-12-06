import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/data/pedidos.repocitorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/models/pedido.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/url_laucher.dart';
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
      if (state.pedidos.length == 0) {
        emit(state.copyWith(
            pedidos: List.of(state.pedidos)
              ..add(_addNewPedido(event.producto.empresa, event.producto))));
      }
    });

    on<AddCantidadProductoEvent>((event, emit) {
      final newProductos = state.pedidos[event.indexPedido].productos.map((p) {
        if (p.id == event.idProducto) {
          final producto = p.copyWith(cantidad: p.cantidad + 1);
          return producto;
        }
        return p;
      }).toList();
      final newPedido =
          state.pedidos[event.indexPedido].copyWith(productos: newProductos);
      emit(state.copyWith(
          pedidos: List.of(state.pedidos)
            ..removeAt(event.indexPedido)
            ..insert(event.indexPedido, newPedido)));
    });

    on<DeleteCantidadProductoEvent>((event, emit) {
      final newProductos = state.pedidos[event.indexPedido].productos.map((p) {
        if (p.id == event.idProducto && p.cantidad > 1) {
          final producto = p.copyWith(cantidad: p.cantidad - 1);
          return producto;
        }
        return p;
      }).toList();
      final newPedido =
          state.pedidos[event.indexPedido].copyWith(productos: newProductos);
      emit(state.copyWith(
          pedidos: List.of(state.pedidos)
            ..removeAt(event.indexPedido)
            ..insert(event.indexPedido, newPedido)));
    });
  
    on<DeletePedidoEvent>((event, emit) {
      emit(state.copyWith(
        pedidos: List.of(state.pedidos)..removeAt(event.indexPedido)
      ));
    });
    
    on<SendPedidoEvent>((event, emit) async {
     emit(state.copyWith(loading: true));
     final response = await repocitorio.addPedido(event.pedido);
     if(response is ResponsePedido){
       if(response.addPedido!){
         await goSendToWhatsapp(event.pedido.empresa.telefono,_getTexto(event.pedido,event.nombreUsuario));
         final index = _getIndexPedido(state.pedidos,event.pedido.empresa.id!);
         add(DeletePedidoEvent(indexPedido: index));
         emit(state.copyWith(loading: false));
       }
     }
     if(response is ErrorResponseHttp){
       print(response.getError);
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

  String _getTexto(Pedido pedido,String nombre){
     var texto = 'Hola Buenos Dias ${pedido.empresa.nombre} soy $nombre mi pedido es';
        pedido.productos.forEach((producto) {
           texto = '$texto  ${producto.cantidad} de ${producto.nombre},';
       });
     texto = '$texto y con las siguientes observaciones: ${pedido.observacion}';
     return texto;
  }
}
