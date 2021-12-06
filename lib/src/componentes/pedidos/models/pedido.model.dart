import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:intl/intl.dart';

class Pedido {
  
final List<Producto> productos;
final String observacion,id;
final Empresa empresa;
final int idUsuario;
final bool realizado;



Pedido({
required this.id,
required this.empresa,
required this.idUsuario,
required this.observacion,
required this.productos,
required this.realizado
});

factory Pedido.toJson(Map<String,dynamic> json) =>
        Pedido(
        id          : json['id'],
        productos   : json['productos'].map<Producto>((producto)=>Producto.toJson(producto)),
        observacion : json['observacion'],
        empresa     : Empresa.toJson(json['empresa']),
        idUsuario   : json['id_usuario'],
        realizado   : json['realizado']
        ); 


Map<String,dynamic> toMap() =>{
  "id"                : id,
  "productos"         : productos.map((producto) => producto.toMap()).toList(),
  "id_empresa"        : empresa.id,
  "id_usuario"        : idUsuario,
  "observacion"       : observacion,
  "id_usuario_pedido" : empresa.idUsuario
};

Pedido copyWith({
  String? id,
  List<Producto>? productos,
  String? observacion,
  Empresa? empresa,
  int? idUsuario,
  bool? realizado
}) => Pedido(
      id          : id          ?? this.id,
      productos   : productos   ?? this.productos,
      empresa     : empresa     ?? this.empresa,
      idUsuario   : idUsuario   ?? this.idUsuario,
      observacion : observacion ?? this.observacion,
      realizado   : realizado   ?? this.realizado
);


String calcularTotal(){
  int total = 0;
  this.productos.forEach((producto) { 
    total = total + (producto.precio * producto.cantidad);
  });
  return NumberFormat.simpleCurrency(locale: 'en',decimalDigits: 0).format(total);
}


}