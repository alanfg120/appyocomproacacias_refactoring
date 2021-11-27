part of 'empresas_bloc.dart';

class EmpresasState extends Equatable {
  final List<Empresa> resultEmpresa;
  final bool loading;
  
  const EmpresasState({required this.resultEmpresa, required this.loading});

  factory EmpresasState.intial() =>
      EmpresasState(resultEmpresa: [], loading: false);

  EmpresasState copyWith({List<Empresa>? resultEmpresa, bool? loading}) =>
      EmpresasState(
          resultEmpresa : resultEmpresa ?? this.resultEmpresa,
          loading       : loading       ?? this.loading);

  @override
  List<Object> get props => [resultEmpresa, loading];
}
