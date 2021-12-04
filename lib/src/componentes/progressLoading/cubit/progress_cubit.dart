import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final PublicacionesCubit publicacionesCubit;

  
  ProgressCubit(this.publicacionesCubit) : super(ProgressState.initial()){
    publicacionesCubit.stream.listen((state) {
      if(state.progress > 0) 
        _onProgress(state.progress);
    });
  }

  _onProgress(double progress) async {
    await Future.delayed(Duration(milliseconds: 200));
    emit(state.copyWith(progress: progress));
  }
}
