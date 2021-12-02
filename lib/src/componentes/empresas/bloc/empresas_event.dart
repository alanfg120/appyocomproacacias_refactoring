part of 'empresas_bloc.dart';

abstract class EmpresasEvent extends Equatable {
  const EmpresasEvent();
  @override
  List<Object> get props => [];
}

class SearchEmpresaEvent  extends EmpresasEvent {
  final String text;
  SearchEmpresaEvent(this.text);
  @override
  List<Object> get props => [text];
}
class RegistarVisitaEmpresaEvent  extends EmpresasEvent {
  final int idEmpresa;
  RegistarVisitaEmpresaEvent({required this.idEmpresa});
  @override
  List<Object> get props => [idEmpresa];
}
class GetEmpresas  extends EmpresasEvent {
  final List<Empresa> empresas;
  GetEmpresas({required this.empresas});
  @override
  List<Object> get props => [empresas];
}
class AddEmpresaEvent  extends EmpresasEvent {
  final Empresa empresa;
  AddEmpresaEvent({required this.empresa});
  @override
  List<Object> get props => [empresa];
}
class DeleeteEmpresaEvent  extends EmpresasEvent {
  final int idEmpresa;
  DeleeteEmpresaEvent({required this.idEmpresa});
  @override
  List<Object> get props => [idEmpresa];
}
class UpdateEmpresaEvent  extends EmpresasEvent {
  final Empresa empresa;
  final String url;
  UpdateEmpresaEvent({required this.empresa,required this.url});
  @override
  List<Object> get props => [empresa];
}


