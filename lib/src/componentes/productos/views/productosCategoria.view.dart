import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/data/productos.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/categoriaProducto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/cardProducto.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/loadingProductos.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductosByCategoriaList extends StatefulWidget {
   
  final CategoriaProducto categoria;
  const ProductosByCategoriaList({Key? key,required this.categoria}) : super(key: key);

  @override
  _ProductosByCategoriaListState createState() => _ProductosByCategoriaListState();
}

class _ProductosByCategoriaListState extends State<ProductosByCategoriaList> {

  final _bloc = ProductosBloc(repocitorio: ProductosRepositorio(),prefs: PreferenciasUsuario());

  ScrollController _controller = ScrollController();
 
  @override
  void dispose() {
    _bloc.close();  
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
                   backgroundColor: Colors.grey[100],
                   title:  Text(widget.categoria.nombre),
                   elevation: 0,
           ),
           body: Padding(
           padding : const EdgeInsets.all(4),
           child   : BlocBuilder<ProductosBloc, ProductosState>(
                     bloc:  _bloc..add(GetProductosByCategoriaEvent(widget.categoria.id)),
                     builder: (context, state) {
                        final url = context.read<HomeCubit>().urlImagenes;
                        final productos = state.resulProductos;
                       if(state.loadingProductos)
                         return LoadingSearchProductos();
                       if(productos.length == 0)
                         return Center(child: Text('No hay resultados'));
                       return RefreshIndicator(
                              onRefresh: () async => _bloc.add(GetProductosByCategoriaEvent(widget.categoria.id)),
                              child    : ListView.separated(
                                         controller: _controller,
                                         separatorBuilder: (_,i) => SizedBox(height: 0),
                                         itemCount: productos.length,
                                         itemBuilder: (BuildContext context, int index) {
                                           return  CardProducto(producto: productos[index],url: url);
                                         }
                                            
                                
                              ),
                       );
                     },
           ),
        ),
    );
  }
   
}
