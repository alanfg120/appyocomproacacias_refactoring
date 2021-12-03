import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/cardProducto.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/loadingProductos.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfertasList extends StatefulWidget {

  const OfertasList({Key? key}) : super(key: key);

  @override
  _OfertasListState createState() => _OfertasListState();
}

class _OfertasListState extends State<OfertasList> {

  ScrollController _controller = ScrollController();
  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
                   backgroundColor: Colors.grey[100],
                   title: const Text('Ofertas'),
                   elevation: 0,
                   actions: [
                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Icon(Icons.star_outlined,color: Colors.yellow),
                     )
                   ],
           ),
           body: Padding(
           padding : const EdgeInsets.all(4),
           child   : BlocBuilder<ProductosBloc, ProductosState>(
                     builder: (context, state) {
                       if(state.loadingOfertas)
                         return LoadingSearchProductos();
                       return RefreshIndicator(
                              onRefresh: () async =>{}, //context.read<ProductosBloc>().add(GetNewProductosEvent()),
                              child    : ListView.separated(
                                         controller: _controller,
                                         separatorBuilder: (_,i) => SizedBox(height: 0),
                                         itemCount: state.ofertas.length + 1,
                                         itemBuilder: (BuildContext context, int index) {
                                           if(index == state.ofertas.length ){
                                             return LoadingCardProducto();
                                           }
                                           return  CardProducto(producto: state.ofertas[index]);
                                         }
                                            
                                
                              ),
                       );
                     },
           ),
        ),
    );
  }
  

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent){
       context.read<ProductosBloc>().add(GetOfertasProductosEvent());
   }
  }
}