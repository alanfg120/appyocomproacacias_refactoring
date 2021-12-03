import 'package:appyocomproacacias_refactoring/src/componentes/productos/data/productos.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/categoriaProducto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
part 'productos_event.dart';
part 'productos_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  final ProductosRepositorio repocitorio;
  final PreferenciasUsuario prefs;

  EventTransformer<GetProductosEvent> debounce<GetProductosEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  ProductosBloc({required this.repocitorio, required this.prefs})
      : super(ProductosState.initial()) {
    on<GetInitialData>((event, emit) async {
      if (!state.getInitaialData) add(GetProductosEvent());
    });

    on<GetProductosEvent>((event, emit) async {
      final response = await repocitorio.getAllProductos(state.paginaProductos);
      if (response is ResponseProductos) {
        emit(state.copyWith(
            productos: List.of(state.productos)..addAll(response.productos!),
            paginaProductos: state.paginaProductos + 1,
            loadingProductos: false,
            getInitaialData: true));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    }, transformer: debounce(Duration(milliseconds: 200)));

    on<GetCategoriasProductoEvent>((event, emit) async {
      if (state.categorias.length == 0) {
        emit(state.copyWith(loadingCategorias: true));
        final response = await repocitorio.getCategorias();
        if (response is ResponseProductos) {
          emit(state.copyWith(
              categorias: response.categorias, loadingCategorias: false));
        }
        if (response is ErrorResponseHttp) {
          print(response.getError);
        }
      }
    });

    on<GetNewProductosEvent>((event, emit) async {
      emit(state.copyWith(loadingProductos: true));
      final response = await repocitorio.getAllProductos(0);
      if (response is ResponseProductos) {
        emit(state.copyWith(
            productos: response.productos,
            loadingProductos: false,
            paginaProductos: 1));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    });

    on<SearchProductoEvent>((event, emit) async {
      if (event.texto.length > 3) {
        emit(state.copyWith(loadingProductos: true));
        final response = await repocitorio.searchProductos(event.texto);
        if (response is ResponseProductos) {
          emit(state.copyWith(
              resulProductos: response.productos, loadingProductos: false));
        }
      }
    }, transformer: debounce(Duration(milliseconds: 400)));
  }
}
