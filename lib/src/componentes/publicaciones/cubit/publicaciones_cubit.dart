import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/data/publicaciones.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/cometario.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/like.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'publicaciones_state.dart';

class PublicacionesCubit extends Cubit<PublicacionesState> {

  final PublicacionesRepositorio repositorio;
  final PreferenciasUsuario prefs;
  PublicacionesCubit({Key? key,required this.repositorio, required this.prefs})
      : super(PublicacionesState.initial());

  Future<void> getInitiData() async {
    if (!state.initialDataloaded) {
      await this.getPublicaciones();
    }
  }

  Future addPublicacion(
      Publicacion publicacion, List<ImageFile> imagenes) async {
    emit(state.copyWith(loadingAdd: true));
    final response = await repositorio.addPublicacion(publicacion, imagenes,
        onProgress: (total) => _onProgress(total));
    if (response is ResponsePublicaciones) {
      final newPubllicacion =
          publicacion.copyWith(id: response.idNewPublicacion);
      emit(state.copyWith(
          publicaciones: List.of(state.publicaciones)
            ..insert(0, newPubllicacion),
          loadingAdd: false));
    }
    if (response is ErrorResponseHttp) {
      print(response.getError);
      emit(state.copyWith(loadingAdd: false));
    }
  }

  Future updatePublicacion(Publicacion publicacion, List<ImageFile> imagenes,
      String url, bool isEmpresa) async {
    emit(state.copyWith(loadingAdd: true));
    final response = await repositorio.updatePublicacion(publicacion, imagenes,
        onProgress: (total) => _onProgress(total));
    if (response is ResponsePublicaciones) {
      if (response.update!) {
        for (var i = 0; i < publicacion.imagenes.length; i++) {
          await CachedNetworkImage.evictFromCache(
              '$url/galeria/${publicacion.imagenes[i]}');
        }
        if (isEmpresa) {
          final index = _getIndexPublicacion(publicacion.id!, true);
          emit(state.copyWith(
              publicacionesByEmpresa: List.of(state.publicaciones)
                ..removeAt(index)
                ..insert(index, publicacion),
              loadingAdd: false));
          _updatePublicacionList(publicacion);
        }
        if (!isEmpresa) {
          _updatePublicacionList(publicacion);
        }
      }
    }
    if (response is ErrorResponseHttp) {
      print(response.getError);
      emit(state.copyWith(loadingAdd: false));
    }
  }

  Future deletePublicacion(int idPublicacion, [bool isEmpresa = false]) async {
    emit(state.copyWith(loadingDelete: true));
    final response = await repositorio.deletePublicacion(idPublicacion);
    if (response is ResponsePublicaciones) {
      if (isEmpresa) {
        final index = _getIndexPublicacion(idPublicacion, isEmpresa);
        emit(state.copyWith(
            publicacionesByEmpresa: List.of(state.publicacionesByEmpresa)
              ..removeAt(index),
            loadingDelete: false));
        _deletePublicacionList(idPublicacion);
      }
      if (!isEmpresa) {
        _deletePublicacionList(idPublicacion);
        emit(state.copyWith(loadingDelete: false));
      }
    }
    if (response is ErrorResponseHttp) {
      print(response.getError);
    }
  }

  Future getPublicacionesEmpresa(int idEmpresa) async {
    if (state.idEmpresa != idEmpresa) {
      emit(state.copyWith(loading: true));
      final response = await repositorio.getPublicacionesByEmpresa(
          idEmpresa, prefs.idUsuario);
      if (response is ResponsePublicaciones) {
        emit(state.copyWith(
          publicacionesByEmpresa: response.publicaciones,
          idEmpresa: idEmpresa,
          loading: false,
        ));
      }
      if (response is ErrorResponseHttp) {
        print(response.getError);
      }
    }
  }

  Future<void> addLike(int idPublicacion, int idUsuarioDestinatario,
      bool isEmpresa, Usuario usuario) async {
    emit(state.copyWith(loadingLike: true));
    final response = await repositorio.meGustaPublicacion(
        idPublicacion, prefs.idUsuario, idUsuarioDestinatario);
    if (response is ResponsePublicaciones) {
      _addlike(usuario, isEmpresa, idPublicacion);
    }
  }

  Future<void> deleteLike(int idPublicacion, int idUsuarioDestinatario,
      bool isEmpresa, Usuario usuario) async {
    emit(state.copyWith(loadingLike: true));
    final response =
        await repositorio.noMeGustaPublicacion(idPublicacion, prefs.idUsuario);
    if (response is ResponsePublicaciones) {
      _deletelike(usuario, isEmpresa, idPublicacion);
    }
  }

  Future<void> getPublicaciones() async {
    final response =
        await repositorio.getPublicaciones(state.pagina, prefs.idUsuario);
    if (response is ResponsePublicaciones)
      emit(state.copyWith(
          publicaciones: List.of(state.publicaciones)
            ..addAll(response.publicaciones!),
          pagina: state.pagina + 1,
          initialDataloaded: true,
          loading: false));
  }

  Future<void> getNewPublicaciones() async {
    final response = await repositorio.getPublicaciones(0, prefs.idUsuario);
    if (response is ResponsePublicaciones)
      emit(state.copyWith(publicaciones: response.publicaciones!, pagina: 1));
  }

  Future<void> comentar(
      {required String comentario,
      required int idPublicacion,
      required int idDestinatario,
      required Usuario usuario,
      required bool isEmpresa}) async {
    emit(state.copyWith(loadingComentario: true));
    final response = await repositorio.comentarPublicacion(
        comentario, idPublicacion, prefs.idUsuario, idDestinatario);
    if (response is ResponsePublicaciones) {
      if (response.comento!) {
        _addComentario(comentario, usuario, isEmpresa, idPublicacion);
      }
    }
  }


