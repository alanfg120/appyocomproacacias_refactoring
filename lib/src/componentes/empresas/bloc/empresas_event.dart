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


