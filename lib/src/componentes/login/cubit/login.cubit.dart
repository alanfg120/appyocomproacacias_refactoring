import 'package:appyocomproacacias_refactoring/src/componentes/home/models/socialAuth.enum.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/data/login.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/models/dataRecovery.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/models/login.response.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/models/login_user.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/models/responseAuth.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/state/login.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/error.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/apple_sing.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/facebook_sing.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/google_sing_in.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/pattern.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepositorio repositorio;
  final PreferenciasUsuario prefs;

  LoginCubit({required this.repositorio, required this.prefs})
      : super(LoginState.initial());

  loginWithSocialAuth(SocialAuthType type) async {
    emit(state.copyWith(loading: true));
    final response = await _getUserWithSocialAuth(type);
    if (response.error) {
      emit(state.copyWith(
          error: ErrorLoginResponse.ERROR_SOCIAL_AUTH, loading: false));
    }
    if (!response.error) {
      await _login(response.usuario!.usuario,
          idAuth: response.usuario!.socialId);
    }
    emit(state.copyWith(error: ErrorLoginResponse.noError));
  }

  loginWithPassword(String usuario, String password) async {
    emit(state.copyWith(loading: true));
    await _login(usuario, password: password);
    emit(state.copyWith(error: ErrorLoginResponse.noError));
  }

  registreWithData(Map<String, dynamic> datos) async {
    emit(state.copyWith(loading: true));
    await _registreUser(datos);
    emit(state.copyWith(error: ErrorLoginResponse.noError));
  }

  resgistreWithSocial(SocialAuthType type) async {
    emit(state.copyWith(loading: true));
    final response = await _getUserWithSocialAuth(type);
    if (response.error) {
      emit(state.copyWith(
          error: ErrorLoginResponse.ERROR_SOCIAL_SING, loading: false));
    }
    if (!response.error) {
      final Map<String, dynamic> registro = {
        'nombre': response.usuario!.nombre,
        'usuario': response.usuario!.usuario,
      };
      final Map<String, dynamic> datos = {
        ...registro,
        ...?_getSocialdMap(type, response.usuario!.socialId)
      };
      await _registreUser(datos);
    }
    emit(state.copyWith(error: ErrorLoginResponse.noError));
  }

  sendEmailRecoveryPassWord(String correo) async {
    if (isAEmail(correo) && correo.isNotEmpty) {
      emit(state.copyWith(loadingRecovery: true));
      final response = await repositorio.sendEmailRecovery(correo);
      if (response is LoginResponseHttp) {
        emit(state.copyWith(
            loadingRecovery: false,
            isCodeSend: true,
            dataRecovery: DataRecoveryPassword(
                          idUsuario: response.idUsuario!,
                          codigoRecuperacion: response.codigoRecuperacion!,
                          token: response.token!
            )
           )
        );
      }
      if (response is ErrorResponseHttp) {
        emit(state.copyWith(
            loadingRecovery: false, error: _getTipoError(response.getError)));
      }
    }
  }

  validateCodeRecovery(String codigo) async {
    emit(state.copyWith(loadingRecovery: true));
    await Future.delayed(Duration(seconds: 3));
    if(codigo == state.dataRecovery!.codigoRecuperacion){
     emit(state.copyWith(isCodevalid: true,isCodeSend: false,loadingRecovery: false));
    }
    else emit(state.copyWith(loadingRecovery: false, error: ErrorLoginResponse.CODE_RECOVERY_INVALID));
  }

  changePassword(String password,String confirmPassword)async {
   if(password == confirmPassword){
    emit(state.copyWith(loadingRecovery: true));
    final response = await repositorio.changePassword(state.dataRecovery!,password);
    if(response is LoginResponseHttp){
       if(response.updatePassword!){
         emit(state.copyWith(recoveryPassword: true,loadingRecovery: false));
       }
       if(!response.updatePassword!){
         emit(state.copyWith(loadingRecovery: false,error: ErrorLoginResponse.UPDATE_PASSWORD_ERROR));
       }
       emit(LoginState.initial());
    }
   }
   else emit(state.copyWith(loadingRecovery: false,error: ErrorLoginResponse.RECOVERY_CONFIRM_PASSWORD_INVALID));
  }
  
  resetState() => emit(LoginState.initial());

  Future<ResponseSocialAuth> _getUserWithSocialAuth(SocialAuthType type) async {
    try {
      final UserCredential? credential = await _getCredential(type);
      final user = credential!.user;
      final usuario = LoginUsuario(
          nombre: user!.displayName!, usuario: user.email!, socialId: user.uid);
      return ResponseSocialAuth(usuario: usuario);
    } catch (error) {
      print(error);
      return ResponseSocialAuth(error: true);
    }
  }

  Future<void> _login(String usuario,
      {String idAuth = '', String password = ''}) async {
    final response = await repositorio.login(usuario, password, idAuth);
    _resultResponse(response);
  }

  Future<void> _registreUser(Map<String, dynamic> datos) async {
    final response = await repositorio.addUsuario(datos);
    _resultResponse(response);
  }

  ErrorLoginResponse _getTipoError(String error) {
    try {
       final  errorNew = ErrorLoginResponse.values
        .firstWhere((tipo) => tipo.toString().split('.').last == error);
        return errorNew;
    } catch (eror) {
      return ErrorLoginResponse.ERROR_DATA_BASE;
    }
    
  }

  Future<UserCredential?> _getCredential(SocialAuthType type) async {
    if (type == SocialAuthType.GOOGLE) return await signInWithGoogle();
    if (type == SocialAuthType.FACEBOOK) return await signInWithFacebook();
    if (type == SocialAuthType.APPLE) return await signInWithApple();
  }

  void _resultResponse(ResponseHttp response) {
    if (response is LoginResponseHttp) {
      prefs.token = response.token!;
      prefs.idUsuario = response.usuario!.id;
      DioHttp().setToken(response.token!);
      emit(state.copyWith(
          usuario: response.usuario, logiado: true, loading: false));
    }
    if (response is ErrorResponseHttp) {
      final error = _getTipoError(response.getError);
      emit(state.copyWith(error: error, loading: false));
    }
    emit(state.copyWith(logiado: false));
  }

  Map<String, dynamic>? _getSocialdMap(SocialAuthType type, String socialId) {
    if (type == SocialAuthType.GOOGLE) return {'google_id': socialId};
    if (type == SocialAuthType.APPLE) return {'apple_id': socialId};
    if (type == SocialAuthType.FACEBOOK) return {'facebook_id': socialId};
  }
}
