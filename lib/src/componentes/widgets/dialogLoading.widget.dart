
import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/progressLoading/cubit/progress_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void dialogLoading(BuildContext context,String title,[bool progress = false]) {
    showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_){
      return AlertDialog(
             title           : Text(title,textAlign: TextAlign.center),
             titleTextStyle  : TextStyle(color: Colors.white, fontSize: 25),
             elevation       : 0,
             backgroundColor : Colors.transparent,
             content         : progress
                               ? BlocBuilder<ProgressCubit, ProgressState>(
                                 bloc   : ProgressCubit(context.read<PublicacionesCubit>(),context.read<ProductosBloc>()),
                                 builder: (context, state) {
                                   return SizedBox(
                                          height : 40,
                                          child  : Center(
                                                   child: LinearPercentIndicator(
                                                          width           : 240.0,
                                                          lineHeight      : 14.0,
                                                          percent         : state.progress,
                                                          backgroundColor : Colors.white,
                                                          progressColor   : Colors.blue,
                                                          center          : Text('${(state.progress * 100).round()}%',
                                                                            style: TextStyle(
                                                                                   color: state.progress < 50
                                                                                          ? Colors.black
                                                                                          : Colors.white
                                                                            )
                                                          ),
                                                   ),
                                          ),
                                  );
                                 },
                               )
                               : SizedBox(
                                 height : 40,
                                 child  : Center(
                                          child: CircularProgressIndicator(
                                          backgroundColor: Theme.of(context).accentColor,
                                 )
                               ),
             ),

      );
    }
    );
  }