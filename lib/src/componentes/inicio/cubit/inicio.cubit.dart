import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/data/inicio.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/inicioReesponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/models/notificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/state/inicio.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/ErrorResponse.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';

class InicioCubit extends Cubit<InicioState> {
  final InicioRepositorio repocitorio;
  final PreferenciasUsuario prefs;
  InicioCubit({required this.repocitorio, required this.prefs})
      : super(InicioState.initial());

  leerNotificacion(int idNotificacion) async {
    final response = await repocitorio.leerNotificacion(idNotificacion);
    if (response is InicioResponse) {
      if (response.leida!) {
        final index =
            state.notificaciones.indexWhere((n) => n.id == idNotificacion);
        final newNotificacion =
            state.notificaciones[index].copyWith(leida: true);
        emit(state.copyWith(
            notificaciones: List.of(state.notificaciones)
              ..removeAt(index)
              ..insert(index, newNotificacion),
            notificacionesNoLeidas: state.notificacionesNoLeidas - 1
        )
        );
      }
    }
  }

  getDataInitial(TipoUsuario typeUsuario) async {
    if (!state.initialDataLoaded && typeUsuario == TipoUsuario.ANONYMOUS ||
        typeUsuario == TipoUsuario.NOT_LODGET) {
      await this._getVideos();
      await this._getTopEmpresas();
    }
    if (!state.initialDataLoaded && typeUsuario == TipoUsuario.LODGET) {
      await this._getVideos();
      await this._getTopEmpresas();
      await this._getNotificaciones();
    }
    if (state.initialDataLoaded && typeUsuario == TipoUsuario.LODGET) {
      await this._getNotificaciones();
    }
  }

  Future _getVideos() async {
    final response = await this.repocitorio.getVideosYoutbe();
    if (response is InicioResponse) {
      emit(state.copyWith(videos: response.videos));
    }
    if (response is ErrorResponse) {
      print(response.error);
    }
  }

  Future _getTopEmpresas() async {
    final response = await repocitorio.getTop10Empresas();
    if (response is InicioResponse) {
      emit(state.copyWith(
          empresas: response.empresas,
          loading: false,
          initialDataLoaded: true));
    }
  }

  Future _getNotificaciones() async {
    final response = await repocitorio.getNotificaciones(prefs.idUsuario);
    if (response is InicioResponse) {
      emit(state.copyWith(
          notificaciones: response.notificaciones,
          notificacionesNoLeidas:
              this._getNumberNotificaciones(response.notificaciones!)));
    }
    if (response is ErrorResponseHttp) {
      print(response.getError);
    }
  }

  int _getNumberNotificaciones(List<Notificacion> notificaciones) {
    if (notificaciones.length > 0)
      return notificaciones
          .map((e) => e.leida == false ? 1 : 0)
          .reduce((value, elemento) => value + elemento);
    return 0;
  }

  /* void _inicialPushNotificacitions() async {
    
    final pushNotification = PushNotification();
    pushNotification.init();

    pushNotification.onMesaje().onData((data) {
      //this.notificacionesNoLeidas++;
      //this.getNotificaciones();
    });

    pushNotification.onOpenApp().onData((message) {
      //final tipo = Notificacion.getTipo(message.data['tipo']);
      //final int idTipo = int.parse(message.data['id_tipo']);
      // this._onOpenAppNotification(tipo, idTipo, message.notification.body);
      //this.notificacionesNoLeidas++;
      //this.getNotificaciones();
    });
    pushNotification.onBackground().then((message) {
      if (message?.data != null) {
        final tipo = Notificacion.getTipo(message!.data['tipo']);
        final int idTipo = int.parse(message.data['id_tipo']);
       // this._onOpenAppNotification(tipo, idTipo, message.notification!.body);
      }
    });
  } */

}
