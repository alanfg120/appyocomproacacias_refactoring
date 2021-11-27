import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences? _prefs;

  Future<void> initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  set token(String token) => this._prefs!.setString('token', token);
  String get token => this._prefs!.getString('token') ?? '';

  set idUsuario(int idUsuario) => this._prefs!.setInt('id_usuario', idUsuario);
  int get idUsuario => this._prefs!.getInt('id_usuario') ?? -1;

  eraseall() {
    this._prefs!.clear();
  }
}
