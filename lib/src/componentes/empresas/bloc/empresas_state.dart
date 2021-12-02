part of 'empresas_bloc.dart';

class EmpresasState extends Equatable {
  
  final List<Empresa> resultEmpresa;
  final List<Empresa> empresas;
  final bool loading;
  
  const EmpresasState({required this.resultEmpresa, required this.loading,required this.empresas});

  factory EmpresasState.intial() =>
      EmpresasState(resultEmpresa: [], loading: false,empresas: []);

  EmpresasState copyWith({List<Empresa>? resultEmpresa,List<Empresa>? empresas, bool? loading}) =>
      EmpresasState(
          resultEmpresa : resultEmpresa ?? this.resultEmpresa,
          empresas      : empresas      ?? this.empresas,
          loading       : loading       ?? this.loading);

  @override
  List<Object> get props => [resultEmpresa, loading];
}
