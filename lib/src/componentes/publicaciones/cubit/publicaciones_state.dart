part of 'publicaciones_cubit.dart';

class PublicacionesState extends Equatable {

  final int idEmpresa,pagina;
  final double progress;
  final List<Publicacion> publicaciones;
  final List<Publicacion> publicacionesByEmpresa;
  final Publicacion? publicacion;
  final bool loading,
             initialDataloaded,
             loadingLike,
             loadingComentario,
             loadingAdd,
             loadingDelete;
  
  const PublicacionesState(
      {   
        required this.pagina,
        required this.progress, 
        required this.publicaciones,
        required this.publicacionesByEmpresa,
        this.publicacion,
        required this.loading,
        required this.initialDataloaded,
        required this.loadingLike,
        required this.loadingComentario,
        required this.loadingAdd,
        required this.loadingDelete,
        required this.idEmpresa,
      });

  factory PublicacionesState.initial() =>
      PublicacionesState(
      pagina: 0,
      progress: 0,
      idEmpresa: -1,
      publicaciones: [],
      publicacionesByEmpresa: [],
      loading: true,
      initialDataloaded: false,
      loadingLike: false,
      loadingComentario: false,
      loadingAdd: false,
      loadingDelete: false);

  PublicacionesState copyWith({
                     int? pagina,
                     int? idEmpresa,
                     double? progress,
                     List<Publicacion>? publicaciones,
                     List<Publicacion>? publicacionesByEmpresa,
                     Publicacion? publicacion,
                     bool? loading,
                     bool? initialDataloaded,
                     bool? loadingLike,
                     bool? loadingComentario, 
                     bool? loadingAdd, 
                     bool? loadingDelete}) 
                     => PublicacionesState(
                        pagina                 : pagina                 ?? this.pagina,
                        idEmpresa              : idEmpresa              ?? this.idEmpresa,
                        progress               : progress               ?? this.progress,
                        publicaciones          : publicaciones          ?? this.publicaciones,
                        publicacionesByEmpresa : publicacionesByEmpresa ?? this.publicacionesByEmpresa,
                        publicacion            : publicacion            ?? this.publicacion,
                        loading                : loading                ?? this.loading,
                        initialDataloaded      : initialDataloaded      ?? this.initialDataloaded,
                        loadingLike            : loadingLike            ?? this.loadingLike,
                        loadingComentario      : loadingComentario      ?? this.loadingComentario,
                        loadingAdd             : loadingAdd             ?? this.loadingAdd,
                        loadingDelete          : loadingDelete          ?? this.loadingDelete
                     );
  @override
  List<Object?> get props => [
       pagina,
       idEmpresa,
       progress,
       publicaciones,
       publicacionesByEmpresa,
       publicacion,
       loading,
       loadingComentario,
       loadingLike,
       loadingAdd,
       loadingDelete
  ];
}
