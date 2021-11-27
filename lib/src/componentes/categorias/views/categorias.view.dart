import 'package:appyocomproacacias_refactoring/src/componentes/categorias/bloc/categorias_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/categoria.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/views/listEmpresas.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/widgets/categoriaCard.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class CategoriasPage extends StatelessWidget {
  const CategoriasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
            return Scaffold(
                   appBar: AppBar(
                           leading   : Image.asset('assets/imagenes/logo.png'),
                           title     : Text('Categorias'),
                           elevation : 0,
                           ),
                   body  : Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                     child: Table(
                             //border: TableBorder.all(),
                             children: [
                               TableRow(
                               children: [
                                 CategoriaCard(
                                 titulo : "Comidas",
                                 imagen : "assets/imagenes/restaurante.png",
                                 onTap  : () {
                                   _toListEmpresas("assets/imagenes/restaurante.png","Comidas",CategoriaEnum.Comida);
                                   context.read<CategoriasBloc>().add(GetEmpresasEvent(_getCategoria(CategoriaEnum.Comida)));
                                 }
                                 ),
                                 CategoriaCard(
                                 titulo : "Hospedaje",
                                 imagen : "assets/imagenes/hospedage.png",
                                 onTap  : () {
                                    _toListEmpresas("assets/imagenes/hospedage.png","Hospedaje",CategoriaEnum.Hospedaje);
                                    context.read<CategoriasBloc>().add(GetEmpresasEvent(_getCategoria(CategoriaEnum.Hospedaje)));
                                  }
                                 )
                                ]
                               ),
                               TableRow(
                               children: [
                                 CategoriaCard(
                                 titulo: "Compras",
                                 imagen: "assets/imagenes/compras.png",
                                 onTap  : () {
                                    _toListEmpresas("assets/imagenes/compras.png","Compras",CategoriaEnum.Compras);
                                    context.read<CategoriasBloc>().add(GetEmpresasEvent(_getCategoria(CategoriaEnum.Compras)));
                                 }
                                 ),
                                 CategoriaCard(
                                 titulo : "Turismo",
                                 imagen : "assets/imagenes/turismo.png",
                                 onTap  : () {
                                    _toListEmpresas("assets/imagenes/turismo.png","Turismo",CategoriaEnum.Turismo);
                                    context.read<CategoriasBloc>().add(GetEmpresasEvent(_getCategoria(CategoriaEnum.Turismo)));
                                 }
                                 ),
                                ]
                               ),
                               TableRow(
                               children: [
                                 CategoriaCard(
                                 titulo: "Entretenimiento",
                                 imagen: "assets/imagenes/entrenimiento.png",
                                onTap  : () {
                                  _toListEmpresas("assets/imagenes/entrenimiento.png","Entretenimiento",CategoriaEnum.Entretenimiento);
                                    context.read<CategoriasBloc>().add(GetEmpresasEvent(_getCategoria(CategoriaEnum.Entretenimiento)));
                                 }
                                 ),
                                 CategoriaCard(
                                 titulo: "Otras",
                                 imagen: "assets/imagenes/opciones.png",
                                 onTap: (){
                                   context.read<CategoriasBloc>().add(GetCategoriasEvent());
                                   NavigationService().navigateTo('categorias');
                                 }
                                 ),
                                ]
                               ),
                              ],
                     ),
                   ),
            );
          
          
  }

  void _toListEmpresas(String asset,String titulo,CategoriaEnum categoria) {
    NavigationService().navigateToRoute(
     MaterialPageRoute(builder: (context) => ListEmpresaCategorias(
                                             assetImage : asset,
                                             titulo     : titulo,
                                             categoria  : categoria,
                                             )
                                            )
    );
  }
  String _getCategoria(CategoriaEnum categoria){
    return categoria.toString().split('.')[1];
  }
}