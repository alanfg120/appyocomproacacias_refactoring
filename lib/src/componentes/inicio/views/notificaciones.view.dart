import 'dart:ui';


import 'package:appyocomproacacias_refactoring/src/componentes/inicio/cubit/inicio.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/state/inicio.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/views/notificacionesDetalles.view.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class NotificationPage extends StatelessWidget {


  NotificationPage({Key? key}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
                   title     : Text('Notificaciones'),
                   elevation : 0,
           ),
           body  : _notificaciones(),
    );
  }

 Widget _notificaciones() {
  return BlocSelector<InicioCubit,InicioState,List<Notificacion>>(
         selector: (state) => state.notificaciones,
         builder: (context,notificaciones){
           return ListView.builder(
             itemCount   : notificaciones.length,
             itemBuilder : (_,int i) {
                           return Ink(
                                  color : notificaciones[i].leida ? Colors.transparent : Colors.grey[200],
                                  child : ListTile(
                                          leading  : _imagenUsuario(),
                                          title    : _getTitulo(notificaciones[i]),
                                          subtitle : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      if(notificaciones[i].tipo == NotificacionTipo.MEGUSTA)
                                                         Text('${notificaciones[i].usuario!.nombre}'),
                                                      if( notificaciones[i].tipo == NotificacionTipo.COMENTARIO || 
                                                          notificaciones[i].tipo == NotificacionTipo.MENSAJE
                                                        )
                                                         Text('${notificaciones[i].mensaje}',overflow: TextOverflow.ellipsis),
                                                      if(notificaciones[i].tipo == NotificacionTipo.CALIFICACION)
                                                         Text('${notificaciones[i].mensaje}'),
                                                      Text('${notificaciones[i].formatFecha()}'),
                                                    ],
                                          ),
                                          onTap: (){

                                           NavigationService().navigateToRoute(
                                             MaterialPageRoute(builder: (context) => DetalleNotificacion(notification: notificaciones[i]))
                                           );
                                          /*   if(notificaciones[i].tipo == NotificacionTipo.COMENTARIO)
                                               Get.to(PublicacionPage(idPublicacion: notificaciones[i].idPublicacion,pagina: 0));
                                            if(notificaciones[i].tipo == NotificacionTipo.MEGUSTA)
                                               Get.to(PublicacionPage(idPublicacion: notificaciones[i].idPublicacion,pagina: 1));
                                            if(notificaciones[i].tipo == NotificacionTipo.CALIFICACION)
                                               Get.to(CalificacionesLisTPage(idEmpresa: notificaciones[i].idEmpresa));
                                            if(notificaciones[i].tipo == NotificacionTipo.MENSAJE)
                                               Get.to(MensajePage(mensaje: notificaciones[i].mensaje,fecha: notificaciones[i].formatFecha())); */
                                          },
                                  ),
                           );
                    
            },
           );
         }
  );
 }



 Widget _imagenUsuario() {
   return ClipRRect(
    borderRadius: BorderRadius.circular(300),
    child:  FadeInImage(
            height : 50,
            width  : 50,
            fit    : BoxFit.cover,
            placeholder: AssetImage('assets/imagenes/load_image.gif'), 
            image: AssetImage('assets/imagenes/logo_no_img.png')
            ),
   );
 }

 Widget _getTitulo(Notificacion notificacion) {
   if(notificacion.tipo == NotificacionTipo.MEGUSTA)
      return Text(
            'Recibiste un me gusta de',
             style: TextStyle(fontWeight: FontWeight.bold)
      );
   if(notificacion.tipo == NotificacionTipo.COMENTARIO)
      return Text(
            '${notificacion.usuario!.nombre} comento',
             style: TextStyle(fontWeight: FontWeight.bold)
      );
   if(notificacion.tipo == NotificacionTipo.CALIFICACION)
      return Text(
            '${notificacion.usuario!.nombre} califico',
             style: TextStyle(fontWeight: FontWeight.bold)
      );
   if(notificacion.tipo == NotificacionTipo.MENSAJE)
      return Text(
            'Yo Compro Acaciás te envio un mensaje',
             style: TextStyle(fontWeight: FontWeight.bold)
      );
    return Container();
 }
}

