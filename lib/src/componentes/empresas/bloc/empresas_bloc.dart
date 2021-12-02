import 'package:appyocomproacacias_refactoring/src/componentes/categorias/bloc/categorias_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
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
      if(response is ResponseEmpresa){
        if(response.visita!){
          print('Visita registrada');
        }
      }
      if(response is ErrorResponseHttp){
        print('Ocurrio un error');
      }
    });
    
    on<GetEmpresas>((event,emit){
      emit(state.copyWith(empresas: event.empresas));
    });
    on<AddEmpresaEvent>((event,emit){
      emit(state.copyWith(
        empresas: List.of(state.empresas)..add(event.empresa)
      ));
    });
  }
}
