


import 'package:appyocomproacacias_refactoring/src/componentes/empresas/views/perfil.empresa.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/cometario.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/like.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/views/formPublicacion.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/widget/imagenes.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/models/usuario.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicacionCard extends StatelessWidget {

  
  final Publicacion publicacion;
  final bool onlyEmpresa;
  final String url;
  final TipoUsuario usuario;


  PublicacionCard(
    {Key? key,
    required this.publicacion,
    required this.url,
    required this.usuario,
    this.onlyEmpresa = false}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {

    return Card(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
           elevation: 0,
           margin : EdgeInsets.all(4),
           child  : Column(
                     children: <Widget>[
                       _Header(publicacion: publicacion, usuario: usuario, url: url,isEmpresa: onlyEmpresa),
                       if(publicacion.imagenes.length > 0)
                       GestureDetector(
                       child : Hero(
                               tag   :publicacion.id!,
                               child : _ImagenPrincipal(url: url,imagen: publicacion.imagenes[0])
                       ),
                       onTap : () => _navigateToImagenes(publicacion.imagenes,publicacion.id!,context)
                       ),
                       if(publicacion.imagenes.length > 1)
                       _Imagenes(imagenes: publicacion.imagenes,url: url),
                       _Contenido(texto: publicacion.texto),
                       if(usuario == TipoUsuario.LODGET)
                       _Footer(publicacion: publicacion,onlyEmpresa: onlyEmpresa),
                     ],
           ),
    );
  }

_navigateToImagenes(List<String> imagenes,int id,BuildContext context) {
    NavigationService().navigateToRoute(MaterialPageRoute(
                                        builder: (context) 
                                        => ImagenesWidgetPage(imagenes: imagenes, id: id)
                                        )
    );
  }

}


class _Header extends StatelessWidget {
  final Publicacion publicacion;
  final TipoUsuario usuario;
  final String url;
  final bool isEmpresa;

  const _Header(
         {Key? key,
          required this.publicacion,
          required this.usuario,
          required this.url,
          required this.isEmpresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  trailing       : publicacion.editar && usuario == TipoUsuario.LODGET
                                   ? 
                                   IconButton(
                                   icon: Icon(Icons.more_horiz), 
                                   onPressed:  (){
                                     showModalBottomSheet(
                                     context: context, 
                                     builder: (context)=>_BottomDialogOption(publicacion: publicacion,isEmpresa: isEmpresa)
                                     );
                                   }
                                   )
                                   : null
           ),
           onTap: ()=> NavigationService().navigateToRoute(
             MaterialPageRoute(builder: (context) => PerfilEmpresaPage(empresa: publicacion.empresa))
           )
  );
  }
}

class _ImagenPrincipal extends StatelessWidget {
  final String url;
  final String imagen;
  const _ImagenPrincipal({Key? key,required this.url,required this.imagen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return SizedBox(
           height : 300,
           width  : MediaQuery.of(context).size.height,
           child  : CachedNetworkImage(
                    imageUrl    : '$url/galeria/$imagen',
                    placeholder : (context, url) =>  Image.asset('assets/imagenes/load_image.gif'),
                    errorWidget : (context, url, error) => Icon(Icons.error),
                    fit         : BoxFit.cover,
           ),
    );
  }
}

class _Imagenes extends StatelessWidget {
  
