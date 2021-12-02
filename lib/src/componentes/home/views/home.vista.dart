
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/views/categorias.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/cubit/inicio.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/views/inicio.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/views/login.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/views/tienda.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/views/publicaciones.page.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/views/usuario.view.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeState>(
           builder: (contex,state) {
                      return Scaffold(
                             body     : IndexedStack(
                                        index    : state.page,
                                        children : <Widget>[
                                                   if(state.currentUsuario == TipoUsuario.ANONYMOUS || state.currentUsuario == TipoUsuario.NOT_LODGET) 
                                                   LoginPage(),
                                                   InicioPage(),
                                                   if(state.currentUsuario == TipoUsuario.LODGET)
                                                   TiendaPage(),
                                                   PublicacionesPage(),
                                                   CategoriasPage(),
                                                   if(state.currentUsuario == TipoUsuario.LODGET)
                                                   UsuarioOptios()
                                                  ],
                                        ),
                                        bottomNavigationBar: _buttomBarNavigator(state,context)
          );
        });
  }

  _buttomBarNavigator (HomeState state, BuildContext context) {
      return BottomNavyBar(
             backgroundColor : Theme.of(context).primaryColor,
             selectedIndex   : state.page,
             showElevation   : false,
             onItemSelected  : (index) => _selectPage(context,index),
             items           : <BottomNavyBarItem>[
                                 if(state.currentUsuario == TipoUsuario.ANONYMOUS || state.currentUsuario == TipoUsuario.NOT_LODGET)  
                                 BottomNavyBarItem(
                                 icon        : const Icon(Icons.login_rounded),
                                 title       : const Text('Ingresar'),
                                 activeColor : Colors.white,
                                 textAlign   : TextAlign.center
                                 ),
                                 BottomNavyBarItem(
                                 icon        : const Icon(Icons.home),
                                 title       : const Text('Inicio'),
                                 activeColor : Colors.white,
                                 textAlign   : TextAlign.center
                                 ),
                                 if(state.currentUsuario == TipoUsuario.LODGET)
                                 BottomNavyBarItem(
                                 icon        : const Icon(Icons.shopping_bag_outlined),
                                 title       : const Text('Tienda'),
                                 activeColor : Colors.white,
                                 textAlign   : TextAlign.center
                                 ),
                                 BottomNavyBarItem(
                                 icon        : const Icon(Icons.message),
                                 title       : const Text('Publicaciones',style: TextStyle(fontSize: 11)),
                                 activeColor : Colors.white,
                                 textAlign   : TextAlign.center
                                 ),
                                 BottomNavyBarItem(
                                 icon        : const Icon(Icons.list),
                                 title       : const Text('Categorias',style: TextStyle(fontSize: 11)),
                                 activeColor : Colors.white,
                                 textAlign   : TextAlign.center
                                 ),
                                 if(state.currentUsuario == TipoUsuario.LODGET)
                                 BottomNavyBarItem(
                                 icon        : const Icon(Icons.settings),
                                 title       : const Text('Opciones'),
                                 activeColor : Colors.white,
                                 textAlign   : TextAlign.center
                                 ), 
            ],
    );
  }

  _selectPage(BuildContext context, int index) {
   final homeCubit =  context.read<HomeCubit>()..selectPage(index);
   final usuario = homeCubit.state.currentUsuario;
   if(usuario == TipoUsuario.ANONYMOUS || usuario == TipoUsuario.NOT_LODGET){
     if(index == 1) context.read<InicioCubit>().getDataInitial(homeCubit.state.currentUsuario);
     if(index == 2) context.read<PublicacionesCubit>().getInitiData();
   }
   if(usuario == TipoUsuario.LODGET){
     if(index == 0) context.read<InicioCubit>().getDataInitial(homeCubit.state.currentUsuario);
     if(index == 1) context.read<ProductosBloc>().add(GetProductosEvent());
     if(index == 2) context.read<PublicacionesCubit>().getInitiData();
   }
  }

}