  tabChangePagina(int pagina)  => emit(state.copyWith(pagina: pagina));

  Future getPublicacionById(int idPublicacion, NotificacionTipo tipo) async {
    emit(state.copyWith(loading: true));
    final response = await repositorio.getPublicacionById(idPublicacion);
    if (response is ResponsePublicaciones) {
      emit(state.copyWith(
          publicacion: response.publicacion,
          loading: false,
          pagina: _getPagina(tipo)));
    }
    if (response is ErrorResponseHttp) {
      print(response.getError);
    }
  }

  _addlike(Usuario usuario, bool isEmpresa, int idPublicacion) {
    if (isEmpresa) {
      final index = _getIndexPublicacion(idPublicacion, isEmpresa);
      state.publicacionesByEmpresa[index].usuariosLike.add(
          LikePublicacion(fecha: DateTime.now().toString(), usuario: usuario));
      state.publicacionesByEmpresa[index] =
          state.publicacionesByEmpresa[index].copyWith(megusta: true);
      _updateLikePublicacion(idPublicacion, usuario, true);
    }
    if (!isEmpresa) {
      _updateLikePublicacion(idPublicacion, usuario, true);
    }
    emit(state.copyWith(
        loadingLike: false,
        publicacionesByEmpresa: state.publicacionesByEmpresa,
        publicaciones: state.publicaciones));
  }

  _deletelike(Usuario usuario, bool isEmpresa, int idPublicacion) {
    if (isEmpresa) {
      final index = _getIndexPublicacion(idPublicacion, isEmpresa);
      final indexUsuario = _getIndexUsuario(index, usuario, isEmpresa);
      state.publicacionesByEmpresa[index].usuariosLike.removeAt(indexUsuario);
      state.publicacionesByEmpresa[index] =
          state.publicacionesByEmpresa[index].copyWith(megusta: false);
      _updateLikePublicacion(idPublicacion, usuario, false);
    }
    if (!isEmpresa) {
      _updateLikePublicacion(idPublicacion, usuario, false);
    }
    emit(state.copyWith(
        loadingLike: false,
        publicaciones: state.publicaciones,
        publicacionesByEmpresa: state.publicacionesByEmpresa));
  }

  _addComentario(
      String comentario, Usuario usuario, bool isEmpresa, int idPublicacion) {
    final index = _getIndexPublicacion(idPublicacion, isEmpresa);
    if (isEmpresa) {
      state.publicacionesByEmpresa[index].comentarios.insert(
          0,
          Comentario(
              comentario: comentario,
              usuario: usuario,
              fecha: DateTime.now().toString()));
      _updateComentario(idPublicacion, comentario, usuario);
    }
    if (!isEmpresa) {
      _updateComentario(idPublicacion, comentario, usuario);
    }
    emit(state.copyWith(
        publicaciones: state.publicaciones,
        publicacionesByEmpresa: state.publicacionesByEmpresa,
        loadingComentario: false));
  }

  int _getIndexPublicacion(int idPublicacion, bool isEmpresa) {
    if (isEmpresa)
      return state.publicacionesByEmpresa
          .indexWhere((p) => p.id == idPublicacion);
    else
      return state.publicaciones.indexWhere((p) => p.id == idPublicacion);
  }

  int _getIndexUsuario(int index, Usuario usuario, bool isEmpresa) {
    if (isEmpresa)
      return state.publicacionesByEmpresa[index].usuariosLike
          .indexWhere((e) => e.usuario.id == usuario.id);
    else
      return state.publicaciones[index].usuariosLike
          .indexWhere((e) => e.usuario.id == usuario.id);
  }

  _updateLikePublicacion(int idPublicacion, Usuario usuario, bool add) {
    final index = _getIndexPublicacion(idPublicacion, false);
    if (index != -1 && add) {
      state.publicaciones[index].usuariosLike.add(
          LikePublicacion(fecha: DateTime.now().toString(), usuario: usuario));
      state.publicaciones[index] =
          state.publicaciones[index].copyWith(megusta: true);
    }
    if (index != -1 && !add) {
      final indexUsuario = _getIndexUsuario(index, usuario, false);
      state.publicaciones[index].usuariosLike.removeAt(indexUsuario);
      state.publicaciones[index] =
          state.publicaciones[index].copyWith(megusta: false);
    }
  }

  _updateComentario(int idPublicacion, String comentario, Usuario usuario) {
    final index = _getIndexPublicacion(idPublicacion, false);
    if (index != -1) {
      state.publicaciones[index].comentarios.insert(
          0,
          Comentario(
              comentario: comentario,
              usuario: usuario,
              fecha: DateTime.now().toString()));
    }
  }

  _deletePublicacionList(int idPublicacion) {
    final index = _getIndexPublicacion(idPublicacion, false);
    if (index != -1) {
      emit(state.copyWith(
          publicaciones: List.of(state.publicaciones)..removeAt(index)));
    }
  }

  _updatePublicacionList(Publicacion publicacion) {
    final index = _getIndexPublicacion(publicacion.id!, false);
    if (index != -1)
      emit(state.copyWith(
          publicaciones: List.of(state.publicaciones)
            ..removeAt(index)
            ..insert(index, publicacion),
          loadingAdd: false));
  }

  _onProgress(double progress) async {
    emit(state.copyWith(progress: progress));
  }

  int? _getPagina(NotificacionTipo tipo) {
    if (tipo == NotificacionTipo.MEGUSTA) return 1;
    if (tipo == NotificacionTipo.COMENTARIO) return 0;
  }
}
