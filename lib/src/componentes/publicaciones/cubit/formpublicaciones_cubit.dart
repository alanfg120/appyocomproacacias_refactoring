import 'dart:io';

import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'formpublicaciones_state.dart';

class FormPublicacionesCubit extends Cubit<FormPublicacionesState> {
  
  FormPublicacionesCubit() : super(FormPublicacionesState.initial());


  getDataPublicacionUpdate(Publicacion publicacion,List<Empresa> empresas){
   
    final index = empresas.indexWhere((empresa) => publicacion.empresa.id == empresa.id);
    emit(state.copyWith(
         empresa  : publicacion.empresa,
         selecionada: index,
         imagenes : publicacion.imagenes.map((e) => ImageFile(nombre: e,isaFile: false)).toList()
    ));
  }
  selectEmpresa(Empresa empresa, int index) =>
      emit(state.copyWith(empresa: empresa, selecionada: index));

  setImagenes(List<ImageFile>? imagenes) =>
      emit(state.copyWith(imagenes: imagenes));

  addImagen(File file) {
    emit(state.copyWith(
        imagenes: List.of(state.imagenes)
          ..add(ImageFile(nombre: '${Uuid().v4()}.jpg', file: file, isaFile: true))));
  }
  
  updateImagen(File file, ImageFile? imagen, int index) async {
    emit(state.copyWith(
        imagenes: List.of(state.imagenes)
          ..removeAt(index)
          ..insert(
              index,
              ImageFile(
                  nombre: state.imagenes[index].nombre,
                  file: file,
                  isaFile: true))));
    if (imagen!.isaFile) {
      if(await imagen.file!.exists())
      imagen.file!.delete();
    }
  }

  Future deleteFiles() async {
    state.imagenes.forEach((imagen) async { 
       await imagen.file!.delete();
    });
  }

  
}
