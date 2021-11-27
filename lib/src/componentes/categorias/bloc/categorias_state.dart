part of 'categorias_bloc.dart';

class CategoriasState extends Equatable {

  final List<Categoria> categorias;
  final List<Empresa> resultEmpresas,empresas;            
  final int pagina,numeroEmpresas;
  final bool loading,end;
  final String categoria;


  const CategoriasState(
        {required this.categorias,
         required this.resultEmpresas,
         required this.empresas,
         required this.pagina,
         required this.numeroEmpresas,
         required this.loading,
         required this.end,
         required this.categoria});

  factory CategoriasState.initial() 
           => CategoriasState(
              categorias          : [],
              resultEmpresas      : [],
              empresas            : [],
              pagina              :  0 ,
              numeroEmpresas      :  0 ,
              loading             : false,
              end                 : false,
              categoria           : ''
             );

  CategoriasState copyWith(
                  {List<Categoria>? categorias,
                   List<Empresa>? resultEmpresas,
                   List<Empresa>? empresas,
                   int? pagina,
                   int? numeroEmpresas,
                   bool? loading,
                   bool? end,
                   String? categoria}) 
                  => CategoriasState(
                     categorias          : categorias     ?? this.categorias,
                     resultEmpresas      : resultEmpresas ?? this.resultEmpresas,
                     empresas            : empresas       ?? this.empresas,
                     pagina              : pagina         ?? this.pagina,
                     numeroEmpresas      : numeroEmpresas ?? this.numeroEmpresas,   
                     loading             : loading        ?? this.loading,
                     end                 : end            ?? this.end,
                     categoria           : categoria      ?? this.categoria
                  );

  @override
  List<Object> get props => [
        categorias,
        resultEmpresas,
        empresas,
        numeroEmpresas,
        pagina,
        loading,
        end,
        categoria             
  ];
}
