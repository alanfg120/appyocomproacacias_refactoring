

import 'dart:js';

import 'package:appyocomproacacias_refactoring/src/componentes/empresas/views/perfil.empresa.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/data/publicaciones.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/widget/imagenes.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetalleNotificacion extends StatelessWidget {
  
  final Notificacion notification;
  const DetalleNotificacion({Key? key,required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
                   title: _getTitulo(notification.tipo),
                   elevation: 0,
           ), 
           body  : _getContent(notification.tipo),
    );
  }

 Widget? _getTitulo(NotificacionTipo tipo) {
   if(tipo == NotificacionTipo.MEGUSTA || tipo == NotificacionTipo.COMENTARIO)
    return const Text('Publicacion');
   if(tipo == NotificacionTipo.CALIFICACION)
    return const Text('Calificaciones');
   if(tipo == NotificacionTipo.MENSAJE)
    return const Text('Mensaje');
 }

 Widget? _getContent(NotificacionTipo tipo)  {
    if(tipo == NotificacionTipo.MEGUSTA || tipo == NotificacionTipo.COMENTARIO){
       final bloc = PublicacionesCubit(repositorio: PublicacionesRepositorio(),prefs: PreferenciasUsuario());
       return BlocProvider(
              create: (context) => bloc..getPublicacionById(notification.idPublicacion!),
              child: _Publicacion(),
       );
     }
  }
}

class _Publicacion extends StatelessWidget {

  const _Publicacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicacionesCubit,PublicacionesState>(
              builder  : (context,state){
              if(state.loading)
                return Center(child: CircularProgressIndicator());
              return SingleChildScrollView(
                     child: Column(
                            children: [

                            ],
                     ),
              );
    
              },
       );
  }
}

class _CardPublicacion extends StatelessWidget {

  final Publicacion publicacion;
  const _CardPublicacion({Key? key,required this.publicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Card(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
             elevation: 0,
             margin : EdgeInsets.all(4),
             child  : Column(
                      children: <Widget>[
                               _Header(publicacion: publicacion),
                               _Contenido(texto:publicacion.texto),
                               if(publicacion.imagenes.length > 0)
                               GestureDetector(
                               child  :Hero(tag:publicacion.id!,child: _imagenprincipal(publicacion.imagenes[0])),
                               onTap : (){
                                 NavigationService().navigateToRoute(
                                   MaterialPageRoute(
                                   builder: (context) =>  ImagenesWidgetPage(
                                                          imagenes : publicacion.imagenes,
                                                          id       : publicacion.id!
                                   ))
                                 );
                               },
                               ),
                               //if(publicacion.imagenes.length > 1)
                               //_imagenes(publicacion.imagenes),
                      ],
             ),
             );
  }
  Widget _imagenprincipal(String imagen) {
    return SizedBox(
           height : 300,
           width  : .height,
           child  : CachedNetworkImage(
                    imageUrl    : '$urlImagenLogo/galeria/$imagen',
                    placeholder : (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget : (context, url, error) => Icon(Icons.error),
                    fit         : BoxFit.cover,
           ),
    );
}

}

class _Header extends StatelessWidget {

  final Publicacion publicacion;
  
  const _Header({Key? key,required this.publicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return   GestureDetector(
           child: ListTile(
                  contentPadding : EdgeInsets.all(4),
                  leading        : publicacion.empresa.urlLogo == '' 
                                   ? CircleAvatar(backgroundImage: AssetImage('assets/imagenes/logo_no_img.png'))
                                   : CircleAvatar(
                                   radius: 24,
                                   backgroundImage: CachedNetworkImageProvider('$url/logo/${publicacion.empresa.urlLogo}'),    
                  ),
                  title          : Text(
                                   publicacion.empresa.nombre,
                                   style:TextStyle(fontWeight:FontWeight.bold)
                                  ),
                  subtitle       : Text(publicacion.formatFecha()),
           ),
           onTap: ()=> NavigationService().navigateToRoute(
                       MaterialPageRoute(builder: (context) => PerfilEmpresaPage(empresa: publicacion.empresa))
           )
          
  );
  }
}

class _Contenido extends StatelessWidget {
  final String texto;
  const _Contenido({Key? key,required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return  Container(
              alignment : Alignment.topLeft,
              padding   : EdgeInsets.all(8),
              child     : Text(texto),
      );
  }
}