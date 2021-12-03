import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/cardProducto.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/loadingProductos.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TiendaPage extends StatelessWidget {
  const TiendaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor: Colors.grey[100],
           appBar: AppBar(
                   title     : const Text('Tienda'),
                   elevation : 0,
           ),
           body:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                           crossAxisAlignment : CrossAxisAlignment.start,
                           children: [
                             _BarSearch(),
                             _Tabs(),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text('Productos',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                             ),
                             BlocSelector<ProductosBloc, ProductosState, bool>(
                               selector: (state) => state.loadingProductos,
                               builder: (context, loading) {
                                 if(loading)
                                   return LoadingProductos();
                                 return _ProductosList();
                               },
                             )
                           ],
             ),
            ),
           );
  }
}

class _BarSearch extends StatelessWidget {
  const _BarSearch({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      return GestureDetector(
         child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                       height    : 50,
                       padding   : EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                       decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(40)
                       ),
                       child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Buscar Productos'),
                                Icon(Icons.search,color: Theme.of(context).primaryColor),
                              ]
                       ),
                ),
         ),
         onTap: () => NavigationService().navigateTo('search_producto')
  );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
           children: [
            _TapItem(
             titulo: 'Ofertas', 
             icon: Icons.star_border_outlined, 
             onTap: (){}
             ),
             SizedBox(width: 10),
            _TapItem(
             titulo: 'Categorias', 
             icon: Icons.list_alt_outlined, 
             onTap: (){
               NavigationService().navigateTo('categorias_producto');
               context.read<ProductosBloc>().add(GetCategoriasProductoEvent());
             }
             ),
           ],
    );
  }
}
class _ProductosList extends StatefulWidget {

  const _ProductosList({Key? key}) : super(key: key);

  @override
  __ProductosListState createState() => __ProductosListState();
}

class __ProductosListState extends State<_ProductosList> {

  ScrollController _controller = ScrollController();
  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
           child: Padding(
                  padding : const EdgeInsets.all(4),
                  child   : BlocBuilder<ProductosBloc, ProductosState>(
                         builder: (context, state) {
                              return RefreshIndicator(
                                     onRefresh: () async => context.read<ProductosBloc>().add(GetNewProductosEvent()),
                                     child    : ListView.separated(
                                                controller: _controller,
                                                separatorBuilder: (_,i) => SizedBox(height: 0),
                                                itemCount: state.productos.length + 1,
                                                itemBuilder: (BuildContext context, int index) {
                                                  if(index == state.productos.length ){
                                                    return LoadingCardProducto();
                                                  }
                                                  return  CardProducto(producto: state.productos[index]);
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
       context.read<ProductosBloc>().add(GetProductosEvent());
   }
  }
}
class _TapItem extends StatelessWidget {
  final String titulo;
  final IconData icon;
  final VoidCallback onTap;
  const _TapItem(
         {Key? key,
          required this.titulo,
          required this.icon,
          required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: OutlinedButton.icon(
                   label : Text(titulo),
                   icon  : Icon(icon),
                   style : OutlinedButton.styleFrom(
                           backgroundColor: Colors.white,
                           padding: EdgeInsets.all(10),
                           primary: Theme.of(context).primaryColor,
                           side   : BorderSide(color: Theme.of(context).primaryColor),
                           shape  : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                           )   
                   ),
                   onPressed: onTap,
            )
            );
  }
}