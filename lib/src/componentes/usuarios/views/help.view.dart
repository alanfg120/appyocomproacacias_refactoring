
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/cubit/usuario_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/widgets/radioOption.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogLoading.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/url_laucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpPage extends StatelessWidget {
  
  HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
           child: BlocListener<UsuarioCubit, UsuarioState>(
             listener: (context, state) {
               if(state.loading){
                 dialogLoading(context,'Enviando');
               }
               if(!state.loading){
                 NavigationService().back();
                 snacKBar('Reporte enviado', context);
               }
                
             },
             child: Scaffold(
                             appBar: AppBar(
                                     title: Text('Ayuda'),
                                     elevation: 0,
                             ),
                             body: SingleChildScrollView(
                                   padding: EdgeInsets.all(30),
                                   child:  Column(
                                           children: [
                                              _titulo('¿Cómo podemos ayudarte?'),
                                              SizedBox(height: 20),
                                              _texto(),
                                              _Options(),
                                              SizedBox(height: 20),
                                              _titulo('Datos de contactos'),
                                              SizedBox(height: 10),
                                              _telefono(),
                                              _correo()
                                           ],
                                   )
                             ),
                            
                      ),
           ),
           
           onTap: ()=>FocusScope.of(context).unfocus()
           );
  
  }

Widget _texto() {
  return Text('Cuentanos si se te ha presentado algún incoveniente al utilizar aplicación');
}

  _titulo(String titulo) {
    return Text(titulo,
                 textAlign : TextAlign.center,
                 style     : TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize  : 17
                 ),
                 );
  }

  _telefono() {
    return ListTile(
    leading        : Icon(Icons.phone),
    title          : Text('3214904883'), 
    onTap          : ()=> gotoCall('3214904883') 
    );
  }
  _correo() {
    return ListTile(
    leading        : Icon(Icons.mail),
    title          : Text('empresariostic@acacias.gov.co'), 
    onTap          : ()=> gotoMail('empresariostic@acacias.gov.co'), 
    );
  }
}

class _Options extends StatefulWidget {

  _Options({Key? key}) : super(key: key);

  @override
  __OptionsState createState() => __OptionsState();
}

class __OptionsState extends State<_Options> {

   int valueRadio = -1;
   late String mensaje;
   final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
  
    return Form(
           key:  formKey,
           child: Column(
                  children: [
                   RadioOptionHelp(
                   titulo     : 'Funcionamiento',
                   value      : 0,
                   valueradio : valueRadio,
                   onChange   : (value) => setState(() => valueRadio = value!)
                   ),
                   RadioOptionHelp(
                   titulo     : 'Contenido inadecuado',
                   value      : 1,
                   valueradio : valueRadio,
                   onChange   : (value) => setState(() => valueRadio = value!)
                   ),
                   RadioOptionHelp(
                   titulo     : 'Suplantación o empresa repetidas',
                   value      : 2,
                   valueradio : valueRadio,
                   onChange   : (value) => setState(() => valueRadio = value!)
                   ),
                   RadioOptionHelp(
                   titulo     : 'otro (describelo en el mensaje)',
                   value      : 3,
                   valueradio : valueRadio,
                   onChange   : (value) => setState(() => valueRadio = value!)
                   ),
                   SizedBox(height: 20),
                   InputForm(
                   placeholder : 'Mensaje',
                   requerido   : true,
                   textarea    : true,
                   onChanged   : (text) => mensaje = text, 
                   ),
                   SizedBox(
                     width: double.infinity,
                     height: 50,
                     child: ElevatedButton(
                            child:  Text('Enviar'),
                            style: ElevatedButton.styleFrom(
                                   primary: Theme.of(context).primaryColor
                            ),
                            onPressed: (){
                              if(valueRadio != -1)
                                context.read<UsuarioCubit>().sendResponse(valueRadio, mensaje);
                            },
                     ),
                   )
                  ],
       ),
    );
  }
}