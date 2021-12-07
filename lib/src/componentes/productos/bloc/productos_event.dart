part of 'productos_bloc.dart';

abstract class ProductosEvent extends Equatable {
  const ProductosEvent();
  @override
  List<Object?> get props => [];
}

class GetProductosEvent extends ProductosEvent {}

class GetInitialData extends ProductosEvent {}

class GetNewProductosEvent extends ProductosEvent {}

class GetCategoriasProductoEvent extends ProductosEvent {}

class GetProductosByUsuarioEvent extends ProductosEvent {}

class GetOfertasProductosEvent extends ProductosEvent {
  final bool news;
  GetOfertasProductosEvent({this.news = false});
}

class SearchProductoEvent extends ProductosEvent {
  final String texto;
  SearchProductoEvent(this.texto);
  @override
  List<Object?> get props => [texto];
}

class GetProductosByCategoriaEvent extends ProductosEvent {
  final int idCategoria;
  GetProductosByCategoriaEvent(this.idCategoria);
  @override
  List<Object?> get props => [idCategoria];
}
class GetProductosByEmpresaEvent extends ProductosEvent {
  final int idEmpresa;
  GetProductosByEmpresaEvent(this.idEmpresa);
  @override
  List<Object?> get props => [idEmpresa];
}

class AddProductoEvent extends ProductosEvent {
  final Producto producto;
  final int idEmpresa;
  final List<ImageFile> imagenes;
  AddProductoEvent(
      {required this.producto,
      required this.idEmpresa,
      required this.imagenes});
  @override
  List<Object?> get props => [producto, imagenes, idEmpresa];
}

class ProgressEvent extends ProductosEvent {
  final double progress;
  ProgressEvent(this.progress);
  @override
  List<Object?> get props => [progress];
}

class DeleteProductoEvent extends ProductosEvent {
  final int idProducto;
  DeleteProductoEvent(this.idProducto);
  @override
  List<Object?> get props => [idProducto];
}

class UpdateProductoEvent extends ProductosEvent{
  final Producto producto;
  final List<ImageFile> imagenes;
  final String url;
  UpdateProductoEvent({required this.producto,required this.imagenes,required this.url});
  
  }