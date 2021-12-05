import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final PublicacionesCubit publicacionesCubit;
  final ProductosBloc productosBloc;
  
  ProgressCubit(this.publicacionesCubit,this.productosBloc) : super(ProgressState.initial()){
    publicacionesCubit.stream.listen((state) {
      if(state.progress > 0) 
        _onProgress(state.progress);
    });
    productosBloc.stream.listen((state) {
      if(state.progress > 0) 
        _onProgress(state.progress);
    });
  }

  _onProgress(double progress) async {
    await Future.delayed(Duration(milliseconds: 200));
    emit(state.copyWith(progress: progress));
  }
}
