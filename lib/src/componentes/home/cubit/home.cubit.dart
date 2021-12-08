import 'dart:io';

import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/data/home.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/home.response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/ErrorResponse.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/google_sing_in.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class HomeCubit extends Cubit<HomeState> {

  final PreferenciasUsuario preferencias;
  final HomeRepocitorio repositorio;
  final String urlImagenes;

  HomeCubit({
    required this.preferencias,
    required this.repositorio,
    required this.urlImagenes})
      : super(HomeState.initial(urlImagenes));

  selectPage(int page) {
    emit(state.copyWith(page: page));
  }

  _getTokenAnonimo() async {
    if (preferencias.token.isEmpty) {
      final response = await repositorio.getTokenAnonimo();
      if (response is HomeResponseHttp) {
        DioHttp().setToken(response.token!);
        emit(state.copyWith(offline: false));
      }
      if (response is ErrorResponse) {
        emit(HomeState.initial(urlImagenes));
      }
    }
  }

  Future _validateLogin() async {
    if (preferencias.token.isNotEmpty && !preferencias.idUsuario.isNegative) {
      final response = await repositorio.getUsuario(preferencias.idUsuario);
      if (response is HomeResponseHttp) {
        emit(state.copyWith(
            page: 1,
            currentUsuario: TipoUsuario.LODGET,
            usuario: response.usuario));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    } else
      _getTokenAnonimo();
  }

  updateUsuario(Usuario? usuario) {
    emit(state.copyWith(
        page: 1, usuario: usuario, currentUsuario: TipoUsuario.LODGET));
  }

  Future validateInternet() async {
   emit(state.copyWith(loading: true));
   if(await this._verificationInternet()){
      await this._validateLogin();
      emit(state.copyWith(offline: false,loading: false));
   }
   else emit(state.copyWith(offline: true,loading: false));
  }

  Future<bool> _verificationInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
  
  Future logOut() async {
    preferencias.eraseall();
    await googleLogOut();
    await FacebookAuth.instance.logOut();
    emit(state.copyWith(currentUsuario: TipoUsuario.NOT_LODGET,page: 0));
  }
  
  Future addEmpresa(Empresa empresa) async {
   final usuario = state.usuario!.copyWith(
     empresas: List.of(state.usuario!.empresas)..add(empresa.copyWith(urlLogo: '${empresa.id}_logo_empresa.jpg'))
   );
   emit(state.copyWith(usuario: usuario));
  }
}