  final List<String> imagenes;
  final String url;
  const _Imagenes({Key? key,required this.imagenes,required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

class _Footer extends StatelessWidget {

  final Publicacion publicacion;
  final bool onlyEmpresa;
  const _Footer(
        {Key? key,
         required this.publicacion,
         required this.onlyEmpresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
   final usuario = context.read<HomeCubit>().state.usuario;
   final url = context.read<HomeCubit>().state.url;
       return Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[ 
                       GestureDetector(
                       child: Padding(
                              padding : EdgeInsets.all(8.0),
                              child   : Icon(Icons.thumb_up,color:Colors.pink[200]),
                       ),
                       onTap: (){
                        showDialog(
                        context : context,
                        builder : (context) => _ListLikes(
                                                url: url,
                                                onlyEmpresa: onlyEmpresa,
                                                publicacion: publicacion
                        )
                        );
                       },
                       ),
                       Text('${publicacion.usuariosLike.length}'),
                       Padding(
                       padding : EdgeInsets.all(8.0),
                       child   : Icon(Icons.textsms,color:Colors.pink[200]),
                       ),
                       Text('${publicacion.comentarios.length}'),
                       BlocBuilder<PublicacionesCubit, PublicacionesState>(
                         buildWhen: (previusState,state) => previusState.progress == state.progress,
                         builder: (context, state) {
                           return RawChip(
                                  label      : state.loadingLike
                                               ?
                                               SizedBox(
                                               child  : CircularProgressIndicator(strokeWidth: 1.0),
                                               height : 16.0,
                                               width  : 16.0,
                                               )
                                               :
                                               Text('${publicacion.megusta ? 'Me gusto': 'Me gusta'}'),
                                  labelStyle : TextStyle(color:publicacion.megusta ? Colors.pink[300] : Colors.grey[400]),
                                  onPressed  : state.loadingLike
                                               ? null
                                               : () => _likeAction(publicacion,usuario,context),
                                  avatar:Icon(
                                         Icons.thumb_up,
                                         color: publicacion.megusta ? Colors.pink[300] : Colors.grey[400]
                                  ),
                                  backgroundColor: Colors.transparent
                                  );
                         },
                       ),
                       RawChip(
                       label: const Text('Comentar'),
                       onPressed:(){
                        showDialog(
                         context: context, 
                         builder: (context) => _ListComentarios(
                                                onlyEmpresa : onlyEmpresa, 
                                                url         : url,
                                                publicacion : publicacion,
                                                usuario     : usuario!,
                         )
                        );
                       //Get.bottomSheet(_bottomSheetComentarios(publicacion.id,index));
                       },
                       avatar:Icon(Icons.textsms,color:Colors.pink[400]),
                       backgroundColor: Colors.transparent
                       ),
                      ],
     );
  }
   
  _likeAction(Publicacion publicacion, Usuario? usuario,BuildContext context) {
    if(!publicacion.megusta)
    context.read<PublicacionesCubit>().addLike(
             publicacion.id!,
             publicacion.empresa.idUsuario,
             onlyEmpresa,
             usuario!
    );
    if(publicacion.megusta)
    context.read<PublicacionesCubit>().deleteLike(
             publicacion.id!,
             publicacion.empresa.idUsuario,
             onlyEmpresa,
             usuario!
    );
  }
}

class _ListComentarios extends StatelessWidget {

  final bool onlyEmpresa;
  final String url;
  final Publicacion publicacion;
  final Usuario usuario;
  const _ListComentarios(
         {Key? key,
          required this.onlyEmpresa,
          required this.url,
          required this.publicacion,
          required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
     return AlertDialog(
            contentPadding : EdgeInsets.all(10),
            title          : Text('Comentarios'),
            content        : BlocBuilder<PublicacionesCubit,PublicacionesState>(
                             buildWhen: (previusState,state) => previusState.progress == state.progress,
                             builder: (context,state) {
                               if(publicacion.comentarios.length == 0 && !state.loadingComentario)
                                return Container(
                                       height : 300,
                                       child  : Center(child: Text('Se el primero en comentar'))
                                );
                              return _listComentarios(state);
                             },
            ),
            actions: _actions(context),
     );
  }

  _actions(BuildContext context) {
    String comentario = '';
    return [
     Divider(),
     Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
                Flexible(
                child: TextField(
                       autofocus    : true,
                       focusNode    : FocusNode(),
                       keyboardType : TextInputType.multiline,
                       maxLines     : null,
                       onChanged    : (texto) => comentario = texto,
                       decoration   : InputDecoration(
                                      filled         : true,
                                      fillColor      : Colors.white,
                                      contentPadding : EdgeInsets.all(10),
                                      hintText       : "Escriba tu Comentario",
                                      enabledBorder  : OutlineInputBorder(),
                                      focusedBorder  : OutlineInputBorder()
                       ),
                       onEditingComplete:  ()=>_sendComentario(
                                                context,
                                                comentario,
                                                publicacion.id!,
                                                publicacion.empresa.idUsuario
                       ),
                ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                child     : const Text('Enviar'),
                onPressed : ()=>_sendComentario(
                                 context,
                                 comentario,
                                 publicacion.id!,
                                 publicacion.empresa.idUsuario
                ),
                style     : ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                )
                ],  
     ),
  ];
  }

   Widget _listComentarios(PublicacionesState state) {
    final comentarios = publicacion.comentarios;
    return Container(
           height : 400,
           width  : 400,
           child  : ListView.builder(
                    itemCount  : state.loadingComentario 
                                 ? comentarios.length + 1
                                 : comentarios.length,
                    itemBuilder: (context,index){
                       if(state.loadingComentario && index == 0)
                        return ListTile(
                               leading: ShimmerLoading(
                                        child: CircleAvatar(
                                               backgroundColor: Colors.grey,
                                        )
                               ),
                               title  : ShimmerLoading(
                                        child: Container(height: 10,color: Colors.grey)
                               ),
                        );
                       if(state.loadingComentario && index > 0)
                          return _listItems(comentarios,index-1);
                       return _listItems(comentarios, index);
                    }
                    ),
    );
  }

  Widget _listItems(List<Comentario> comentarios, int index) {
    return ListTile(
           leading  : comentarios[index].usuario.imagen!.isEmpty
                      ?
                      CircleAvatar(
                      backgroundImage: AssetImage('assets/imagenes/logo_no_img.png')
                      )
                      :
                      CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        '$url/usuarios/${comentarios[index].usuario.imagen}'
                      ),
                      ),
           title    : Text(comentarios[index].usuario.nombre!),
           subtitle : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                         Text(comentarios[index].comentario),
                         SizedBox(height: 4),
                         Text(comentarios[index].formatFecha(),style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
           )
    );
  }
 
 _sendComentario(BuildContext context, String comentario,int idPublicacion,int idDestinatario) {
    if(comentario.isNotEmpty)
    context.read<PublicacionesCubit>().comentar(
            comentario     : comentario, 
            idPublicacion  : idPublicacion, 
            idDestinatario : idDestinatario, 
            usuario        : usuario, 
            isEmpresa      : onlyEmpresa
    );
  }
}

class _ListLikes extends StatelessWidget {
  final String url;
  final bool onlyEmpresa;
  final Publicacion publicacion;
  const _ListLikes(
         {Key? key,
          required this.url,
          required this.onlyEmpresa,
          required this.publicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
           contentPadding: EdgeInsets.all(10),
           title   : const Text('A estas personas les gusto'),
           content : BlocBuilder<PublicacionesCubit,PublicacionesState>(
                     buildWhen: (previusState,state) => previusState.progress == state.progress,
                     builder: (context,state){
                       if(publicacion.usuariosLike.length == 0)
                         return Container(
                                height : 300,
                                child  : Center(child: const Text('No hay me gustan')),
                         );
                       return _listLikes(publicacion.usuariosLike,url);
                     },
           ),

    );
  }

