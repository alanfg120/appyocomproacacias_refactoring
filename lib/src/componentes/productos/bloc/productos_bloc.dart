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
      if (!state.getInitaialData){
        add(GetProductosEvent());
        add(GetCategoriasProductoEvent());
      }
      
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
        emit(state.copyWith(loadingSearch: true));
        final response = await repocitorio.searchProductos(event.texto);
        if (response is ResponseProductos) {
          emit(state.copyWith(
              resulProductos: response.productos, loadingSearch: false));
        }
      }
    }, transformer: debounce(Duration(milliseconds: 400)));

    on<GetOfertasProductosEvent>((event, emit) async {
      final response = await repocitorio
          .getAllProductos(event.news ? 0 : state.paginaOfertas, oferta: true);
      if (response is ResponseProductos) {
        final ofertas =
            _getOfertas(event.news, state.ofertas, response.productos);
        emit(state.copyWith(
            ofertas: ofertas,
            paginaOfertas: event.news ? 1 : state.paginaOfertas + 1,
            loadingOfertas: false));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    });

    on<GetProductosByCategoriaEvent>((event, emit) async {
      final response =
          await repocitorio.getAllProductosByCategoria(event.idCategoria);
      if (response is ResponseProductos) {
        emit(state.copyWith(
            resulProductos: List.of(state.resulProductos)
              ..addAll(response.productos!),
            loadingProductos: false));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    });

    on<GetProductosByUsuarioEvent>((event, emit) async {
      if (state.productosOfUsuario.length == 0) {
        emit(state.copyWith(loadingProdUsuario: true));
        final response = await repocitorio.getProductoByUsuario(prefs.idUsuario);
        if(response is ResponseProductos){
          emit(state.copyWith(
               productosOfUsuario: response.productos,
               loadingProdUsuario: false
          ));
        }
        if(response is ErrorResponseHttp){
          print(response.getError);
        }
      }
    });
    
    on<AddProductoEvent>((event, emit) {
     
    });
  }

  List<Producto> _getOfertas(
      bool news, List<Producto> ofertas, List<Producto>? productos) {
    List<Producto> ofertas;
    if (news) {
      ofertas = productos!;
    } else {
      ofertas = List.of(state.ofertas);
      ofertas.addAll(productos!);
    }
    return ofertas;
  }
}
