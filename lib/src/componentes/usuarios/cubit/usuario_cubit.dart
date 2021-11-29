import 'dart:io';

import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
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
}
