
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/cubit/perfil_empresa_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/widgets/calificaciones.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/widgets/mensaje.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/widgets/publicacion.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/data/publicaciones.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
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
       final bloc = PublicacionesCubit(key: ValueKey<int>(0),repositorio: PublicacionesRepositorio(),prefs: PreferenciasUsuario());
       return BlocProvider(
              create: (context) => bloc..getPublicacionById(notification.idPublicacion!,tipo),
              child: PublicacionWidget(),
       );
     }
    if(tipo == NotificacionTipo.CALIFICACION){
       final bloc = PerfilEmpresaCubit(repositorio: EmpresaRepositorio(),prefs: PreferenciasUsuario());
       return BlocProvider(
              create: (context) => bloc..getEmpresaByid(notification.idEmpresa!),
              child: CalificacionesWidget(),
       );
     }
    if(tipo == NotificacionTipo.MENSAJE){
       return MensajePage(mensaje: notification.mensaje, fecha: notification.fecha);
    }
  }
}

 