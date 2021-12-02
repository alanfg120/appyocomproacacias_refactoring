import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:equatable/equatable.dart';

class Empresa extends Equatable {
  final int? id;
  final int idCategoria, idUsuario;
  final String nombre,
      urlLogo,
      descripcion,
      direccion,
      telefono,
      whatsapp,
      email,
      nit,
      web;
  final String latitud,longitud;
  final bool estado;
  final ImageFile? imagen;
  
  Empresa(
      {this.id,
      required this.idCategoria,
      required this.idUsuario,
      required this.nombre,
      required this.nit,
      required this.urlLogo,
      required this.descripcion,
      required this.direccion,
      required this.telefono,
      required this.whatsapp,
      required this.email,
      this.latitud  =  '',
      this.longitud =  '',
      required this.estado,
      this.web = '',
      this.imagen});

  factory Empresa.toJson(Map<String, dynamic> json) => Empresa(
      id          : json['id']          ?? 0,
      nombre      : json['nombre']      ?? '',
      nit         : json['NIT']         ?? '',
      urlLogo     : json['logo']        ?? '',
      descripcion : json['descripcion'] ?? '',
      direccion   : json['direccion']   ?? '',
      telefono    : json['telefono']    ?? '',
      whatsapp    : json['whatsapp']    ?? '',
      email       : json['email']       ?? '',
      web         : json['web']         ?? '',
      latitud     : json['latitud']     ?? '',
      longitud    : json['longitud']    ?? '',
      estado      : json['estado']      ?? false,
      idCategoria : json['id_categoria'],
      idUsuario   : json['id_usuario']);
      
  Empresa copyWith({
    int? id,
    int? idCategoria,
    String? nombre,
    String? urlLogo,
    String? descripcion,
    String? direccion,
    String? telefono,
    String? whatsapp,
    String? email,
    String? web,
    String? latitud,
    String? longitud,
    String? nit,
    int? popular,
    bool? estado,
    int? idUsuario,
  }) =>
      Empresa(
      id          : id          ?? this.id,
      idCategoria : idCategoria ?? this.idCategoria,
      nombre      : nombre      ?? this.nombre,
      urlLogo     : urlLogo     ?? this.urlLogo,
      descripcion : descripcion ?? this.descripcion,
      direccion   : direccion   ?? this.direccion,
      telefono    : telefono    ?? this.telefono,
      whatsapp    : whatsapp    ?? this.whatsapp,
      email       : email       ?? this.email,
      web         : web         ?? this.web,
      latitud     : latitud     ?? this.latitud,
      longitud    : longitud    ?? this.longitud,
      estado      : estado      ?? this.estado,
      idUsuario   : idUsuario   ?? this.idUsuario,
      nit         : nit         ?? this.nit);

  Map<String, dynamic> toMap(int idUsuario) => {
        'id': id ?? null,
        'nombre': nombre,
        'NIT': nit,
        'logo': urlLogo,
        'descripcion': descripcion,
        'direccion': direccion,
        'telefono': telefono,
        'whatsapp': whatsapp,
        'email': email,
        'web': web,
        'latitud': latitud,
        'longitud': longitud,
        'estado': estado,
        'id_usuario': idUsuario,
        'id_categoria': idCategoria,
      };

  @override
  List<Object?> get props => [
        id,
        idCategoria,
        idUsuario,
        nombre,
        urlLogo,
        descripcion,
        direccion,
        telefono,
        whatsapp,
        email,
        nit,
        web,
        latitud,
        longitud,
        estado
      ];
}
