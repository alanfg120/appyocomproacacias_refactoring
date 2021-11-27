import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.state.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           body: BlocConsumer<HomeCubit,HomeState>(
             listener: (context,state){
               if(!state.offline)
                 NavigationService().navigateToReplacement('home');
             },
             builder:(context,state) =>Center(
                   child: state.loading
                          ? CircularProgressIndicator()
                          : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/imagenes/desconectado.png',
                            height : 100,
                            width  : 100,
                            ),
                            SizedBox(height: 8),
                            const Text('Sin conexion'),
                            SizedBox(height: 8),
                            ElevatedButton(
                            onPressed : () => BlocProvider.of<HomeCubit>(context).validateInternet(), 
                            child     : const Text('Reintentar'),
                            style     : ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor
                            ),
                            )
                          ],
               )
             ),
           ),
    );
  }
}