part of 'empresas_bloc.dart';

class EmpresasState extends Equatable {
  final List<Empresa> resultEmpresa;
  final List<Empresa> empresas;
  final bool loading, loadingDelete;

  const EmpresasState(
      {required this.resultEmpresa,
      required this.loading,
      required this.empresas,
      required this.loadingDelete});

  factory EmpresasState.intial() => EmpresasState(
      resultEmpresa: [], loading: false, empresas: [], loadingDelete: false);

  EmpresasState copyWith(
          {List<Empresa>? resultEmpresa,
          List<Empresa>? empresas,
          bool? loading,
           bool? loadingDelete}) =>
      EmpresasState(
          resultEmpresa : resultEmpresa ?? this.resultEmpresa,
          empresas      : empresas      ?? this.empresas,
          loading       : loading       ?? this.loading,
          loadingDelete : loadingDelete ?? this.loadingDelete);

  @override
  List<Object> get props => [resultEmpresa, loading, empresas,loadingDelete];
}
