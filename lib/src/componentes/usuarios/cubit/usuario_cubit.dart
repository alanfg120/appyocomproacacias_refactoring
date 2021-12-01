import 'dart:io';

import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/data/usuario.repository.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'usuario_state.dart';

class UsuarioCubit extends Cubit<UsuarioState> {
  final Usuario usuario;
  final UsuarioRepocitorio repocitorio;
  UsuarioCubit({required this.usuario, required this.repocitorio})
      : super(UsuarioState.initial(usuario));

  Future updateImagen(int idUsuario, File file, String nombre) async {
    final response = await repocitorio.updateImagen(file.path, idUsuario);
    if (response is UsuarioResponse) {
      if (response.update!) {
        final usuario = state.usuario.copyWith(
            imagen: ImageFile(nombre: nombre, file: file, isaFile: true));
        emit(state.copyWith(usuario: usuario));
      }
    }
  }

  Future updatePassword(String currentPassword,String newPassword) async {
    final response = await repocitorio.updatePassword(state.usuario.id, currentPassword, newPassword);
    if(response is UsuarioResponse){
      if(response.update!){
       emit(state.copyWith(updatePassword: true));
      }
    }
    if(response is ErrorResponseHttp){
       print(response.getError);
       emit(state.copyWith(error: ErrorResponseUsuario.PASS_INVALID));
       
    }
    await Future.delayed(Duration(seconds: 3));
    emit(state.copyWith(updatePassword: false,error: ErrorResponseUsuario.NO_ERROR));
  }

  Future updateDataUsuario(Map<String,dynamic> update) async {
    final response = await repocitorio.updateData(state.usuario.id,update);
    if(response is UsuarioResponse){
      if(response.update!){
       final usuario = state.usuario.copyWith(nombre: update['nombre'],email: update['usuario']);
       emit(state.copyWith(updateData: true,usuario: usuario));
      }
    }
    if(response is ErrorResponseHttp){
       emit(state.copyWith(error: ErrorResponseUsuario.DATA_ERROR));
    }
    emit(state.copyWith(updateData: false));
  }

  Future sendResponse(int motivo,String detalle) async {
   emit(state.copyWith(loading: true));
   final response = await repocitorio.sendReporte(state.usuario.id, motivo, detalle);
   if(response is UsuarioResponse){
     if(response.sendReporte!){
        emit(state.copyWith(loading: false));
     }
   }
   if(response is ErrorResponseHttp){
     print(response.getError);
      emit(state.copyWith(loading: false));
   }
  }

  Future updateUsuario(Usuario usuario) async => emit(state.copyWith(usuario: usuario));
}
