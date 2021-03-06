
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/bloc/empresas_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/formpublicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/publicacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogBack.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogImage.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogLoading.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/image_piker.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';




class FormPublicacionPage extends StatelessWidget {

  final bool update,isEmpresa;
  final Publicacion? publicacion;
  final int? index;

  FormPublicacionPage(
     {Key? key,
      this.update = false,
      this.isEmpresa = false,
      this.publicacion,
      this.index}) : super(key: key);
  final formKey = GlobalKey<FormState>();



  final _bloc = FormPublicacionesCubit();
  final FocusNode blankNode = FocusNode();
  @override
  Widget build(BuildContext context) {

    String textoForm = update ? publicacion!.texto : '';
    final url = context.read<HomeCubit>().urlImagenes;
    final empresas = context.read<EmpresasBloc>().state.empresas;


    return BlocProvider<FormPublicacionesCubit>(
      create: (context) => _bloc..getDataPublicacionUpdate(publicacion, empresas),
      child: BlocListener<PublicacionesCubit, PublicacionesState>(
               listener: (context, state) {
                 if(state.loadingAdd){
                   dialogLoading(context, 'Publicando',true);
                 }
                 if(!state.loadingAdd ){
                   NavigationService().back();
                 }
             },
          listenWhen:(previusState,state){
            return previusState.loadingAdd != state.loadingAdd;
          },
          child: WillPopScope(
                 onWillPop : () async => _onWillpop(context),
                 child     : GestureDetector(
                             child:  Scaffold(
                                     appBar: AppBar(
                                     title     : Text('${update ? 'Actuliza' : 'Agregar'} tu Publicaci??n'),
                                     elevation : 0,
                                     ),
                             body  : SingleChildScrollView(
                                    padding : EdgeInsets.all(20),
                                    child   : Form(
                                              key   : formKey,
                                              child : Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                           InputForm(
                                                           placeholder : 'Escribe Tu publicaci??n',
                                                           textarea    : true,
                                                           requerido   : true,
                                                           initialValue: textoForm,
                                                           onChanged   : (texto)=> textoForm = texto,
                                                           ),
                                                           _escogerEmpresa(context,empresas,url),
                                                           SizedBox(height: 10),
                                                           Text('Imagenes (m??ximo 5)'),
                                                           SizedBox(height: 10),
                                                           _Imagenes(bloc: _bloc,url: url)
                                                      ]
                                              )
                                    ),
                             ),
                             floatingActionButton: FloatingActionButton.extended(
                                                   heroTag         : 'publicar',
                                                   backgroundColor : Theme.of(context).primaryColor,
                                                   icon            : Icon(Icons.add,color: Colors.white),
                                                   label           : Text('${update ? 'Actualizar' : 'Publicar'}',style:TextStyle(color: Colors.white)),
                                                   onPressed       : () async {
                                                     if(formKey.currentState!.validate() 
                                                        && _bloc.state.imagenes.length > 0 
                                                        && _bloc.state.empresa != null){
                                                         final publicacion = Publicacion(
                                                                             id      : update ? this.publicacion!.id : null,
                                                                             editar  : true,
                                                                             empresa : _bloc.state.empresa!,
                                                                             imagenes: _bloc.state.imagenes.map((i) => i.nombre).toList(),
                                                                             megusta : update ? this.publicacion!.megusta : false,
                                                                             texto   : textoForm,
                                                                             fecha   : DateTime.now().toIso8601String(),
                                                                             comentarios  : update ? this.publicacion!.comentarios   : [],
                                                                             usuariosLike : update ? this.publicacion!.usuariosLike  : []
                                                         );
                                                         if(!update)
                                                         await context.read<PublicacionesCubit>().addPublicacion(publicacion,_bloc.state.imagenes);
                                                         if(update)
                                                         await context.read<PublicacionesCubit>().updatePublicacion(publicacion,_bloc.state.imagenes,url,isEmpresa);
                                                         NavigationService().back();
                                                     }
                                                     else snacKBar('Faltan Datos', context);
                                                   }
                             ),
                     ),
                         
                         
                  onTap: ()=>FocusScope.of(context).requestFocus(blankNode)
                 ),
            ),
        ),
    );
}

Widget _escogerEmpresa(BuildContext context,List<Empresa> empresas,String url) {
  return ListTile(
         leading : Icon(Icons.business),
         title   : BlocBuilder<FormPublicacionesCubit, FormPublicacionesState>(
                   bloc: _bloc,
                   builder: (context, state) {
                     if(state.selecionada == -1)
                       return Text('Selecione Empresa');
                     return Text('${state.empresa!.nombre}');
                   },
         ),
         onTap   : update  
                   ? null 
                   : () => showDialog(
                           context: context, 
                           builder: (context) => _Empresas(
                                                 empresas: empresas,
                                                 url: url,
                                                 bloc:_bloc,
                                                 update: update,
                                                 
                           )
                   )
  );
}

