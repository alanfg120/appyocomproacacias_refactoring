import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/bloc/pedidos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/models/pedido.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/cardProducto.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/cardEmpresa.widget.dart';
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
                   padding: const EdgeInsets.all(10.0),
                   child: BlocBuilder<PedidosBloc, PedidosState>(
                          builder: (context, state) {
                            if(state.pedidos.length == 0)
                              return Center(child: const Text('No hay pedidos'));
                            return Column(
                                   children: [
                                     ...state.pedidos.map((pedido) => _CardPedido(pedido: pedido))
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
  const _CardPedido({Key? key,required this.pedido}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
                children: [
                  CardEmpresa(empresa: pedido.empresa, url: url),
                  ...pedido.productos 
                    .map((producto) => CardProducto(producto: producto, url: url,cantidad: true,)),
                  SizedBox(height: 10),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                    Text('${pedido.calcularTotal()}',style: TextStyle(fontSize: 35,fontWeight: FontWeight.w300),)
                  ],
                  ),
              
         ],
        ),
    );
  }
}