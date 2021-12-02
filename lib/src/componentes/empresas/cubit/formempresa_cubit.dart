import 'dart:io';

import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/categoria.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'formempresa_state.dart';

class FormEmpresaCubit extends Cubit<FormEmpresaState> {
  final EmpresaRepositorio repositorio;
  final PreferenciasUsuario prefs;

  FormEmpresaCubit({required this.repositorio, required this.prefs})
      : super(FormEmpresaState.initial());

  changePagina(int pagina) {
    if (pagina >= 0 && pagina < 5) emit(state.copyWith(index: pagina));
  }

  selectCategoria(Categoria categoria) {
    emit(state.copyWith(categoria: categoria));
  }

  Future selectLogo(File imagen) async {
    if (state.logo != null) {
      if (state.logo!.isaFile) {
        state.logo!.file!.delete();
      }
    }
    emit(state.copyWith(
        logo: ImageFile(nombre: 'logo', isaFile: true, file: imagen)));
  }

  getLocation(Position position) {
    emit(state.copyWith(
        latitud: position.latitude, longitud: position.longitude));
  }

  Future<Empresa?> addEmpresa(Empresa empresa) async {
    emit(state.copyWith(loading: true));
    final response = await repositorio.addEmpresa(
        empresa, prefs.idUsuario, state.logo!.file!.path);
    if (response is ResponseEmpresa) {
      final newEmpresa = empresa.copyWith(id: response.id);
      emit(state.copyWith(loading: false, add: true));
      return newEmpresa;
    }
    if (response is ErrorResponseHttp) {
      print(response.getError);
      emit(state.copyWith(
          loading: false, error: ErrorFormEmpresaResponse.RESPONSE_ERROR));
    }
    emit(state.copyWith(error: ErrorFormEmpresaResponse.NO_ERROR));
  }

  Future<bool?> updateEmpresa(Empresa empresa) async {
    emit(state.copyWith(loading: true));
    final response = await repositorio.updateEmpresa(empresa, prefs.idUsuario,
        path: state.logo == null ? null : state.logo!.file!.path);
    if (response is ResponseEmpresa) {
      if (response.update!) {
        emit(state.copyWith(loading: false, add: true));
        return true;
      }
    }
    if (response is ErrorResponseHttp) {
      print(response.getError);
      emit(state.copyWith(
          loading: false, error: ErrorFormEmpresaResponse.RESPONSE_ERROR));
      return false;
    }
    emit(state.copyWith(error: ErrorFormEmpresaResponse.NO_ERROR));
  }
}
