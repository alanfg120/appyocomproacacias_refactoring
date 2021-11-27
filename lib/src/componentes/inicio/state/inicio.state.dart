import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/videos.model.dart';
import 'package:equatable/equatable.dart';

class InicioState extends Equatable {

  final bool loading, initialDataLoaded;
  final List<YouTubeVideoView> videos;
  final List<Empresa> empresas;
  final List<Notificacion> notificaciones;
  final int notificacionesNoLeidas;

  InicioState(
     {required this.loading,
      required this.videos,
      required this.initialDataLoaded,
      required this.empresas,
      required this.notificaciones,
      required this.notificacionesNoLeidas});

  factory InicioState.initial() =>
      InicioState(
      loading                : true, 
      videos                 : [],
      empresas               : [], 
      notificaciones         : [],
      notificacionesNoLeidas : 0,
      initialDataLoaded      : false
  );

  InicioState copyWith(
          {bool? loading,
           List<YouTubeVideoView>? videos,
           List<Empresa>? empresas,
           List<Notificacion>? notificaciones,
           int? notificacionesNoLeidas,
           bool? initialDataLoaded}) {
             return InicioState(
                    loading                : loading                ?? this.loading,
                    videos                 : videos                 ?? this.videos,
                    empresas               : empresas               ?? this.empresas,
                    notificaciones         : notificaciones         ?? this.notificaciones,
                    notificacionesNoLeidas : notificacionesNoLeidas ?? this.notificacionesNoLeidas,
                    initialDataLoaded      : initialDataLoaded      ?? this.initialDataLoaded
             );
          }


  @override
  List<Object?> get props 
   => [
       loading, 
       videos,
       initialDataLoaded,
       empresas,
       notificaciones,
       notificacionesNoLeidas
     ];
}
