import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/calificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'perfil_empresa_state.dart';

class PerfilEmpresaCubit extends Cubit<PerfilEmpresaState> {
  final EmpresaRepositorio repositorio;
  final PreferenciasUsuario prefs;

  PerfilEmpresaCubit({required this.repositorio, required this.prefs})
      : super(PerfilEmpresaState.initial());

  getCalificacionEmpresa(int start) => emit(state.copyWith(starts: start));

  selectPagina(int pagina) => emit(state.copyWith(pagina: pagina));

  getProductosEmpresa(int idEmpresa) async {
    if (state.initialDataProductos == false) {
      emit(state.copyWith(loading: true));
      final response = await repositorio.getProductosByEmpresa(idEmpresa);
      if (response is ResponseEmpresa) {
        emit(state.copyWith(
            productos: response.productos,
            loading: false,
            initialDataProductos: true));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    }
  }

  Future getCalificacionesEmpresa(int idEmpresa) async {
    if (state.initialDataCalificaciones == false) {
      emit(state.copyWith(loading: true));
      final response = await repositorio.getCalificacionesByEmpresa(idEmpresa);
      if (response is ResponseEmpresa) {
        emit(state.copyWith(
            calificaciones: response.calificaciones,
            loading: false,
            initialDataCalificaciones: true));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    }
  }

  getPublicacionesEmpresa(int idEmpresa) async {
    if (state.initialDataPublicaciones == false) {
      emit(state.copyWith(loading: true));
      final response = await repositorio.getPublicacionesByEmpresa(
          idEmpresa, prefs.idUsuario);
      if (response is ResponseEmpresa) {
        emit(state.copyWith(
            publicaciones: response.publicaciones,
            loading: false,
            initialDataPublicaciones: true));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    }
  }

  getEmpresaByid(int idEmpresa)  async {
    emit(state.copyWith(loading: true));
    final response = await repositorio.getEmpresaByid(idEmpresa);
    if(response is ResponseEmpresa){
      emit(state.copyWith(empresa: response.empresa));
       await getCalificacionesEmpresa(idEmpresa);
    }
    if(response is ErrorResponseHttp){
      print(response.getError);
    }
  } 

  Future calicarEmpresa(Usuario usuario, int idUsuarioDest, int idEmpresa,
      String comentario) async {
    emit(state.copyWith(loadingCalifiacion: true));
    final response = await repositorio.calificarEmpresa(
        usuario.id, idEmpresa, state.starts, idUsuarioDest, comentario);
    if(response is ResponseEmpresa){
      final calificacion = response.calificacion!.copyWith(usuario: usuario);
      emit(state.copyWith(
        calificaciones: List.of(state.calificaciones)..insert(0,calificacion),
        loadingCalifiacion: false
      ));
    }
    if(response is ErrorResponseHttp){
       print(response.getError);
        if(response.getError == 'CALIFICACION_EXITS'){
          emit(state.copyWith(duplicado: true,loadingCalifiacion: false));
        }
        emit(state.copyWith(duplicado: false));
    }
  }

}
