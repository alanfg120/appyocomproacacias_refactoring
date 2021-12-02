import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'empresas_event.dart';
part 'empresas_state.dart';

class EmpresasBloc extends Bloc<EmpresasEvent, EmpresasState> {
  final EmpresaRepositorio repositorio;
  final PreferenciasUsuario prefs;

  EventTransformer<SearchEmpresaEvent> debounce<SearchEmpresaEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  EmpresasBloc({required this.repositorio, required this.prefs})
      : super(EmpresasState.intial()) {
    on<SearchEmpresaEvent>((event, emit) async {
      if (event.text.length > 3) {
        emit(state.copyWith(loading: true));
        final response = await repositorio.searchEmpresa(event.text);
        if (response is ResponseEmpresa) {
          emit(
              state.copyWith(resultEmpresa: response.empresas, loading: false));
        }
        if (response is ErrorResponseHttp) {
          print(response.getError);
        }
      }
    }, transformer: debounce(Duration(milliseconds: 500)));

    on<RegistarVisitaEmpresaEvent>((event, emit) async {
      final response = await repositorio.registrarVisitaEmpresa(
          event.idEmpresa, prefs.idUsuario);
      if (response is ResponseEmpresa) {
        if (response.visita!) {
          print('Visita registrada');
        }
      }
      if (response is ErrorResponseHttp) {
        print('Ocurrio un error');
      }
    });

    on<GetEmpresas>((event, emit) {
      emit(state.copyWith(empresas: event.empresas));
    });

    on<AddEmpresaEvent>((event, emit) {
      final newEmpresa = event.empresa
          .copyWith(urlLogo: '${event.empresa.id}_logo_empresa.jpg');
      emit(state.copyWith(empresas: List.of(state.empresas)..add(newEmpresa)));
    });

    on<DeleeteEmpresaEvent>((event, emit) async {
      emit(state.copyWith(loadingDelete: true));
      final response = await repositorio.deleteEmpresa(event.idEmpresa);
      if (response is ResponseEmpresa) {
        if (response.delete!) {
          final index = state.empresas
              .indexWhere((empresa) => empresa.id == event.idEmpresa);
          emit(state.copyWith(
              empresas: List.of(state.empresas)..removeAt(index),
              loadingDelete: false));
        }
      }
      if (response is ErrorResponseHttp) {
         print(response.getError);
         emit(state.copyWith(loadingDelete: true));
      }

    });
  
    on<UpdateEmpresaEvent>((event, emit){
      final index = state.empresas.indexWhere((empresa) => empresa.id == event.empresa.id);
      if(index != -1)
      emit(state.copyWith(
        empresas: List.of(state.empresas)..removeAt(index)
                                         ..insert(index, event.empresa)
      ));
      CachedNetworkImage.evictFromCache('${event.url}/logo/${event.empresa.urlLogo}');
    });
  }
}
