part of 'formpublicaciones_cubit.dart';

 class FormPublicacionesState extends Equatable {

  final Empresa? empresa;
  final List<ImageFile> imagenes;
  final int selecionada;
  final bool loading;

  const FormPublicacionesState(
        {this.empresa,
        required this.selecionada,
        required this.imagenes,
        required this.loading});

  factory FormPublicacionesState.initial() 
          => FormPublicacionesState(
             selecionada: -1,
             imagenes   : [],
             loading    : false
  );
  FormPublicacionesState copyWith(
          {Empresa? empresa,
           List<ImageFile>? imagenes,
           int? selecionada,
           bool? loading})
               => FormPublicacionesState(
                  selecionada : selecionada ?? this.selecionada,
                  empresa     : empresa     ?? this.empresa,
                  imagenes    : imagenes    ?? this.imagenes,
                  loading     : loading     ?? this.loading
               );
  @override
  List<Object?> get props 
     => [empresa,
         selecionada,
         imagenes,
         loading];
}


