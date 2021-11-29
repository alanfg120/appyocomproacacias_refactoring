part of 'usuario_cubit.dart';

class UsuarioState extends Equatable {
  final Usuario usuario;

  UsuarioState({required this.usuario});
  
  factory UsuarioState.initial(Usuario usuario) 
   => UsuarioState(
      usuario: usuario
   );

   UsuarioState copyWith({Usuario? usuario})
                =>UsuarioState(usuario: usuario ?? this.usuario);
  
  @override
  List<Object?> get props => [
    usuario
  ];
}


