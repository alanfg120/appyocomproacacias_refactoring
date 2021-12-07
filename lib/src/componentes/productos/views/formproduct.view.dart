import 'package:appyocomproacacias_refactoring/src/componentes/empresas/bloc/empresas_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/cubit/formproductos_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/categoriaProducto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
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

class FormProducto extends StatelessWidget {

 final bool update;
 final Producto? producto;

 FormProducto({
    Key? key,
    this.update = false,
    this.producto}
 ) : super(key: key);


 final FormProductosCubit _bloc = FormProductosCubit();
 final formKey = GlobalKey<FormState>();
 final focoNombre             = FocusNode();
 final focoDescripcion        = FocusNode();
 final focoPrecio             = FocusNode();
 final focoDetalleOferta      = FocusNode();
 FocusNode blankNode = FocusNode();


  @override
  Widget build(BuildContext context) {

    final url = context.read<HomeCubit>().urlImagenes;
    final empresas = context.read<EmpresasBloc>().state.empresas;
    final categorias = context.read<ProductosBloc>().state.categorias;
   
    String nombre       = update ? producto!.nombre            : '';
    String descripcion  = update ? producto!.descripcion       : '';
    String precio       = update ? '${producto!.precio}'       : '';
    String detalle      = update ? producto!.descripcionOferta : '';
    
  
    return BlocProvider<FormProductosCubit>(
           create: (context) => _bloc..getDataUpdate(producto, empresas, categorias),
           child: BlocListener<ProductosBloc, ProductosState>(
             listener: (context, state) {
                if(state.loadingForm)
                 dialogLoading(context, 'Agregando Producto',true);
                if(!state.loadingForm){
                   NavigationService().back();
                   snacKBar('Producto ${update ? 'Actualizado': 'Creado'}',
                             context,
                             onPressed: ()=> NavigationService().back(),
                             onclose  : ()=> NavigationService().back()
                   );
                }
               
             },
             listenWhen:(previusState,state){
                return previusState.loadingForm != state.loadingForm;
             },
             child: WillPopScope(
                             onWillPop : () async => _onWillpop(context),
                              child: GestureDetector(
                               child: Scaffold(
                                      appBar: AppBar(
                                           title: Text('${update ? 'Actualizar' : 'Agregar '} Producto'),
                                           elevation: 0,
                                      ),
                                      body: SingleChildScrollView(
                                                padding: EdgeInsets.all(25),
                                                child: Form(
                                                       key:   formKey,
                                                       child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                               Text('Agrega hasta 5 imagenes'),
                                                               SizedBox(height: 30),
                                                               _Imagenes(bloc:_bloc,url: url),
                                                               SizedBox(height: 15),
                                                               _EscojerEmpresa(bloc:_bloc,url:url,empresas: empresas),
                                                               SizedBox(height: 15),
                                                               _EscojerCategoria(bloc:_bloc,categorias: categorias),
                                                               SizedBox(height: 15),
                                                               InputForm(
                                                               placeholder       : 'Nombre',
                                                               foco              : focoNombre,
                                                               leftIcon          : Icons.text_snippet,
                                                               requerido         : true,
                                                               onChanged         : (text) => nombre = text,
                                                               initialValue      : nombre,
                                                               onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoDescripcion)
                                                               ),
                                                               InputForm(
                                                               placeholder       : 'Descripción',
                                                               foco              : focoDescripcion,
                                                               leftIcon          : Icons.description,
                                                               textarea          : true,
                                                               requerido         : true,
                                                               initialValue      : descripcion,
                                                               onChanged         : (text) => descripcion = text,
                                                               onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoPrecio)
                                                               ),
                                                               InputForm(
                                                               placeholder       : 'Precio',
                                                               foco              : focoPrecio,
                                                               leftIcon          : Icons.monetization_on_outlined,
                                                               number            : true,
                                                               requerido         : true,
                                                               initialValue      : precio,
                                                               onChanged         : (text) => precio = text,
                                                               ),
                                                               _Oferta(),
                                                               BlocBuilder<FormProductosCubit, FormProductosState>(
                                                                 bloc: _bloc,
                                                                 builder: (context, state) {
                                                                   return InputForm(
                                                                          placeholder       : 'Detalle de oferta',
                                                                          enabled           : state.oferta,
                                                                          foco              : focoDetalleOferta,
                                                                          leftIcon          : Icons.star_rate_outlined,
                                                                          initialValue      : detalle, 
                                                                          onChanged         : (text) => detalle = text,                               
                                                                   );
                                                                 },
                                                               ),
                                                               MaterialButton(
                                                               padding   : const EdgeInsets.all(16),
                                                               color     : Theme.of(context).primaryColor,
                                                               textColor : Colors.white,
                                                               child     : Text('${update ? 'Actualizar' : 'Agregar'}'),
                                                               minWidth  : double.maxFinite,
                                                               onPressed: (){
                                                                if(_bloc.state.empresaSelecionada != -1 
                                                                   &&_bloc.state.categoriaSelecionada != -1
                                                                   &&_bloc.state.imagenes.length > 0
                                                                   && formKey.currentState!.validate()){
                                                                   final newProducto = Producto(
                                                                                       id                : update ? producto!.id : null,
                                                                                       nombre            : nombre,
                                                                                       descripcion       : descripcion,
                                                                                       categoria         : _bloc.state.categoria!,
                                                                                       empresa           : _bloc.state.empresa!,
                                                                                       descripcionOferta : detalle,
                                                                                       cantidad          : 0,
                                                                                       imagenes          : _bloc.state.imagenes.map((i) => i.nombre).toList(),
                                                                                       oferta            : _bloc.state.oferta,
                                                                                       precio            : int.parse(precio)
                                                                    );
                                                                    if(!update)
                                                                     context.read<ProductosBloc>()
                                                                             .add(AddProductoEvent(
                                                                                  producto: newProducto,
                                                                                  idEmpresa: _bloc.state.empresa!.id!,
                                                                                  imagenes:  _bloc.state.imagenes
                                                                     ));
                                                                    if(update)
                                                                     context.read<ProductosBloc>()
                                                                             .add(UpdateProductoEvent(
                                                                                  producto: newProducto,
                                                                                  imagenes:  _bloc.state.imagenes,
                                                                                  url: url
                                                                     ));
                                                                 }
                                                                 else snacKBar('Faltan Datos', context);
                                                               }
                                                               )
                                                              ],
                                                       )
                                                ),
                                     )
                                ),
                                onTap : ()=>FocusScope.of(context).requestFocus(blankNode),
                              ),
                      ),
           ),
    );
  }