Future<bool> _onWillpop(context) async {
   final bool? result =  await showDialog(
      context: context,
      builder: (context) => DialogBack(),
    );
    if(result != null){
      if(result){
      //await _bloc.deleteFiles();
      _bloc.close();
    }
    }
    return result ?? false;
  }

}

class _Empresas extends StatelessWidget {

  final List<Empresa> empresas;
  final String url;
  final FormPublicacionesCubit bloc;
  final bool update;


  _Empresas({
     Key? key,
     required this.empresas,
     required this.url,
     required this.bloc,
     required this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
           contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 8),
           title   : Text('Escoja la Empresa'),
           content : BlocBuilder<FormPublicacionesCubit,FormPublicacionesState>(
                     bloc: bloc,
                     builder: (context,state){
                       return _listEmpresas(context,state.selecionada);
                     },
           ),
           actions: [
             ElevatedButton(
             child     : const Text('Aceptar'),
             onPressed : ()=> NavigationService().back(), 
             style     : ElevatedButton.styleFrom(
                         primary: Theme.of(context).primaryColor
             ),
             )
           ],
    );
  }

  Widget _listEmpresas(BuildContext context,int selecionada) {
    return Container(
      width: 300,
      height: 300,
      child: ListView.builder(
             itemCount   : empresas.length,
             itemBuilder : (context,index){
               return ListTile(
                      leading  : CircleAvatar(
                                 radius: 25,
                                 backgroundImage: CachedNetworkImageProvider(
                                   '$url/logo/${empresas[index].urlLogo}'              
                                 ),
                      ),
                      title    : Text('${empresas[index].nombre}'), 
                      onTap    : (){
                         if(empresas[index].estado){
                           bloc.selectEmpresa(empresas[index],index);
                        }
                        else {
                          NavigationService().back();
                          snacKBar('Empresa no Autorizada', context);
                        }
                      },
                      trailing : selecionada == index
                                 ? Icon(Icons.check_box,color: Colors.green)
                                 : null
               );    
             }
      ),
    );
  }
}

class _Imagenes extends StatelessWidget {
  final FormPublicacionesCubit bloc;
  final String url;
  const _Imagenes(
         {Key? key,
         required this.bloc,
         required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormPublicacionesCubit,FormPublicacionesState>(
           bloc: bloc,
           builder: (context,state){
              return Wrap(
                     spacing    : 2,
                     runSpacing : 2,
                     children   : [
                            if(state.imagenes.length < 5)
                            GestureDetector( 
                            child: Container(
                                   height : 100,
                                   width  : MediaQuery.of(context).size.width *0.29,
                                   color  : Colors.grey[350],
                                   child  : Center(child:Icon(Icons.add,color: Colors.white)),
                            ),
                            onTap: ()=> showDialog(
                                        context: context, 
                                        builder: (context) => DialogImagePiker(
                                                              titulo       : 'Selecione una Imagen', 
                                                              onTapArchivo : ()=> _getImage(ImageSource.gallery),
                                                              onTapCamera  : ()=> _getImage(ImageSource.camera),
                                                              complete     : (){}
                                        )
                            )
                            ),
                            ...state.imagenes.asMap()
                                             .entries
                                             .map((imagen) => GestureDetector(
                                                              child: imagen.value.isaFile
                                                                     ? FadeInImage(
                                                                       height      : 100,
                                                                       width       : MediaQuery.of(context).size.width *0.29,
                                                                       fit         : BoxFit.cover,
                                                                       placeholder : AssetImage('assets/imagenes/load_image.gif'), 
                                                                       image       : FileImage(imagen.value.file!),
                                                                     )
                                                                     : FadeInImage(
                                                                       height      : 100,
                                                                       width       : MediaQuery.of(context).size.width *0.29,
                                                                       fit         : BoxFit.cover,
                                                                       placeholder : AssetImage('assets/imagenes/load_image.gif'), 
                                                                       image       : CachedNetworkImageProvider('$url/galeria/${imagen.value.nombre}'),
                                                                     ),
                                                              onTap: ()=> showDialog(
                                                                          context: context, 
                                                                          builder: (context) => DialogImagePiker(
                                                                                                titulo       : 'Selecione una Imagen', 
                                                                                                onTapArchivo : ()=> _getImage(
                                                                                                                    ImageSource.gallery,
                                                                                                                    update : true,
                                                                                                                    index  : imagen.key,
                                                                                                                    imagen : imagen.value
                                                                                                ),
                                                                                                onTapCamera  : ()=> _getImage(
                                                                                                                    ImageSource.camera,
                                                                                                                    update : true,
                                                                                                                    index  : imagen.key,
                                                                                                                    imagen : imagen.value
                                                                                                ),
                                                                                                complete     : (){}
                                                                          )
                                                              )
                                               )
                             
                                            ),
                                   ],
              ); 
           }
    );
  }
  _getImage(ImageSource source,{bool update = false,int? index,ImageFile? imagen}) async {
    final image  = await ImageCapture.getImagen(source);
    if(image != null && !update)
      bloc.addImagen(image);
    if(image != null && update)
      bloc.updateImagen(image,imagen,index!);
  }
}

