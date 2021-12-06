
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/cubit/usuario_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/widgets/dialogPassword.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/widgets/dialogoUsuarioData.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogImage.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/image_piker.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';





class UsuarioOptios extends StatelessWidget {

  const UsuarioOptios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor: Colors.grey[100],
           appBar: AppBar(
                   title     : Text('Opciones de Usuario'),
                   elevation : 0,
           ),
           body: SingleChildScrollView(
             child: Column(
                   children: [
                     _Perfil(),
                     Column(
                            children: [
                              _Opciones(
                               titulo: 'Empresas y productos', 
                               children: [
                                     _ItemOption(
                                      icon: Icons.business, 
                                      text: 'Tus Empresas', 
                                      onTap: () => NavigationService().navigateTo('empresas')
                                     ),
                                     _ItemOption(
                                      icon: Icons.shopping_bag, 
                                      text: 'Tus Productos', 
                                      onTap: () {
                                        NavigationService().navigateTo('productos');
                                        context.read<ProductosBloc>().add(GetProductosByUsuarioEvent());
                                      }
                                     ),
                                    
                               ],
                              ),
                                _Opciones(
                               titulo: 'Opciones de usuario', 
                               children: [
                                     _ItemOption(
                                      icon: Icons.lock, 
                                      text: 'Cambiar Contraseña', 
                                      onTap: () => showDialog(
                                                   context : context,
                                                   builder : (context)=> DialogChangePassword()
                                      )
                                     ),
                                     _ItemOption(
                                      icon: Icons.refresh, 
                                      text: 'Actualizar Datos', 
                                       onTap: () => showDialog(
                                                   context : context,
                                                   builder : (context)=> DialogChangeData()
                                      )
                                     ),
                                     _ItemOption(
                                      icon: Icons.help, 
                                      text: 'Ayuda', 
                                      onTap: () => NavigationService().navigateTo('help')
                                     ),
                                     _ItemOption(
                                      icon: Icons.logout_rounded, 
                                      text: 'Cerrar sesion', 
                                      onTap: () => context.read<HomeCubit>().logOut()
                                     ) 
                               ],
                              ),
                            ],
                     )
                   ],
             ),
           )
    );
  }
}
class _Perfil extends StatelessWidget {
  const _Perfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final url = context.read<HomeCubit>().urlImagenes;

    return BlocListener<UsuarioCubit, UsuarioState>(
      listener: (context, state) {
        if(state.updatePassword){
          snacKBar('Contraseña Cambiada', context);
          NavigationService().back();
        }
        if(state.updateData){
          snacKBar('Datos Cambiados', context);
          NavigationService().back();
        }
      },
      child: BlocSelector<UsuarioCubit,UsuarioState,Usuario>(
               selector : (state) => state.usuario,
               builder  : (context,usuario){
                 return Padding(
                        padding : const EdgeInsets.all(8.0),
                        child   : Card(
                                  shape     : RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation : 3,
                                  child     : Padding(
                                  padding   : const EdgeInsets.all(15.0),
                                  child     : Row(
                                              children: [
                                                ClipRRect(
                                                borderRadius: BorderRadius.circular(300),
                                                child:  _imagenUsuario(usuario.imagen!,url)
                                                ),
                                                SizedBox(
                                                width: 30,
                                                ),
                                                _nombre(usuario,context)
                                              ],
                       ),
                     ),
                   ),
                 );
               },
        ),
    );
  }

 Widget _nombre(Usuario? usuario,BuildContext context) {
  return Expanded(
    child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.max,
           children: [
             Text(usuario!.nombre!,style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
             SizedBox(
             height: 5,
             ), 
             RawChip(
             label     : const Text('Cambiar Foto'),
             avatar    : Icon(Icons.photo_camera,color: Colors.white),
             labelStyle: TextStyle(color: Colors.white),
             labelPadding: const EdgeInsets.all(3),
             backgroundColor: Theme.of(context).primaryColor,
             onPressed : () async {
                 showDialog(
                 context: context, 
                 builder: (context) => DialogImagePiker(
                                       titulo: 'Cambia tu Imagen', 
                                       onTapArchivo: () => _getImagen(ImageSource.gallery,context),
                                       onTapCamera : () => _getImagen(ImageSource.camera,context),
                                       complete: (){}
                 )
                 );
             },
             )
           ],
    ),
  );
}

 _imagenUsuario(ImageFile imagen,String url) {
     if(imagen.nombre.isNotEmpty && imagen.isaFile)
      return FadeInImage(
             height : 100,
             width  : 100,
             fit    : BoxFit.cover,
             placeholder: AssetImage('assets/imagenes/load_image.gif'), 
             image: FileImage(imagen.file!),
      );
    if(imagen.nombre.isNotEmpty)
      return CachedNetworkImage(
             height : 100,
             width  : 100,
             fit    : BoxFit.cover,
             placeholder: (context,url) => Image.asset('assets/imagenes/load_image.gif'), 
             errorWidget: (context,url,error) => Image.asset('assets/imagenes/logo_no_img.png'),
             imageUrl: '$url/usuarios/${imagen.nombre}'
       );
    if(imagen.nombre.isEmpty)
      return FadeInImage(
             height : 100,
             width  : 100,
             fit    : BoxFit.cover,
             placeholder: AssetImage('assets/imagenes/load_image.gif'), 
             image: AssetImage('assets/imagenes/logo_no_img.png'),
      );
   
  }

 _getImagen(ImageSource source,BuildContext context) async {
    final fileImagen = await ImageCapture.getImagen(source);
    if(fileImagen != null){
      final cubit = context.read<UsuarioCubit>();
      final usuario = cubit.state.usuario;
      final url = context.read<HomeCubit>().urlImagenes;
      await cubit.updateImagen(usuario.id, fileImagen,usuario.imagen!.nombre);
      NavigationService().back();
      CachedNetworkImage.evictFromCache('$url/usuarios/${usuario.imagen!.nombre}');
    }
  }

}
class _Opciones extends StatelessWidget {

  final  String titulo;
  final List<Widget> children;
  const _Opciones({Key? key,required this.titulo,required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
           children: [
             Padding(
             padding : EdgeInsets.all(8.0),
             child   : Text(titulo,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                      shape     : RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation : 3,
                      child     : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: children),
                      ), 
               ),
             )
           ],
    );
  }
}
class _ItemOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _ItemOption(
         {Key? key,
          required this.icon,
          required this.text,
          required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
           contentPadding: const EdgeInsets.all(8),
           leading : Icon(icon,size: 28,color: Theme.of(context).primaryColor),
           title   : Text(text),
           onTap   : onTap,

    );
  }
}
