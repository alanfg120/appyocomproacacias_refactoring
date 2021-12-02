part of 'formempresa_cubit.dart';

class FormEmpresaState extends Equatable {
  final int index;
  final ImageFile? logo;
  final Categoria categoria;
  final double? latitud;
  final double? longitud;
  final bool loading;

  const FormEmpresaState(
      {required this.index,
      required this.categoria,
      required this.loading,
      this.latitud,
      this.longitud,
      this.logo});

  factory FormEmpresaState.initial() => FormEmpresaState(
      index     : 0,
      categoria : Categoria(id: -1, nombre: 'Ninguna'),
      loading   : false);

  FormEmpresaState copyWith(
          {int? index,
          ImageFile? logo,
          Categoria? categoria,
          double? latitud,
          double? longitud,
          bool? loading}) =>
      FormEmpresaState(
          index     : index     ?? this.index,
          logo      : logo      ?? this.logo,
          categoria : categoria ?? this.categoria,
          latitud   : latitud   ?? this.latitud,
          longitud  : longitud  ?? this.longitud,
          loading   : loading   ?? this.loading);

  @override
  List<Object?> get props => [index, logo, categoria, latitud, longitud,loading];
}
