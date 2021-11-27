import 'package:equatable/equatable.dart';

class Empresa extends Equatable {
  final int? id;
  final int idCategoria, idUsuario;
  final String nombre,
      urlLogo,
      urlPortada,
      descripcion,
      direccion,
      telefono,
      whatsapp,
      email,
      nit,
      web;
  final String latitud, longitud;
  final int popular;
  final bool estado;
  Empresa(
      {this.id,
      required this.idCategoria,
      required this.idUsuario,
      required this.nombre,
      required this.nit,
      required this.urlLogo,
      required this.urlPortada,
      required this.descripcion,
      required this.direccion,
      required this.telefono,
      required this.whatsapp,
      required this.email,
      required this.latitud,
      required this.longitud,
      required this.popular,
      required this.estado,
      required this.web});

  factory Empresa.toJson(Map<String, dynamic> json) => Empresa(
      id          : json['id']          ?? 0,
      nombre      : json['nombre']      ?? '',
      nit         : json['NIT']         ?? '',
      urlLogo     : json['logo']        ?? '',
      urlPortada  : json['portada']     ?? '',
      descripcion : json['descripcion'] ?? '',
      direccion   : json['direccion']   ?? '',
      telefono    : json['telefono']    ?? '',
      whatsapp    : json['whatsapp']    ?? '',
      email       : json['email']       ?? '',
      web         : json['web']         ?? '',
      latitud     : json['latitud']     ?? '',
      longitud    : json['longitud']    ?? '',
      popular     : json['popular']     ?? 0,
      estado      : json['estado']      ?? false,
      idCategoria : json['id_categoria'],
      idUsuario   : json['id_usuario']);
      
  Empresa copyWith({
    int? id,
    int? idCategoria,
    String? nombre,
    String? urlLogo,
    String? urlPortada,
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
      urlPortada  : urlPortada  ?? this.urlPortada,
      descripcion : descripcion ?? this.descripcion,
      direccion   : direccion   ?? this.direccion,
      telefono    : telefono    ?? this.telefono,
      whatsapp    : whatsapp    ?? this.whatsapp,
      email       : email       ?? this.email,
      web         : web         ?? this.web,
      latitud     : latitud     ?? this.latitud,
      longitud    : longitud    ?? this.longitud,
      popular     : popular     ?? this.popular,
      estado      : estado      ?? this.estado,
      idUsuario   : idUsuario   ?? this.idUsuario,
      nit         : nit         ?? this.nit);

  Map<String, dynamic> toMap(int idUsuario) => {
        'id': id ?? null,
        'nombre': nombre,
        'NIT': nit,
        'logo': urlLogo,
        'portada': urlPortada,
        'descripcion': descripcion,
        'direccion': direccion,
        'telefono': telefono,
        'whatsapp': whatsapp,
        'email': email,
        'web': web,
        'latitud': latitud,
        'longitud': longitud,
        'popular': popular,
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
        urlPortada,
        descripcion,
        direccion,
        telefono,
        whatsapp,
        email,
        nit,
        web,
        latitud,
        longitud,
        popular,
        estado
      ];
}
