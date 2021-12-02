part of 'formempresa_cubit.dart';

class FormEmpresaState extends Equatable {
  final int index;
  final ImageFile? logo;
  final Categoria categoria;
  final double? latitud;
  final double? longitud;
  final bool loading,add;
  final ErrorFormEmpresaResponse error;

  const FormEmpresaState(
      {required this.index,
      required this.categoria,
      required this.loading,
      required this.add,
      required this.error,
      this.latitud,
      this.longitud,
      this.logo});

  factory FormEmpresaState.initial() => FormEmpresaState(
      index     : 0,
      categoria : Categoria(id: -1, nombre: 'Ninguna'),
      loading   : false,
      add       : false,
      error     : ErrorFormEmpresaResponse.NO_ERROR);

  FormEmpresaState copyWith(
          {int? index,
          ImageFile? logo,
          Categoria? categoria,
          double? latitud,
          double? longitud,
          bool? loading,
          bool? add,
          ErrorFormEmpresaResponse? error}) =>
      FormEmpresaState(
          index     : index     ?? this.index,
          logo      : logo      ?? this.logo,
          categoria : categoria ?? this.categoria,
          latitud   : latitud   ?? this.latitud,
          longitud  : longitud  ?? this.longitud,
          loading   : loading   ?? this.loading,
          add       : add       ?? this.add,
          error     : error     ?? this.error);

  @override
  List<Object?> get props 
      => [index,
          logo,
          categoria,
          latitud,
          longitud,
          loading,
          error,
          add];
}

enum ErrorFormEmpresaResponse {
  NO_ERROR,
  RESPONSE_ERROR
}
