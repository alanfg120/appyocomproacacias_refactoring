import 'package:appyocomproacacias_refactoring/src/componentes/empresas/bloc/empresas_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/views/formEmpresa.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.state.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpresasPage extends StatelessWidget {
  const EmpresasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
           backgroundColor: Colors.white,
           appBar: AppBar(
                   title     : Text('Tus Empresas'),
                   elevation : 0,
           ),
           body: BlocSelector<EmpresasBloc,EmpresasState,List<Empresa>>(
                 selector : (state) => state.empresas,
                 builder  : (context,empresas){
                    if(empresas.length == 0)
                      return Center(child: Text('No hay empresas'));
                    return ListView.separated(
                           separatorBuilder: (_,i) => SizedBox(height: 15),
                           padding: const EdgeInsets.all(15),
                           itemCount: empresas.length,
                           itemBuilder: (_,i){
                             return _EmpresaList(empresa: empresas[i]);
                           }
                    );
                 },
           ),
           floatingActionButton: FloatingActionButton.extended(
                                   icon            : Icon(Icons.add,color: Colors.white),
                                   backgroundColor : Theme.of(context).primaryColor,
                                   label           : Text('Crear',style: TextStyle(color: Colors.white)),
                                   tooltip         : 'Crea una Empresa',
                                   onPressed       : context.read<HomeCubit>().state.usuario!.empresas.length >= 6
                                                     ? null
                                                     : () => NavigationService().navigateToRoute(
                                                             MaterialPageRoute(builder: (context) => FormEmpresaPage())
                                                     )
                                   ),
    );
  }
}

class _EmpresaList extends StatelessWidget {

  final Empresa empresa;
  const _EmpresaList({Key? key,required this.empresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return Row(
           children: [
              ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child       : FadeInImage(
                            width      : 65,
                            height     : 65,
                            fit        : BoxFit.cover,
                            placeholder: AssetImage('assets/imagenes/load_image.gif'), 
                            image      : CachedNetworkImageProvider('$url/logo/${empresa.urlLogo}')  
              )
              ),
              SizedBox(width: 20),
              Text('${empresa.nombre}',style: TextStyle(fontSize: 16)),
              Spacer(),
              IconButton(
              icon      : Icon(Icons.edit),
              iconSize  : 30,
              color     : Colors.green,
              onPressed : (){}, 
              ),
              IconButton(
              icon      : Icon(Icons.delete),
              iconSize  : 30,
              color     : Colors.red,
              onPressed : () => showDialog(context: context, builder: (context) => _DialogoDelete()), 
              )
          ],
    );
}
}
class _DialogoDelete extends StatelessWidget {
  const _DialogoDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
           shape   : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           title   : Text('Eliminar Empresa'),
           content : Text('Desea eliminar la empresa?'),
           actions : [
             ElevatedButton(
             child : Text('Aceptar'),
             style : ElevatedButton.styleFrom(
                     primary: Theme.of(context).primaryColor
             ),
             onPressed: () async {},
             ),
             ElevatedButton(
             child : Text('Cancelar'),
             style : ElevatedButton.styleFrom(
                     primary: Theme.of(context).accentColor
             ),
             onPressed: () async {},
             ),
           ],
    );
  }
}