import 'package:appyocomproacacias_refactoring/src/componentes/productos/data/productos.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/categoriaProducto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'productos_event.dart';
part 'productos_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  final ProductosRepositorio repocitorio;
  final PreferenciasUsuario prefs;
  ProductosBloc({required this.repocitorio, required this.prefs})
      : super(ProductosState.initial()) {
    on<GetProductosEvent>((event, emit) async {
      if (!state.getInitaialData) {
        emit(state.copyWith(loadingProductos: true));
        final response =
            await repocitorio.getAllProductos(state.paginaProductos);
        if (response is ResponseProductos) {
          emit(state.copyWith(
              productos: response.productos,
              loadingProductos: false,
              getInitaialData: true));
        }
        if (response is ErrorResponseHttp) {
          print(response.getError);
        }
      }
    });
   
    on<GetCategoriasProductoEvent>((event, emit) async {
      if (state.categorias.length == 0) {
        emit(state.copyWith(loadingCategorias: true));
        await Future.delayed(Duration(seconds: 10));
        final response = await repocitorio.getCategorias();
        if (response is ResponseProductos) {
          emit(state.copyWith(
              categorias: response.categorias,loadingCategorias: false));
        }
        if (response is ErrorResponseHttp) {
          print(response.getError);
        }
      }
    });
  }
}
