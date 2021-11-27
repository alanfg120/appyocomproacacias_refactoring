import 'package:appyocomproacacias_refactoring/src/componentes/login/models/dataRecovery.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool loading,loadingRecovery,isCodeSend,isCodevalid,logiado,recoveryPassword;
  final ErrorLoginResponse error;
  final Usuario? usuario;
  final DataRecoveryPassword?  dataRecovery;

  LoginState(
      {
      required this.loading,
      required this.loadingRecovery,
      required this.isCodeSend,
      required this.error,
      required this.logiado,
      required this.isCodevalid,
      required this.recoveryPassword,
      this.usuario,
      this.dataRecovery
      });

  factory LoginState.initial() =>
      LoginState(
      loading         : false,
      loadingRecovery : false, 
      isCodeSend      : false,
      isCodevalid     : false,
      recoveryPassword: false,
      error           : ErrorLoginResponse.noError, 
      logiado         : false
      );

  LoginState copyWith(
          {bool? loading, 
           bool? loadingRecovery, 
           bool? isCodeSend, 
           bool? isCodevalid,
           bool? recoveryPassword, 
           Usuario? usuario,
           DataRecoveryPassword? dataRecovery,
           ErrorLoginResponse? error, 
           bool? logiado}
           ) => LoginState(
                loading          : loading          ?? this.loading,
                loadingRecovery  : loadingRecovery  ?? this.loadingRecovery,
                isCodeSend       : isCodeSend       ?? this.isCodeSend,
                isCodevalid      : isCodevalid      ?? this.isCodevalid,
                usuario          : usuario          ?? this.usuario,
                dataRecovery     : dataRecovery     ?? this.dataRecovery,
                recoveryPassword : recoveryPassword ?? this.recoveryPassword,
                error            : error            ?? this.error,
                logiado          : logiado          ?? this.logiado
           );
  
 

  @override
  List<Object?> get props => 
        [loading,
         loadingRecovery,
         isCodevalid,
         isCodeSend,
         usuario, 
         error, 
         logiado,
         dataRecovery,
         recoveryPassword
        ];
}
 
enum ErrorLoginResponse {
  USER_NO_EXITS,
  DATA_INCORRECT,
  ERROR_DATA_BASE,
  ERROR_SOCIAL_AUTH,
  ERROR_SOCIAL_SING,
  USER_EXITS,
  EMAIL_SEND_FAILD,
  CODE_RECOVERY_INVALID,
  RECOVERY_CONFIRM_PASSWORD_INVALID,
  UPDATE_PASSWORD_ERROR,
  noError
}

