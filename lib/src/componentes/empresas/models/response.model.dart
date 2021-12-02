import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/calificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/response/models/reponse.model.dart';

class ResponseEmpresa extends ResponseHttp {
  
  final List<Empresa>? empresas;
  final List<Producto>? productos;
  final List<Publicacion>? publicaciones;
  final List<Calificacion>? calificaciones;
  final Calificacion? calificacion;
  final Empresa? empresa;
  final bool? visita,delete,update;
  final int? id;

  ResponseEmpresa(
      {this.productos, 
       this.publicaciones, 
       this.calificaciones, 
       this.empresas,
       this.calificacion,
       this.empresa,
       this.visita,
       this.delete,
       this.update,
       this.id});
}
