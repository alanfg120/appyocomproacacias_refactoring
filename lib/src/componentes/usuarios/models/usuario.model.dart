import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:equatable/equatable.dart';

class Usuario  extends Equatable {
  final int id;
  final String?
      imagen,
      nombre,
      email,
      cedula,
      fechaCreacion;
  final List<Empresa> empresas;
  final bool administrador;
  Usuario(
      {
      required this.id,
      this.imagen,
      this.nombre,
      this.cedula,
      this.email,
      this.fechaCreacion,
      required this.empresas,
      required this.administrador
      });

  factory Usuario.toJson(Map<String, dynamic> json) 
    => Usuario(
       id              : json['id']                 ?? 0,
       imagen          : json['imagen']             ?? '',
       nombre          : json['nombre']             ?? '',
       cedula          : json['cedula']             ?? '',
       email           : json['usuario']            ?? '',
       fechaCreacion   : json['fecha']              ?? '',
       administrador   : json['administrador']      ?? false,
       empresas        : json['empresas']?.map<Empresa>((empresa)=>Empresa.toJson(empresa))?.toList() ?? []      

    );
Usuario copyWith({
  int?    id,
  String?  imagen,
  String?  nombre,
  String?  cedula,
  String?  biografia,
  String?  sexo,
  String?  fechaNacimiento,
  String?  numero,
  String?  email,
  String?  fechaCreacion,
  bool? administrador,
  List<Empresa>? empresas
})
=> Usuario(  
   id              : id               ?? this.id,   
   imagen          : imagen           ?? this.imagen,
   nombre          : nombre           ?? this.nombre,
   cedula          : cedula           ?? this.cedula,
   email           : email            ?? this.email,
   fechaCreacion   : fechaCreacion    ?? this.fechaCreacion,
   administrador   : administrador    ?? this.administrador,
   empresas        : empresas         ?? this.empresas,
);

  @override
  List<Object?> get props => [
    id,
    imagen,
    nombre,
    cedula,
    email,
    fechaCreacion,
    administrador,
    empresas
  ];  
}
