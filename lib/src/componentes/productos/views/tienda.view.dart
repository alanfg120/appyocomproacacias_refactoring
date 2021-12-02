import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TiendaPage extends StatelessWidget {
  const TiendaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                             _Tabs()
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
         onTap: () {}
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