Future<bool> _onWillpop(context) async {
   final result =  await showDialog(
      context: context,
      builder: (context) => DialogBack(),
    );
    return result;
  }

}

class _Imagenes extends StatelessWidget {
  final FormProductosCubit bloc;
  final String url;
  const _Imagenes(
         {Key? key,
         required this.bloc,
         required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FormProductosCubit,FormProductosState,List<ImageFile>>(
           selector: (state) => state.imagenes,
           builder: (context,imagenes){
              return Wrap(
                     spacing    : 2,
                     runSpacing : 2,
                     children   : [
                            if(imagenes.length < 5)
                            GestureDetector( 
                            child: Container(
                                   height : 100,
                                   width  : MediaQuery.of(context).size.width *0.25,
                                   color  : Colors.grey[350],
                                   child  : Center(child:Icon(Icons.add,color: Colors.white)),
                            ),
                            onTap: ()=> showDialog(
                                        context: context, 
                                        builder: (context) => DialogImagePiker(
                                                              titulo       : 'Selecione una Imagen', 
                                                              onTapArchivo : (){
                                                                _getImage(context,ImageSource.gallery);
                                                                NavigationService().back();
                                                              },
                                                              onTapCamera  : (){
                                                                _getImage(context,ImageSource.gallery);
                                                                NavigationService().back();
                                                              },
                                                              complete     : (){}
                                        )
                            )
                            ),
                            ...imagenes.asMap()
                                             .entries
                                             .map((imagen) => GestureDetector(
                                                              child: imagen.value.isaFile
                                                                     ? FadeInImage(
                                                                       height      : 100,
                                                                       width       : MediaQuery.of(context).size.width *0.25,
                                                                       fit         : BoxFit.cover,
                                                                       placeholder : AssetImage('assets/imagenes/load_image.gif'), 
                                                                       image       : FileImage(imagen.value.file!),
                                                                     )
                                                                     : FadeInImage(
                                                                       height      : 100,
                                                                       width       : MediaQuery.of(context).size.width *0.25,
                                                                       fit         : BoxFit.cover,
                                                                       placeholder : AssetImage('assets/imagenes/load_image.gif'), 
                                                                       image       : CachedNetworkImageProvider('$url/galeria/${imagen.value.nombre}'),
                                                                     ),
                                                              onTap: ()=> showDialog(
                                                                          context: context, 
                                                                          builder: (context) => DialogImagePiker(
                                                                                                titulo       : 'Selecione una Imagen', 
                                                                                                onTapArchivo : ()=> _getImage(
                                                                                                                    context,
                                                                                                                    ImageSource.gallery,
                                                                                                                    update : true,
                                                                                                                    index  : imagen.key,
                                                                                                                    imagen : imagen.value
                                                                                                ),
                                                                                                onTapCamera  : ()=> _getImage(
                                                                                                                    context,
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
  _getImage(BuildContext context,ImageSource source,{bool update = false,int? index,ImageFile? imagen}) async {
    final image  = await ImageCapture.getImagen(source);
    if(image != null && !update)
      bloc.addImagen(image);
    if(image != null && update)
      bloc.updateImagen(image,imagen,index!);
  }
}

class _EscojerEmpresa extends StatelessWidget {
 
  final String url;
  final FormProductosCubit bloc;
  final List<Empresa> empresas;

  const _EscojerEmpresa({
         Key? key,
         required this.url,
         required this.bloc,
         required this.empresas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
           child : Container(
                   height : 50,
                   color  : Colors.grey.shade200,
                   child  : BlocBuilder<FormProductosCubit, FormProductosState>(
                            builder: (context, state) {
                             if(state.empresaSelecionada == -1)
                               return Center(child: Text('Toca Para Escoger una Empresa'));
                             return  ListTile(
                                     title   : Text(state.empresa!.nombre),
                                     leading : CircleAvatar(
                                               radius: 16,
                                               backgroundColor:Theme.of(context).primaryColor,
                                               child: Icon(Icons.check),
                                     ),
                             );
                     },
                   ),    
           ),
    onTap: () => showDialog(
                 context: context, 
                 builder: (context) => _Empresas(empresas: empresas, url: url, bloc: bloc)
    ),
  );
  }
}
  
class _EscojerCategoria extends StatelessWidget {

  final FormProductosCubit bloc;
  final List<CategoriaProducto> categorias;
  
  const _EscojerCategoria({Key? key,required this.bloc,required this.categorias}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
           child : Container(
                   height : 50,
                   color  : Colors.grey.shade200,
                   child  : BlocBuilder<FormProductosCubit, FormProductosState>(
                            builder: (context, state) {
                              if(state.categoriaSelecionada == -1)
                                return Center(child: Text('Toca Para Escoger una Categoria'));
                              return  ListTile(
                                      title   : Text(state.categoria!.nombre),
                                      leading : CircleAvatar(
                                                radius: 16,
                                                backgroundColor:Theme.of(context).primaryColor,
                                                child: Icon(Icons.check),
                                      ),
                              );
                            },
                   ),    
           ),
    onTap: () => showDialog(
                 context: context,
                 builder: (context) => _Categorias(categorias: categorias, bloc: bloc)
    ),
  );
  }
}

class _Oferta extends StatelessWidget {

  const _Oferta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             Text('¿ es una Oferta ?'),
             BlocSelector<FormProductosCubit, FormProductosState, bool>(
               selector: (state) => state.oferta,
               builder: (context, oferta) {
                 return Checkbox(
                        value: oferta, 
                        onChanged: (value) => context.read<FormProductosCubit>().selectOferta(value!)
                        );
               },
             )
           ],
       );
  }
}

class _Empresas extends StatelessWidget {

  final List<Empresa> empresas;
  final String url;
  final FormProductosCubit bloc;
  _Empresas({Key? key,required this.empresas,required this.url,required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
           contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 8),
           title   : Text('Escoja la Empresa'),
           content : BlocBuilder<FormProductosCubit,FormProductosState>(
                     bloc: bloc,
                     builder: (context,state){
                       return _listEmpresas(context,state.empresaSelecionada);
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
                      onTap    : () => bloc.selectEmpresa(empresas[index],index),
                      trailing : selecionada == index
                                 ? Icon(Icons.check_box,color: Colors.green)
                                 : null
               );    
             }
      ),
    );
  }
}

class _Categorias extends StatelessWidget {

  final List<CategoriaProducto> categorias;
  final FormProductosCubit bloc;
  _Categorias({Key? key,required this.categorias,required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
           contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 8),
           title   : Text('Escoja la Categoria'),
           content : BlocBuilder<FormProductosCubit,FormProductosState>(
                     bloc: bloc,
                     builder: (context,state){
                       return _listCategorias(context,state.categoriaSelecionada);
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

  Widget _listCategorias(BuildContext context,int selecionada) {
    return Container(
      width: 300,
      height: 300,
      child: ListView.builder(
             itemCount   : categorias.length,
             itemBuilder : (context,index){
               return ListTile(
                      leading  : Icon(Icons.label_important_outline),
                      title    : Text('${categorias[index].nombre}'), 
                      onTap    : () => bloc.selectCategoria(categorias[index],index),
                      trailing : selecionada == index
                                 ? Icon(Icons.check_box,color: Colors.green)
                                 : null
               );    
             }
      ),
    );
  }
}