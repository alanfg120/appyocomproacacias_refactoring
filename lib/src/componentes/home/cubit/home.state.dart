import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  
  final int page;
  final TipoUsuario currentUsuario;
  final Usuario? usuario;
  final bool offline,loading;
  final String url;
  HomeState({
  required this.page,
  required this.currentUsuario,
  this.usuario, 
  required this.offline,
  required this.loading,
  required this.url
  });
   
  factory HomeState.initial(String url) => HomeState(
                                 page           : 0,
                                 currentUsuario : TipoUsuario.ANONYMOUS,
                                 offline        : false,
                                 loading        : false,
                                 url            : url 
  ); 

  HomeState copyWith({
            int? page,
            TipoUsuario? currentUsuario,
            Usuario? usuario,
            bool? offline,
            bool? loading}) 
    => HomeState(
       page           : page           ?? this.page,
       currentUsuario : currentUsuario ?? this.currentUsuario,
       usuario        : usuario        ?? this.usuario,
       offline        : offline        ?? this.offline,
       loading        : loading        ?? this.loading,
       url            : this.url
       );

  @override
  List<Object?> get props => [page,currentUsuario,usuario,offline,loading];

}