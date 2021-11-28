part of 'perfil_empresa_cubit.dart';

 class PerfilEmpresaState extends Equatable {
   
  final int starts,pagina;
  final List<Publicacion> publicaciones;
  final List<Calificacion> calificaciones;
  final List<Producto> productos;
  final bool loading,
             loadingCalifiacion,
             initialDataPublicaciones,
             initialDataProductos,
             initialDataCalificaciones,
             duplicado;
  final Empresa? empresa;

  const PerfilEmpresaState(
        {required this.starts,
         required this.pagina,
         required this.publicaciones,
         required this.productos,
         required this.calificaciones,
         required this.loading,
         required this.loadingCalifiacion,
         required this.initialDataProductos,
         required this.initialDataPublicaciones,
         required this.initialDataCalificaciones,
         required this.duplicado,
         this.empresa});
  
  factory PerfilEmpresaState.initial() 
           => PerfilEmpresaState(
              starts                    : 0,
              pagina                    : 0,
              publicaciones             : [],
              productos                 : [],
              calificaciones            : [],
              loading                   : true,
              loadingCalifiacion        : false,
              initialDataCalificaciones : false,
              initialDataProductos      : false,
              initialDataPublicaciones  : false,
              duplicado                 : false);

  PerfilEmpresaState copyWith(
          {int? starts,
           int? pagina,
           List<Publicacion>? publicaciones,
           List<Producto>? productos,
           List<Calificacion>? calificaciones,
           bool? loading,
           bool? loadingCalifiacion,
           bool? initialDataCalificaciones,
           bool? initialDataProductos,
           bool? initialDataPublicaciones,
           bool? duplicado,
           Empresa? empresa}
           ) => PerfilEmpresaState(
                starts                    : starts                    ?? this.starts,
                pagina                    : pagina                    ?? this.pagina,
                publicaciones             : publicaciones             ?? this.publicaciones,
                productos                 : productos                 ?? this.productos,
                calificaciones            : calificaciones            ?? this.calificaciones,
                loading                   : loading                   ?? this.loading,
                loadingCalifiacion        : loadingCalifiacion        ?? this.loadingCalifiacion,
                initialDataCalificaciones : initialDataCalificaciones ?? this.initialDataCalificaciones,
                initialDataProductos      : initialDataProductos      ?? this.initialDataProductos,
                initialDataPublicaciones  : initialDataPublicaciones  ?? this.initialDataPublicaciones,
                duplicado                 : duplicado                 ?? this.duplicado,
                empresa                   : empresa                   ?? this.empresa
           );
  
  @override
  List<Object?> get props => [
               starts,
               pagina,
               publicaciones,
               productos,
               calificaciones,
               loading,
               loadingCalifiacion,
               initialDataPublicaciones,
               initialDataProductos,
               initialDataCalificaciones,
               duplicado,
               empresa
  ];
}


