import 'package:appyocomproacacias_refactoring/src/componentes/categorias/bloc/categorias_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/bloc/empresas_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/cubit/formempresa_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/models/imageFile.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogImage.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogLoading.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/image_piker.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';


// ignore: must_be_immutable
class FormEmpresaPage extends StatelessWidget {
   
  final bool update;
  final Empresa? empresa;
  FormEmpresaPage({Key? key, this.update = false,this.empresa}) : super(key: key);

 // Datos Basicos
  late String nombre;
  late String nit;
  late String descripcion;
  late String direccion;
 // Datos de contacto
  late String telefono;
  late String whatsap;
  late String correo;
  String web = '';

  //Geolocalizacion
   late String latidud;
   late String longitud;
 
  // Focos Datos Basicos
   FocusNode focoNombre      = FocusNode();
   FocusNode focoNit         = FocusNode();
   FocusNode focoDescripcion = FocusNode();
   FocusNode focoDireccion   = FocusNode();
 
  // Focos Datos contacto
   FocusNode focoTelefono  = FocusNode();
   FocusNode focoWhatsap   = FocusNode();
   FocusNode focoCorreo    = FocusNode();
   FocusNode focoDWeb      = FocusNode();

   FocusNode focoLongitud   = FocusNode();
   
  final _bloc =  FormEmpresaCubit(repositorio: EmpresaRepositorio(),prefs: PreferenciasUsuario());
  final formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) { 

  return BlocProvider<FormEmpresaCubit>(
         create : (context) => _bloc,
         child  :  GestureDetector(
                        child: BlocListener<FormEmpresaCubit,FormEmpresaState>(
                          bloc: _bloc,
                          listener: (context, state) {
                            if(state.loading){
                              dialogLoading(context, 'Creando empresa');
                            }
                            if(!state.loading){
                              NavigationService().back();
                              NavigationService().back();
                            }
                          },
                          listenWhen: (previusState,state) => previusState.loading != state.loading,
                          child: BlocSelector<FormEmpresaCubit, FormEmpresaState,int>(
                                 bloc: _bloc,
                                 selector: (state) => state.index,
                                 builder: (context, index) {
                                     return Scaffold(
                                             appBar: AppBar(
                                                     title: Text(_getTitulo(index)!),
                                                     elevation: 0,
                                             ),
                                             body  :   Form(
                                                       key: formKey,
                                                       autovalidateMode: AutovalidateMode.onUserInteraction,
                                                       child: IndexedStack(
                                                              index   :index,
                                                              children: [
                                                               _selectLogo(context),
                                                               _datosBasicos (context),
                                                               _datosContacto(context),
                                                               _datosCategoria(context),
                                                               _datosLocalizacion(context),
                                                               ],
                                                       )
                                             ),
                                              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                                              floatingActionButton: _buttonAction(index,context)
                                                        
                                     );
                                 },
                           ),
                        ),
                      onTap: ()=>FocusScope.of(context).unfocus()
         )
      );
  
  }

 Widget _datosBasicos(BuildContext context) {
   return SingleChildScrollView (
          padding:EdgeInsets.all(40),                                        
          child: Column(
                 children: [
                   InputForm(
                   placeholder       : "Nombre de la Empresa",
                   foco              : focoNombre,
                   leftIcon          : Icons.business,
                   requerido         : true, 
                   onChanged         : (text) => nombre = text,
                   onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoNit)
                   ),
                   InputForm(
                   placeholder       : "Nit",
                   foco              :  focoNit,
                   leftIcon          : Icons.card_membership,
                   requerido         : true,
                   onChanged         : (text) => nit = text,
                   onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoDescripcion)
                   ),
                   InputForm(
                   placeholder       : "Descripcion",
                   foco              : focoDescripcion,
                   leftIcon          : Icons.text_fields,
                   requerido         : true,
                   textarea          : true,
                   onChanged         : (text) =>  descripcion = text,
                   onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoDireccion)
                   ),
                   InputForm(
                   placeholder       : "Dirreción",
                   foco              : focoDireccion,
                   leftIcon          : Icons.map,
                   requerido         : true,
                   onChanged         : (text) =>  direccion = text,
                   onEditingComplete : ()=>_bloc.changePagina(2)
                   ),
                 ]
          )
   );

 }

 Widget _datosContacto(BuildContext context) {
    return SingleChildScrollView (
          padding:EdgeInsets.all(40),                                        
          child: Column(
                 children: [
                    InputForm(
                    placeholder       : "Telefono",
                    foco              : focoTelefono,
                    leftIcon          : Icons.phone,
                    requerido         : true,
                    onChanged         : (text)=> telefono = text,
                    onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoWhatsap)
                    ),
                    InputForm(
                    placeholder       : "Whatsap",
                    foco              : focoWhatsap,
                    leftIcon          : Icons.phone_android,
                    requerido         : true,
                    onChanged         : (text)=> whatsap = text,
                    onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoCorreo)
                    ),
                    InputForm(
                    placeholder       : "Correo",
                    foco              : focoCorreo,
                    leftIcon          : Icons.email,
                    requerido         : true,
                    isEmail           : true,
                    onChanged         : (text)=> correo = text,
                    onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoDWeb)
                    ),
                    InputForm(
                    placeholder       : "Sitio Web",
                    foco              : focoDWeb,
                    leftIcon          : Icons.web,
                    onChanged         : (text)=> web = text,
                    onEditingComplete : ()=>_bloc.changePagina(3)
                    )
                 ]
          )
   );
  }

 Widget _datosLocalizacion(context) {
     
     return SingleChildScrollView (
          padding:EdgeInsets.all(30),                                        
          child: BlocBuilder<FormEmpresaCubit, FormEmpresaState>(
                 builder: (context, state) {
                   return Column(
                          children: [
                             InputForm(
                             placeholder  : "Latitud",
                             controller   : TextEditingController(text: '${state.latitud == null ? '':state.latitud }'),
                             readOnly     : true,
                             leftIcon     : Icons.gps_fixed,
                             ),
                             InputForm(
                             placeholder : "Longitud",
                             readOnly    : true,
                             controller  : TextEditingController(text: '${state.longitud == null ? '':state.longitud }'),
                             leftIcon    : Icons.gps_fixed,
                             ),
                             OutlinedButton(
                             child: Text('Obtener Localización'),
                             onPressed: () async {
                               final position = await _getLocation(context);
                               if(position != null){
                                 _bloc.getLocation(position);
                               }
                             }
                             )
                          ]
                   );
            },
          )
   );
  }

 Widget  _buttonAction(int index,BuildContext context) {
    if(index == 3)
     FocusScope.of(context).unfocus();
    return Padding(
           padding:EdgeInsets.symmetric( horizontal: 20),
           child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  index == 0
                  ?
                  Container()
                  :
                  FloatingActionButton.extended(
                  heroTag         : 'anterior',
                  label           : Text('Anterior',style: TextStyle(color: Colors.white)),
                  backgroundColor : Theme.of(context).primaryColor,                            
                  onPressed       : ()=>_bloc.changePagina(index -1)
                  ),
                  SizedBox(height:20),
                  FloatingActionButton.extended(
                  heroTag         : 'siguiente',
                  label           : Text('${index == 4 ? 'Crear' : 'Siguiente'}',style: TextStyle(color: Colors.white)),
                  backgroundColor : Theme.of(context).primaryColor,                           
                  onPressed       :  () async {
                    _bloc.changePagina(index + 1);
                    if(index == 4 && formKey.currentState!.validate()){
                      final empresa  = _getNewEmpresa();
                      final newEmpresa = await _bloc.addEmpresa(empresa);
                      if(newEmpresa != null)
                        context.read<EmpresasBloc>().add(AddEmpresaEvent(empresa: newEmpresa));
                    }
                   
                  }
                  )
                 
                  ]
           ),
    );
  }

 Widget _selectLogo(BuildContext context) {
    return Container(
           height:MediaQuery.of(context).size.height * 0.7,
           width: MediaQuery.of(context).size.width,
           child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      _circleImage(),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                      icon      : Icon(Icons.photo_camera,color: Colors.white),
                      label     : Text('${update ? 'Actualizar' : 'Seleccionar'} Logo'),
                      style     : ElevatedButton.styleFrom(
                                  primary   : Theme.of(context).primaryColor,
                                  textStyle : TextStyle(color: Colors.white),
                                  shape     : RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => showDialog(
                         context: context,
                         builder: (context)  => DialogImagePiker(
                                                titulo: 'Escoja el logo',
                                                onTapArchivo: () =>_getLogo(ImageSource.gallery),
                                                onTapCamera : () =>_getLogo(ImageSource.camera),
                                                complete: (){},
                         )
                         ),
                      ),
             ]        
      ),
    );

 }
 
 Widget _datosCategoria(BuildContext context) {

  final categorias = context.read<CategoriasBloc>().state.categorias;

  return ListView.builder(
         padding: EdgeInsets.only(bottom: 100),
         itemCount: categorias.length,
         itemBuilder: (_,i){
            return ListTile(
                   leading:  BlocBuilder<FormEmpresaCubit, FormEmpresaState>(
                             //bloc: _bloc,
                             builder: (context, state) {
                               return CircleAvatar(
                                      backgroundColor: state.categoria.id == categorias[i].id
                                                       ?
                                                       Colors.red
                                                       :
                                                       Colors.grey[400],
                                      child          : Text('$i',style: TextStyle(color:Colors.white)),
                               );
                     },
                   ),
                   title: Text(categorias[i].nombre),
                   onTap: () {
                     _bloc.selectCategoria(categorias[i]);
                     snacKBar('Escojiste ${categorias[i].nombre}', context);
                   }
            );
         }
         );
}

 Widget  _circleImage() {
  return  BlocSelector<FormEmpresaCubit,FormEmpresaState,ImageFile?>(
          //bloc: _bloc,
          selector : (state) => state.logo,
          builder  : (context,imagen){
            final url = context.read<HomeCubit>().urlImagenes;
            if(update)
             return ClipRRect(
                     borderRadius: BorderRadius.circular(300),
                     child:  FadeInImage(
                             height : 200,
                             width  : 200,
                             fit    : BoxFit.cover,
                             placeholder: AssetImage('assets/imagenes/load_image.gif'), 
                             image: NetworkImage('$url/logo/${empresa!.urlLogo}')
                     ),
             );
           if(imagen ==  null)
             return     CircleAvatar(
                        backgroundColor : Colors.grey[300],
                        radius          : 100,
                        child           : Icon(
                                          Icons.photo_camera,
                                          color : Colors.grey[400],
                                          size  : 100
                        )
             );
           if(imagen.isaFile)
             return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child:  FadeInImage(
                            height : 200,
                            width  : 200,
                            fit    : BoxFit.cover,
                            placeholder: AssetImage('assets/imagenes/load_image.gif'), 
                            image: FileImage(imagen.file!)
                    ),
             );
           return Container();
       },
  );
}

 _getLogo(ImageSource source) async {
   final newLogo = await ImageCapture.getImagen(source);
   if(newLogo != null){
     await _bloc.selectLogo(newLogo);
     NavigationService().back();
   }
  
 }
 
 Future<Position?> _getLocation(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return position;
    } catch (error) {
      snacKBar('Habilita Permisos',context,'Habilitar',() async {
        await Geolocator.openAppSettings();
      });
      return null;
     
    }
  }

 String? _getTitulo(int page) {
    switch (page) {
      case 0: return 'Escoge tu Logo';
      case 1: return 'Datos Básicos';
      case 2: return 'Datos de Contacto';
      case 3: return 'Categoria';
      case 4: return 'Ubicación';
  
    }
 }

 Empresa _getNewEmpresa(){
   return Empresa(
          nombre      : nombre,
          nit         : nit,
          descripcion : descripcion,
          direccion   : direccion,
          telefono    : telefono,
          whatsapp    : whatsap,
          email       : correo,
          web         : web,
          estado      : false, 
          urlLogo     : '',
          idCategoria : _bloc.state.categoria.id,
          idUsuario   : 0
   );
 }

}


