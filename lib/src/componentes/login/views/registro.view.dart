


import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/cubit/login.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/state/login.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogLoading.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// ignore: must_be_immutable
class RegistroFormPage extends StatelessWidget {
   
   RegistroFormPage({Key? key}) : super(key: key);
  
  final focoUsuario = FocusNode();
  final focoNombre = FocusNode();
  final focoCedula = FocusNode();
  final focoPassword = FocusNode();
  final focoConfirmPassword = FocusNode();
  final formKey = GlobalKey<FormState>();
  String usuario = '';
  String nombre  = '';
  String cedula = '';
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar( 
                   title   : Text('Crear Cuenta'),
                   elevation: 0,

           ),
           body : GestureDetector(
                  onTap : ()=>FocusScope.of(context).unfocus(),
                  child : SingleChildScrollView(
                          padding: EdgeInsets.all(40),
                          child : BlocListener<LoginCubit,LoginState>(
                                  listener: (context,state){
                                     if(state.loading == true)
                                       dialogLoading(context,'Iniciando');
                                     if(state.error == ErrorLoginResponse.USER_EXITS)
                                       snacKBar('Usuario ya existe', context);
                                     if(!state.loading)
                                        Navigator.of(context).pop();
                                     if(state.logiado){
                                       context.read<HomeCubit>().updateUsuario(state.usuario);
                                       NavigationService().back();
                                     }
                                  },
                                 listenWhen: (previo,actual) {
                                   if(previo.loading != actual.loading)
                                       return true;
                                   return false;
                                 },
                                  child:  Form(
                                           key  : formKey,
                                           child: Column(
                                                  children: <Widget>[
                                                     Image.asset(
                                                    'assets/imagenes/logo.png',
                                                     height : MediaQuery.of(context).size.width * 0.5,
                                                     width  : 270,
                                                     ),
                                                     InputForm(
                                                     placeholder       : "Usuario",
                                                     foco              : focoUsuario,
                                                     leftIcon          : Icons.person,
                                                     requerido         : true,
                                                     isEmail           : true,
                                                     onChanged         : (value) => usuario = value,
                                                     onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoNombre)
                                                     ),
                                                     InputForm(
                                                     placeholder       : "Nombre Completo",
                                                     foco              : focoNombre,
                                                     leftIcon          : Icons.person_add,
                                                     requerido         : true,
                                                     onChanged         : (value) => nombre = value,
                                                     onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoCedula)
                                                     ),
                                                     InputForm(
                                                     placeholder       : "Cedula",
                                                     leftIcon          : Icons.credit_card,
                                                     foco              : focoCedula,
                                                     requerido         : true,
                                                     onChanged         : (value) => cedula = value,
                                                     onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoPassword)
                                                     ),
                                                     InputForm(
                                                     placeholder       : "Contraseña",
                                                     foco              : focoPassword,
                                                     obscure           : true,
                                                     leftIcon          : Icons.lock_outline,
                                                     requerido         : true,
                                                     onChanged         : (value) => password = value,
                                                     onEditingComplete : ()=>FocusScope.of(context).requestFocus(focoConfirmPassword)
                                                     ),
                                                     InputForm(
                                                     placeholder       : "Confirmar contraseña",
                                                     foco              : focoConfirmPassword,
                                                     leftIcon          : Icons.lock,
                                                     obscure           : true,
                                                     lastInput         : true,
                                                     requerido         : true,
                                                     onChanged         : (value) => confirmPassword = value,
                                                     onEditingComplete : ()=> _submit(context),
                                                     ),
                                                     _buttonSubmit(context)

                                                  ],
                                      ) 
                                      )

                                  
                                  )     
                  ),
           ),
    );
  }
 Widget _buttonSubmit(BuildContext context) {
    return   MaterialButton(
             textColor : Colors.white,
             padding   : EdgeInsets.all(15),
             child     : Text('Crear Cuenta'),
             color     : Theme.of(context).primaryColor,
             minWidth  : double.maxFinite,
             onPressed :() => _submit(context)
    );
  }
   _submit(BuildContext context) {
     if(formKey.currentState!.validate() && password == confirmPassword){
       final Map<String,dynamic> registro = {
         'nombre'   : nombre,
         'usuario'  : usuario,
         'cedula'   : cedula,
         'password' : password
       };
       context.read<LoginCubit>().registreWithData(registro);
     }
     if(password != confirmPassword)
      snacKBar('No coinciden las contraseñas', context);
  }
}