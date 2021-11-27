import 'package:appyocomproacacias_refactoring/src/componentes/categorias/data/categorias.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/categoria.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
part 'categorias_event.dart';
part 'categorias_state.dart';

class CategoriasBloc extends Bloc<CategoriasEvent, CategoriasState> {
  final CategoriaRepositorio repositorio;

  EventTransformer<SearchEmpresaEvent> debounce<SearchEmpresaEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  CategoriasBloc(this.repositorio) : super(CategoriasState.initial()) {
    
    on<GetEmpresasEvent>((event, emit) async {
      if (state.categoria != event.categoria) {
        emit(state.copyWith(loading: true, pagina: 0));
        final response =
            await repositorio.getEmpresasByCategoria(event.categoria, 0);
        if (response is ResponseCategorias) {
          emit(state.copyWith(
              empresas: response.empresas,
              loading: false,
              pagina: 1,
              numeroEmpresas: response.empresas!.length,
              categoria: event.categoria,
              end: false));
        }
        if (response is ErrorResponseHttp) {
          print(response.getError);
        }
      }
    });

    on<GetCategoriasEvent>((event, emit) async {
      if (state.categorias.length == 0) {
        emit(state.copyWith(loading: true));
        final response = await repositorio.getCategorias();
        if (response is ResponseCategorias) {
          emit(state.copyWith(categorias: response.categorias, loading: false));
        }
        if (response is ErrorResponseHttp) {
          print(response.getError);
        }
      }
    });

    on<SearchEmpresasEvent>((event, emit) async {
      if (event.text.length > 3) {
        emit(state.copyWith(loading: true));
        final response = await repositorio.buscarEmpresasPorCategoria(
            event.categoria, event.text);
        if (response is ResponseCategorias) {
          emit(state.copyWith(
              resultEmpresas: response.empresas, loading: false));
        }
        if (response is ErrorResponseHttp) {
          print(response.getError);
        }
      }
    }, transformer: debounce(Duration(milliseconds: 200)));

    on<GetNewEmpresasEvent>((event, emit) async {
      final response = await repositorio.getEmpresasByCategoria(
          event.categoria, state.pagina);
      if (response is ResponseCategorias) {
        if (!state.end) {
          final newEmpresas = List.of(state.empresas)
            ..addAll(response.empresas!);
          print(newEmpresas.length / 10);
          emit(state.copyWith(
              empresas: newEmpresas, pagina: state.pagina + 1, end: false));
        }
        if (response.empresas!.length == 0 ||
            response.empresas!.length % state.numeroEmpresas != 0)
          emit(state.copyWith(end: true));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    }, transformer: debounce(Duration(milliseconds: 500)));
  }

}
