import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/views/formproduct.view.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductosPage extends StatelessWidget {
  const ProductosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
           backgroundColor: Colors.white,
           appBar: AppBar(
                   title     : Text('Tus Productos'),
                   elevation : 0,
           ),
           body: BlocBuilder<ProductosBloc,ProductosState>(
                 builder  : (context,state){
                     final productos = state.productosOfUsuario;
                    if(state.loadingProdUsuario)
                      return Center(child: CircularProgressIndicator());
                    if(productos.length == 0)
                      return Center(child: Text('No hay productos'));
                    return ListView.separated(
                           separatorBuilder: (_,i) => SizedBox(height: 15),
                           padding: const EdgeInsets.all(15),
                           itemCount: productos.length,
                           itemBuilder: (_,i){
                             return _EmpresaList(producto: productos[i]);
                           }
                    );
                 },
           ),
           floatingActionButton: FloatingActionButton.extended(
                                   icon            : Icon(Icons.add,color: Colors.white),
                                   backgroundColor : Theme.of(context).primaryColor,
                                   label           : Text('Crear',style: TextStyle(color: Colors.white)),
                                   tooltip         : 'Crea una Empresa',
                                   onPressed       : () => NavigationService().navigateToRoute(
                                                             MaterialPageRoute(builder: (context) => FormProducto())
                                                     )
                                   ),
    );
  }
}

class _EmpresaList extends StatelessWidget {

  final Producto producto;
  const _EmpresaList({Key? key,required this.producto}) : super(key: key);

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
                            image      : CachedNetworkImageProvider('$url/galeria/${producto.imagenes[0]}')  
              )
              ),
              SizedBox(width: 20),
              Text('${producto.nombre}',style: TextStyle(fontSize: 16)),
              Spacer(),
              IconButton(
              icon      : Icon(Icons.edit),
              iconSize  : 30,
              color     : Colors.green,
              onPressed : () {} /* => NavigationService().navigateToRoute(
                 MaterialPageRoute(builder: (context) =>FormEmpresaPage(
                   update:  true,
                   producto: producto,
                 ))
              )  */
              ),
              IconButton(
              icon      : Icon(Icons.delete),
              iconSize  : 30,
              color     : Colors.red,
              onPressed : () => showDialog(context: context, builder: (context) => _DialogoDelete(idProducto : producto.id!)), 
              )
          ],
    );
}
}
class _DialogoDelete extends StatelessWidget {
  final int idProducto;
  const _DialogoDelete({Key? key,required this.idProducto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
           shape   : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           title   : Text('Eliminar Empresa'),
           content : BlocConsumer<ProductosBloc, ProductosState>(
                     listener: (context,state){
                       if(!state.loadingDelete)
                         NavigationService().back();
                     },
                     builder: (context, state) {
                       if(state.loadingDelete)
                        return Container(
                               height: 100,
                               child: Center(child: CircularProgressIndicator())
                               );
                       return Text('Desea eliminar la producto?');
                  },
           ),
           actions : [
             ElevatedButton(
             child : Text('Aceptar'),
             style : ElevatedButton.styleFrom(
                     primary: Theme.of(context).primaryColor
             ),
             onPressed: ()=> context.read<ProductosBloc>().add(DeleteProductoEvent(idProducto)),
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