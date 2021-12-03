
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/views/formPublicacion.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/widget/loadingPublicaciones.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/widget/publicacion.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicacionesPage extends StatefulWidget {
  const PublicacionesPage({Key? key}) : super(key: key);

  @override
  _PublicacionesPageState createState() => _PublicacionesPageState();
}

class _PublicacionesPageState extends State<PublicacionesPage> {

  ScrollController _controller = ScrollController();
  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    if(_controller.hasClients)
     _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   

    final homeState = context.read<HomeCubit>().state;
    final usuario = homeState.currentUsuario;
    final urlImagenes = homeState.url;

    return  Scaffold(
            body :  SafeArea(
                    top: false,
                    child: RefreshIndicator(
                            onRefresh: () async => context.read<PublicacionesCubit>().getNewPublicaciones(),
                            child    : CustomScrollView(
                                       controller : _controller,
                                       slivers    : <Widget>[
                                                    appBarSliver(),
                                                    listPublicaciones(context,urlImagenes,usuario)
                                       ],
                            ),
                     ),
            ),
            backgroundColor: Colors.grey[300],
            floatingActionButton: usuario == TipoUsuario.LODGET
                                  ? FloatingActionButton.extended(
                                    heroTag         : 'publicar',
                                    backgroundColor : Theme.of(context).primaryColor,
                                    label           : Text('Publicar',style: TextStyle(color: Colors.white)),
                                    icon            : Icon(Icons.add,color: Colors.white),
                                    onPressed       : () => NavigationService().navigateToRoute(
                                                            MaterialPageRoute(builder: (context) => FormPublicacionPage())
                                    ),
                                    )
                                  : null

     );
  }
  Widget  appBarSliver() {
  return  SliverAppBar(
          leading         : Image.asset('assets/imagenes/logo.png'),
          title           : Text('Publicaciones',style:TextStyle(color: Colors.black)),
          floating        : true,
          brightness      : Brightness.light,
          backgroundColor : Colors.white
          //pinned: true,
          );
}

  listPublicaciones(context,String url,TipoUsuario usuario) {
   return  BlocConsumer<PublicacionesCubit, PublicacionesState>(
           buildWhen: (previusState,state) => previusState.progress == state.progress,
           listener: (context,state){
             if(state.pagina > 1)
              _controller.animateTo(
                          _controller.position.pixels + 200,
                          duration : Duration(milliseconds: 500), 
                          curve    : Curves.easeIn
              );
           },
           builder: (context, state) {
             if(state.loading)
               return PublicacionesLoading();
             return SliverPadding(
                    padding: EdgeInsets.all(4),
                    sliver : SliverList(
                             delegate: SliverChildBuilderDelegate(
                                       (context,i){
                                          if(i == state.publicaciones.length ){
                                               return Center(
                                                      child: Container(
                                                             padding : EdgeInsets.all(10),
                                                             child   : CircularProgressIndicator(),
                                                             )
                                                 );
                                          }
                                          return PublicacionCard(
                                                 publicacion : state.publicaciones[i],
                                                 url         : url,
                                                 usuario     : usuario,
                                          );
                                       },
                                       childCount: state.publicaciones.length + 1, 
                             )
              ),
      );
     },
   );
  }

   _scrollListener() {
   if (_controller.position.pixels == _controller.position.maxScrollExtent){
       context.read<PublicacionesCubit>().getPublicaciones();
   }
     
  }
}