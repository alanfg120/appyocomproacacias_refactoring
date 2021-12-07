import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/bloc/pedidos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/models/pedido.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/cubit/usuario_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogLoading.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
                   title     : const Text('Pedidos'),
                   elevation : 0,
           ),
           body: SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: BlocConsumer<PedidosBloc, PedidosState>(
                          listener: (context,state){
                            if(state.loading)
                             dialogLoading(context, 'Haciendo Pedido');
                            if(!state.loading){
                              //NavigationService().back();
                              snacKBar('Pedido Realizado',context,onclose: () =>  NavigationService().back());
                            }
                             
                          },
                          listenWhen: (previosState,state) => previosState.loading != state.loading,
                          builder: (context, state) {
                            if(state.pedidos.length == 0)
                              return Center(child: const Text('No hay pedidos'));
                            return Column(
                                   children: [
                                     ...state.pedidos.asMap()
                                             .entries.map((pedido){
                                          
                                               return _CardPedido(pedido: pedido.value,index: pedido.key);
                                             })
                                   ],
                            );
                          },
                   ),
                 ),
           ),
    );
  }
}

class _CardPedido extends StatelessWidget {

  final Pedido pedido;
  final int index;
  const _CardPedido({Key? key,required this.pedido,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
               children: [
                 _empresa(pedido.empresa,url,context),
                 Divider(),
                 _listProductos(pedido.productos,url),
                 _total(pedido,context),
               ],
        ),
      ),
    );
}

Widget  _empresa(Empresa empresa,String url,BuildContext context) {
  return Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           ClipRRect(
           borderRadius: BorderRadius.circular(100),
           child: CachedNetworkImage(
                    height      : 40,
                    width       : 40,
                    imageUrl    : '$url/logo/${empresa.urlLogo}',
                    placeholder : (context, url) =>  Image.asset('assets/imagenes/load_image.gif'),
                    errorWidget : (context, url, error) => Image.asset('assets/imagenes/load_no_img.png'),
                    fit         : BoxFit.cover,
           ),
           ),
           SizedBox(width: 20),
           Expanded(
             flex: 3,
             child: Text(
             '${empresa.nombre}',
             style: TextStyle(fontSize: 20),
             overflow: TextOverflow.ellipsis,
             maxLines: 2,
             softWrap: false,
             ),
           ),
           Spacer(),
           IconButton(
           icon      : Icon(Icons.delete),
           color     : Colors.red,
           onPressed : () => context.read<PedidosBloc>().add(
             DeletePedidoEvent(indexPedido: index)
           )
           )
         ],
  );
}

Widget _listProductos(List<Producto> productos, String url) {
  return Container(
         constraints: BoxConstraints(
                      minHeight: 200,
                      maxHeight: 250
         ),
         child  : ListView.separated(
                  separatorBuilder: (_,i) => SizedBox(height: 10),
                  itemCount: productos.length,
                  itemBuilder: (BuildContext context, int i) {
                  return Row(
                         children: [
                           ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: CachedNetworkImage(
                                   height      : 60,
                                   width       : 60,
                                   imageUrl    : '$url/galeria/${productos[i].imagenes[0]}',
                                   placeholder : (context, url) =>  Image.asset('assets/imagenes/load_image.gif'),
                                   errorWidget : (context, url, error) => Image.asset('assets/imagenes/load_no_img.png'),
                                   fit         : BoxFit.cover,
                           ),
                           ),
                           SizedBox(width: 10),
                           Expanded(
                             flex: 5,
                             child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                               '${productos[i].nombre}',
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: false,
                               ),
                               SizedBox(height: 5),
                               Text('${productos[i].precioFormat}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                             ],
                             ),
                           ),
                           Spacer(),
                           IconButton(
                           icon      : Icon(Icons.arrow_left_sharp),
                           iconSize  : 35,
                           color     : Theme.of(context).primaryColor,
                              onPressed : () => context.read<PedidosBloc>()
                                                    .add(DeleteCantidadProductoEvent(
                                                         idProducto: productos[i].id!,
                                                         indexPedido: index
                                                     )
                                            )
                           ),
                           Text('${productos[i].cantidad}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w300)),
                           IconButton(
                           icon      : Icon(Icons.arrow_right_sharp),
                           iconSize  : 45,
                           color     : Theme.of(context).accentColor,
                           onPressed : () => context.read<PedidosBloc>()
                                                    .add(AddCantidadProductoEvent(
                                                         idProducto: productos[i].id!,
                                                         indexPedido: index
                                                     )
                                            )
                           ),
                         ],
                  );
             },
         ),
  );
}

Widget _total(Pedido pedido,BuildContext context) {
  final total = pedido.calcularTotal();
  return Row(
         
         children: [
           Text('Total:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
           SizedBox(width: 10),
           Text('$total',style: TextStyle(fontSize: 20)),
           Spacer(),
           SizedBox(
             width : 90,
             height: 30,
             child: ElevatedButton(
             child : const Text('Pedir'),
             style : ElevatedButton.styleFrom(
                     primary   : Theme.of(context).primaryColor,
                     textStyle : TextStyle(color: Colors.white),
                     shape     : RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
             ),
             onPressed: () => showDialog(
                              context: context,
                              builder: (context) => _DialogoObervacion(pedido: pedido)
                              ),
             ),
           )
         ],
  );
}

 

}

class _DialogoObervacion extends StatelessWidget {
  final Pedido pedido;
  const _DialogoObervacion({Key? key,required this.pedido}) : super(key: key);

  @override
  Widget build(BuildContext context){
    final nombre = context.read<UsuarioCubit>().state.usuario.nombre;
    String observacion = '';
    return AlertDialog(
           title   : Text('Enviar Pedido'),
           content : InputForm(
                     placeholder : 'Observacion',
                     autofocus   : true,
                     textarea    : true,
                     onChanged   : (text) => observacion = text,
           ),
           actions : [
              ElevatedButton(
             child : Text('Aceptar'),
             style : ElevatedButton.styleFrom(
                     primary: Theme.of(context).primaryColor
             ),
             onPressed: () {
              final newPedido = pedido.copyWith(observacion: observacion);
              context.read<PedidosBloc>().add(SendPedidoEvent(pedido: newPedido,nombreUsuario: nombre!));
              NavigationService().back();
             }
             ),
             ElevatedButton(
             child : Text('Cancelar'),
             style : ElevatedButton.styleFrom(
                     primary: Theme.of(context).accentColor
             ),
             onPressed: () => NavigationService().back(),
             ),
           ],
    );
  }
}