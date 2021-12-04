part of 'formproductos_cubit.dart';

class FormProductosState extends Equatable {

  final Empresa? empresa;
  final CategoriaProducto? categoria;
  final List<ImageFile> imagenes;
  final int categoriaSelecionada;
  final int empresaSelecionada;
  final bool loading,oferta;

  const FormProductosState({
        this.empresa,
        this.categoria, 
        required this.imagenes, 
        required this.categoriaSelecionada, 
        required this.empresaSelecionada, 
        required this.loading,
        required this.oferta});

  factory FormProductosState.initial() 
          => FormProductosState(
             imagenes             : [],
             loading              : false,
             oferta               : false ,
             categoriaSelecionada : -1,
             empresaSelecionada   : -1,
          );

   FormProductosState copyWith({
      Empresa? empresa,
      CategoriaProducto? categoria,
      List<ImageFile>? imagenes,
      int? categoriaSelecionada,
      int? empresaSelecionada,
      bool? loading,
      bool? oferta
   }) => FormProductosState(
         empresa              : empresa              ?? this.empresa,
         categoria            : categoria            ?? this.categoria,
         imagenes             : imagenes             ?? this.imagenes,
         categoriaSelecionada : categoriaSelecionada ?? this.categoriaSelecionada,
         empresaSelecionada   : empresaSelecionada   ?? this.empresaSelecionada,
         loading              : loading              ?? this.loading,
         oferta               : oferta               ?? this.oferta   
   );

  @override
  List<Object?> get props => [
        empresa,
        categoria, 
        imagenes, 
        categoriaSelecionada,
        empresaSelecionada,
        loading,
        oferta
  ];
}


