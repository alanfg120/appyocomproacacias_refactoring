import 'dart:io';

import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/categoriaProducto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'formproductos_state.dart';

class FormProductosCubit extends Cubit<FormProductosState> {
  FormProductosCubit() : super(FormProductosState.initial());

  addImagen(File file) {
    emit(state.copyWith(
        imagenes: List.of(state.imagenes)
          ..add(ImageFile(
              nombre: '${Uuid().v4()}.jpg', file: file, isaFile: true))));
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
      if (await imagen.file!.exists()) imagen.file!.delete();
    }
  }

  selectOferta(bool value) => emit(state.copyWith(oferta: value));

  selectEmpresa(Empresa empresa, int index) =>
      emit(state.copyWith(empresa: empresa, empresaSelecionada: index));

  selectCategoria(CategoriaProducto categoria, int index) =>
      emit(state.copyWith(categoria: categoria, categoriaSelecionada: index));
  
  getDataUpdate(Producto producto,List<Empresa> empresas,List<CategoriaProducto> categorias){
     final indexEmpresa   = empresas.indexWhere((e) => e.id == producto.empresa.id);
     final indexCategoria = categorias.indexWhere((c) => c.id == producto.categoria.id);
     emit(state.copyWith(
       empresa: producto.empresa,
       categoria: producto.categoria,
       oferta:  producto.oferta,
       empresaSelecionada: indexEmpresa,
       categoriaSelecionada: indexCategoria,
       imagenes: producto.imagenes.map((p) => ImageFile(nombre: p,isaFile: false)).toList() 
     ));

   }   
}
