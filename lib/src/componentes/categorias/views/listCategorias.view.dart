import 'package:appyocomproacacias_refactoring/src/componentes/categorias/bloc/categorias_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/categoria.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/categoria.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/views/listEmpresas.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/widgets/loadingCategorias.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ListCategoriasPage extends StatelessWidget {

  ListCategoriasPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriasBloc,CategoriasState>(
             builder: (context,state){
             return Scaffold(
                    appBar : AppBar(
                             title     : const Text('Categorias'),
                             elevation : 0,
                    ),
                    body : state.loading
                           ?
                           ListCategoriasLoading()
                           :
                           _ListCategorias(categorias: state.categorias)
         );
        }
        );
  }

}
class _ListCategorias extends StatelessWidget {
  final List<Categoria> categorias;
  const _ListCategorias({Key? key,required this.categorias}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return  ListView.builder(
             itemCount  : categorias.length,
             itemBuilder: (context,index){
                    return ListTile(
                           title: Text(categorias[index].nombre),
                           leading: CircleAvatar(
                                    child           : Text('${index +1}',style:TextStyle(color: Colors.white)),
                                    backgroundColor : Theme.of(context).primaryColor
                           ),
                           trailing: Icon(Icons.arrow_forward_ios),
                           onTap: () {
                             _toListEmpresas(categorias[index].nombre,CategoriaEnum.Otra);
                             context.read<CategoriasBloc>().add(GetEmpresasEvent(categorias[index].nombre));
                           }
                              
                           ,
                    );
             }
      );
  }
   void _toListEmpresas(String titulo,CategoriaEnum categoria) {
    NavigationService().navigateToRoute(
     MaterialPageRoute(builder: (context) => ListEmpresaCategorias(
                                             assetImage     : '',
                                             titulo         : titulo,
                                             categoria      : categoria,
                                             otherCategoria : titulo,
                                             )
                                            )
    );
  }

}
