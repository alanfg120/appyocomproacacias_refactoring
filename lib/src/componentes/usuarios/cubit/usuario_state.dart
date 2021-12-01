part of 'usuario_cubit.dart';

class UsuarioState extends Equatable {
  
  final Usuario usuario;
  final bool updatePassword,updateData,loading;
  final ErrorResponseUsuario? error;

  UsuarioState(
    {required this.usuario, 
     required this.updatePassword,
     required this.updateData,
     required this.loading,
     this.error});

  factory UsuarioState.initial(Usuario usuario) =>
      UsuarioState(
      usuario        : usuario,
      updatePassword : false,
      updateData     : false,
      loading        : false
     );

  UsuarioState copyWith(
               {Usuario? usuario,
                bool? updatePassword,
                bool? updateData,
                bool? loading,
                ErrorResponseUsuario? error}) =>
      UsuarioState(
          usuario        : usuario        ?? this.usuario,
          updatePassword : updatePassword ?? this.updatePassword,
          updateData     : updateData     ?? this.updateData,
          loading        : loading        ?? this.loading,
          error          : error          ?? this.error 
      );

  @override
  List<Object?> get props 
       => [usuario,
           updatePassword,
           updateData,
           loading,
           error
           ];
}

enum ErrorResponseUsuario {
  NO_ERROR,
  PASS_INVALID,
  DATA_ERROR
}