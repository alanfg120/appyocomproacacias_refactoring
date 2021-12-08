import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/videos.model.dart';
import 'package:equatable/equatable.dart';

class InicioState extends Equatable {

  final bool loading, initialDataLoaded;
  final List<YouTubeVideoView> videos;
  final List<Empresa> empresas;
  final List<Notificacion> notificaciones;
  final Notificacion? notificacion;
  final int notificacionesNoLeidas;
  final bool pushNoticacion;

  InicioState(
     {this.notificacion,
      required this.loading,
      required this.videos,
      required this.initialDataLoaded,
      required this.empresas,
      required this.notificaciones,
      required this.notificacionesNoLeidas,
      required this.pushNoticacion});

  factory InicioState.initial() =>
      InicioState(
      loading                : true,
      initialDataLoaded      : false,
      pushNoticacion         : false,
      videos                 : [],
      empresas               : [], 
      notificaciones         : [],
      notificacionesNoLeidas : 0,
     
  );

  InicioState copyWith(
          {bool? loading,
           List<YouTubeVideoView>? videos,
           List<Empresa>? empresas,
           List<Notificacion>? notificaciones,
           Notificacion? notificacion,
           int? notificacionesNoLeidas,
           bool? initialDataLoaded,
           bool? pushNoticacion}) {
             return InicioState(
                    loading                : loading                ?? this.loading,
                    videos                 : videos                 ?? this.videos,
                    empresas               : empresas               ?? this.empresas,
                    notificaciones         : notificaciones         ?? this.notificaciones,
                    notificacionesNoLeidas : notificacionesNoLeidas ?? this.notificacionesNoLeidas,
                    initialDataLoaded      : initialDataLoaded      ?? this.initialDataLoaded,
                    notificacion           : notificacion           ?? this.notificacion,
                    pushNoticacion         : pushNoticacion         ?? this.pushNoticacion
             );
          }


  @override
  List<Object?> get props 
   => [loading, 
       videos,
       initialDataLoaded,
       empresas,
       notificaciones,
       notificacionesNoLeidas,
       notificacion,
       pushNoticacion];
}
