part of 'categorias_bloc.dart';

abstract class CategoriasEvent extends Equatable {
  const CategoriasEvent();
  @override
  List<Object> get props => [];
}

class GetEmpresasEvent extends CategoriasEvent {
  final String categoria;
  GetEmpresasEvent(this.categoria);
  @override
  List<Object> get props => [categoria];
}

class GetNewEmpresasEvent extends CategoriasEvent {
  final String categoria;
  GetNewEmpresasEvent(this.categoria);
  @override
  List<Object> get props => [categoria];
}

class GetCategoriasEvent extends CategoriasEvent {}

class SearchEmpresasEvent extends CategoriasEvent {
  final String categoria;
  final String text;
  SearchEmpresasEvent({required this.categoria,required this.text});
  @override
  List<Object> get props => [categoria,text];
}
