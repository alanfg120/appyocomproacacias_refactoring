

import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/data/productos.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/cardProducto.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/loadingProductos.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchProductosPage extends StatefulWidget {

  SearchProductosPage({Key? key}) : super(key: key);

  @override
  _SearchProductosPageState createState() => _SearchProductosPageState();
}

class _SearchProductosPageState extends State<SearchProductosPage> {

  final _bloc = ProductosBloc(repocitorio: ProductosRepositorio(),prefs: PreferenciasUsuario());

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return Scaffold(
            appBar: AppBar(
                    title: TextField(
                           style      : TextStyle(fontSize: 18),
                           autofocus  : true,
                           decoration : InputDecoration(
                                        hintText  : "Buscar",
                                        hintStyle : TextStyle(fontSize: 15),
                                        border    : InputBorder.none
                                        ),
                           onChanged  : (texto) => _bloc.add(SearchProductoEvent(texto))
                    ),
                    elevation: 0,
            ),
            body: BlocBuilder<ProductosBloc,ProductosState>(
                  bloc   : _bloc,
                  builder: (context,state){
                    if(state.loadingSearch)
                      return LoadingSearchProductos();
                    if(state.resulProductos.length == 0)
                      return Center(child: const Text('Sin resultados'));
                    return _listEmpresas(state.resulProductos,url);
                  },
            )
    );
  }

  Widget _listEmpresas(List<Producto> productos,String url) {
    return ListView.builder(
           itemCount   : productos.length,
           itemBuilder : (context,index) {
               return CardProducto(producto: productos[index]);
           }
    );
  }
}