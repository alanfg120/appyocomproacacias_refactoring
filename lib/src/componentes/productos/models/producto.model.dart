import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/categoriaProducto.model.dart';
import 'package:intl/intl.dart';

class Producto {
  final int? id;
  final String nombre,descripcion,descripcionOferta;
  final int precio,cantidad;
  final List<String> imagenes;
  final bool oferta;
  final Empresa empresa;
  final CategoriaProducto categoria;

  String get precioFormat => NumberFormat.simpleCurrency(locale: 'en',decimalDigits: 0).format(this.precio);
  
  Producto({
     this.id,
     required this.nombre,  
     required this.precio,
     required this.descripcion,
     required this.descripcionOferta,
     required this.imagenes,
     required this.oferta,
     required this.empresa,
     required this.categoria,
     required this.cantidad
     });

  factory Producto.toJson(Map<String, dynamic> json) => Producto(
      id                : json['id']                ?? 0,
      nombre            : json['nombre']            ?? '',
      descripcion       : json['descripcion']       ?? '',
      descripcionOferta : json['descripcion_oferta']?? '',
      precio            : json['precio'],
      oferta            : json['oferta']  ?? false,
      empresa           : Empresa.toJson(json['empresa']),
      categoria         : CategoriaProducto.toJson(json['categoria']),
      imagenes          : json['imagenes'].map<String>((imagen)=>'${imagen['nombre']}').toList() ?? [],
      cantidad          : 0
      );

  Producto copyWith({
    int? id,
    String? nombre,
    int? precio,
    List<String>? imagenes,
    bool? oferta,
    Empresa? empresa,
    CategoriaProducto? categoria,
    String? descripcionOferta,
    String? descripcion,
    int? cantidad
  }) =>
      Producto(
          id                : id                 ?? this.id,
          nombre            : nombre             ?? this.nombre,
          precio            : precio             ?? this.precio,
          imagenes          : imagenes           ?? this.imagenes,
          oferta            : oferta             ?? this.oferta,
          empresa           : empresa            ?? this.empresa,
          categoria         : categoria          ?? this.categoria,
          descripcionOferta : descripcionOferta  ?? this.descripcionOferta,
          descripcion       : descripcion        ?? this.descripcion,
          cantidad          : cantidad           ?? this.cantidad
      );

  Map<String,dynamic> toMap([int? idEmpresa,int? idProducto])=>{
   "id"                    : idProducto ?? this.id, 
   "nombre"                : nombre,
   "precio"                : precio,
   "descripcion"           : descripcion,
   "descripcion_oferta"    : descripcionOferta,
   "id_empresa"            : idEmpresa,
   "id_categoria_producto" : categoria.id,
   "oferta"                : oferta,
   "cantidad"              : cantidad 
  };
}
