import 'package:appyocomproacacias_refactoring/src/componentes/empresas/views/perfil.empresa.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/cometario.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/like.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/widget/imagenes.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicacionWidget extends StatelessWidget {

  const PublicacionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicacionesCubit,PublicacionesState>(
              builder  : (context,state){
              if(state.loading)
                return Center(child: CircularProgressIndicator());
              return SingleChildScrollView(
                     child: Column(
                            children: [
                             _CardPublicacion(publicacion: state.publicacion!),
                             _Tabs(pagina: state.pagina),
                              AnimatedSwitcher(
                              switchInCurve : Curves.linear,
                              duration      : Duration(milliseconds: 300),
                              child         : IndexedStack(
                                              key     : ValueKey<int>(state.pagina),
                                              index   : state.pagina,
                                              children: [
                                                     _Comentarios(comentarios: state.publicacion!.comentarios),
                                                     _Likes(likes: state.publicacion!.usuariosLike)
                                              ],  
            ),
            )
                            ],
                     ),
              );
    
              },
       );
  }
}
class _CardPublicacion extends StatelessWidget {

  final Publicacion publicacion;
  const _CardPublicacion({Key? key,required this.publicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return   Card(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
             elevation: 0,
             margin : EdgeInsets.all(4),
             child  : Column(
                      children: <Widget>[
                               _Header(publicacion: publicacion),
                               _Contenido(texto:publicacion.texto),
                               if(publicacion.imagenes.length > 0)
                               GestureDetector(
                               child  : Hero(
                                        tag   : publicacion.id!,
                                        child : SizedBox(
                                                height : 300,
                                                width  : double.infinity,
                                                child  : CachedNetworkImage(
                                                         imageUrl    : '$url/galeria/${publicacion.imagenes[0]}',
                                                         placeholder : (context, url) => Center(child: CircularProgressIndicator()),
                                                         errorWidget : (context, url, error) => Icon(Icons.error),
                                                         fit         : BoxFit.cover,
                                                ),
                                        )
                               ),
                               onTap  : () =>
                                 NavigationService().navigateToRoute(
                                   MaterialPageRoute(
                                   builder: (context) =>  ImagenesWidgetPage(
                                                          imagenes : publicacion.imagenes,
                                                          id       : publicacion.id!
                                   ))
                                 ),
                               ),
                               if(publicacion.imagenes.length > 1)
                               _Imagenes(imagenes:publicacion.imagenes),
                      ],
             ),
             );
  }


}

class _Header extends StatelessWidget {

  final Publicacion publicacion;
  
  const _Header({Key? key,required this.publicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return   GestureDetector(
           child: ListTile(
                  contentPadding : EdgeInsets.all(4),
                  leading        : publicacion.empresa.urlLogo == '' 
                                   ? CircleAvatar(backgroundImage: AssetImage('assets/imagenes/logo_no_img.png'))
                                   : CircleAvatar(
                                   radius: 24,
                                   backgroundImage: CachedNetworkImageProvider('$url/logo/${publicacion.empresa.urlLogo}'),    
                  ),
                  title          : Text(
                                   publicacion.empresa.nombre,
                                   style:TextStyle(fontWeight:FontWeight.bold)
                                  ),
                  subtitle       : Text(publicacion.formatFecha()),
           ),
           onTap: ()=> NavigationService().navigateToRoute(
                       MaterialPageRoute(builder: (context) => PerfilEmpresaPage(empresa: publicacion.empresa))
           )
          
  );
  }
}

class _Contenido extends StatelessWidget {
  final String texto;
  const _Contenido({Key? key,required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return  Container(
              alignment : Alignment.topLeft,
              padding   : EdgeInsets.all(8),
              child     : Text(texto),
      );
  }
}

class _Imagenes extends StatelessWidget {
  
  final List<String> imagenes;
  const _Imagenes({Key? key,required this.imagenes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
   return SizedBox(
    child: Row(
           mainAxisSize: MainAxisSize.max,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
            ...imagenes.skip(1).map((imagen) => 
                 Expanded(
                   child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: FittedBox(
                                 fit: imagenes.length == 2 ? BoxFit.contain : BoxFit.fill,
                                 alignment: Alignment.topLeft,
                                 child  : Container(
                                     decoration: BoxDecoration(
                                                 border: Border.all(
                                                    width: 10,
                                                    color: Colors.white
                                                 )
                                     ),
                                     child: CachedNetworkImage(
                                            imageUrl    : '$url/galeria/$imagen',
                                            placeholder : (context, url) =>  Image.asset('assets/imagenes/load_image.gif'),
                                            errorWidget : (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                     ),
                   ),
                 )
            
            )
           ],
    ),
  );
  }
}

class _Tabs extends StatelessWidget {
  
  final int pagina;
  const _Tabs({Key? key,required this.pagina}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     RawChip(
                     label           : Text('Comentarios'),
                     backgroundColor : pagina == 0 ? Theme.of(context).primaryColor : Colors.grey[200],
                     labelStyle      : TextStyle(color: pagina == 0 ? Colors.white : Colors.black54),
                     onPressed       : ()=> context.read<PublicacionesCubit>().tabChangePagina(0)
                     ),
                     RawChip(
                     label           : Text('Me gustan'),
                     backgroundColor : pagina == 1 ? Theme.of(context).primaryColor : Colors.grey[200],
                     labelStyle      : TextStyle(color: pagina == 1 ? Colors.white : Colors.black54),
                     onPressed       : ()=> context.read<PublicacionesCubit>().tabChangePagina(1)
                     ),
                  
                   ],  
          );
  }
}

class _Comentarios extends StatelessWidget {

  final List<Comentario> comentarios;
  const _Comentarios({Key? key,required this.comentarios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return Column(
            children: comentarios.map<Widget>((comentarios){
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(10)
                ),
                child: ListTile(
                       contentPadding: EdgeInsets.all(5),
                       leading  : comentarios.usuario.imagen == ''
                                  ?
                                  CircleAvatar(
                                  maxRadius: 40,
                                  backgroundImage: AssetImage('assets/imagenes/logo_no_img.png')
                                  )
                                  :
                                  CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    '$url/usuarios/${comentarios.usuario.imagen}'
                                  ),
                                  ),
                       title    : Text(comentarios.usuario.nombre!),
                       subtitle : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                     Text(comentarios.comentario),
                                     SizedBox(height: 4),
                                     Text(comentarios.formatFecha(),style: TextStyle(fontWeight: FontWeight.bold),)
                                  ],
                       )
                       ),
              );
            }).toList(),
     );
  }
}

class _Likes extends StatelessWidget {
  final List<LikePublicacion> likes;
  const _Likes({Key? key,required this.likes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
     return Column(
             children: likes.map<Widget>((usuarios){
               return  ListTile(
                              leading  : usuarios.usuario.imagen== ''
                                         ? 
                                         CircleAvatar(
                                           backgroundImage: AssetImage('assets/imagenes/logo_no_img.png')
                                         )
                                         :
                                         CircleAvatar(
                                         backgroundImage: CachedNetworkImageProvider(
                                           '$url/usuarios/${usuarios.usuario.imagen}'
                                         ),
                                         ),
                              title    : Text(usuarios.usuario.nombre!),
                              subtitle : Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: <Widget>[
                                            Text('Le gusto la Publicacion'),
                                            SizedBox(height: 4),
                                            //Text(usuarios[0].formatFecha(),style: TextStyle(fontWeight: FontWeight.bold),)
                                         ],
                              )
                              );
             }).toList(),
      );
  }
}