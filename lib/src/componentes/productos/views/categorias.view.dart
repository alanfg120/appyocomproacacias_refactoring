import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/views/productosCategoria.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/loadingCategorias.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriasProductosPage extends StatelessWidget {
  const CategoriasProductosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor: Colors.grey[300],
           appBar: AppBar(
                   title   : const Text('Categorias'),
                   actions : [ Padding(
                     padding: const EdgeInsets.all(18.0),
                     child: const Icon(Icons.list_alt_outlined),
                   )],
                   elevation: 0,
           ),
           body : BlocBuilder<ProductosBloc, ProductosState>(
                  builder: (context, state) {
                       if(state.loadingCategorias)
                           return LoadingCategoriasProductos();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListView.builder(
                                 itemCount: state.categorias.length,
                                 itemBuilder: (BuildContext context, int index) {
                                  
                                    return ListTile(
                                           contentPadding : EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                                           title          : Text(state.categorias[index].nombre,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                                           trailing       : Icon(Icons.arrow_forward_ios),
                                           onTap          : () => NavigationService().navigateToRoute(
                                              MaterialPageRoute(builder: (context) => ProductosByCategoriaList(categoria: state.categorias[index]))
                                           ),
                                    );
                            },
                          ),
                        ),
                      );
                   
                  },
           ),
    );
  }
}