  Widget _listLikes(List<LikePublicacion> usuariosLike,String url) {
     return Container(
            height : 300,
            width  : 400,
            child  : ListView.builder(
                     itemCount   : usuariosLike.length,
                     itemBuilder : (context,i){
                                     return ListTile(
                                            leading  : usuariosLike[i].usuario.imagen== ''
                                                       ? 
                                                       CircleAvatar(
                                                         backgroundImage: AssetImage('assets/imagenes/logo_no_img.png')
                                                       )
                                                       :
                                                       CircleAvatar(
                                                       backgroundImage: CachedNetworkImageProvider(
                                                         '$url/usuarios/${usuariosLike[i].usuario.imagen}'
                                                       ),
                                                       ),
                                            title    : Text(usuariosLike[i].usuario.nombre!),
                                            subtitle : Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: <Widget>[
                                                          Text('Le gusto la Publicacion'),
                                                          SizedBox(height: 4),
                                                          Text(usuariosLike[0].formatFecha(),style: TextStyle(fontWeight: FontWeight.bold),)
                                                       ],
                 )
                 );
              },
       ),
     );
  }
}

class _BottomDialogOption extends StatelessWidget {
  final Publicacion publicacion;
  final bool isEmpresa;
  const _BottomDialogOption(
        {Key? key,
        required this.publicacion,
        required this.isEmpresa}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
           padding: EdgeInsets.all(10),
           height : 200,
           color  : Colors.white,
           child  : Column(
                    children: [
                      ListTile(
                      contentPadding: EdgeInsets.all(8),
                      title   : Text('Editar publicacion'),
                      leading : Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                                size : 30,
                                ),
                      onTap   : (){
                        NavigationService().back();
                          NavigationService().navigateToRoute(
                                        MaterialPageRoute(builder: (context) => FormPublicacionPage(
                                          publicacion: publicacion,
                                          update: true,
                                          isEmpresa: isEmpresa,
                                        ))
                                      );
                      } 
                      ),
                      ListTile(
                      contentPadding: EdgeInsets.all(8),
                      title   : Text('Eliminar publicacion'),
                      leading : Icon(
                                Icons.delete,
                                color: Theme.of(context).accentColor,
                                size : 30,
                                ),
                      onTap   : (){
                          NavigationService().back();
                          showDialog(
                          context: context, 
                          barrierDismissible: false,
                          builder: (context) => _AlertDialogDelete(publicacion: publicacion,isEmpresa: isEmpresa)
                          );
                      } 
                      )
                    ],
           ),
    );
  }
}
  
class _AlertDialogDelete extends StatelessWidget {
  final Publicacion publicacion;
  final bool isEmpresa;
  const _AlertDialogDelete(
        {Key? key,
        required this.publicacion,
        required this.isEmpresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocSelector<PublicacionesCubit,PublicacionesState,bool>(
            selector: (state) => state.loadingDelete,
            builder : (context,loading){
                      return  AlertDialog(
                        contentPadding: const EdgeInsets.all(30),
                        actionsPadding: const EdgeInsets.all(6),
                        shape   : RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        title   : const Text('Desea borrar la publicacion'),
                        content : loading
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator()
                                      ),
                                      const Text('Eliminando ...'),
                                    ],
                                    )
                                    : const Text('Esta seguro de eliminarla ?'),   
                        actions : [
                                    if(!loading)
                                    ElevatedButton(
                                    child : Text('Aceptar'),
                                    style : ElevatedButton.styleFrom(
                                            primary: Theme.of(context).primaryColor
                                    ),
                                    onPressed: () async {
                                      await context.read<PublicacionesCubit>().deletePublicacion(publicacion.id!,isEmpresa);
                                      NavigationService().back();
                                    },
                                    ),
                                    if(!loading)
                                    ElevatedButton(
                                    child : Text('Cancelar'),
                                    style : ElevatedButton.styleFrom(
                                            primary: Theme.of(context).accentColor
                                    ),
                                    onPressed: () async {
                                     NavigationService().back();
                                    },
                                    )
                        ]
                      );
            }          
    );
  }
}
