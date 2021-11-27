import 'dart:io';


import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/socialAuth.enum.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/cubit/login.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/state/login.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/widgets/button_apple.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/widgets/button_google.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/widgets/dialog.recovery.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/dialogLoading.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// ignore: must_be_immutable
class LoginFormPage extends StatelessWidget {
  
  String usuario = '';
  String password = '';
  String correo = '';
  
  LoginFormPage({Key? key}) : super(key: key);

  final FocusNode focoUsuario  = FocusNode();
  final FocusNode focoPassword = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
              title: Text('Iniciar Sesión'),
              elevation: 0,
      ),
      body: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
                        if(state.loading)
                         dialogLoading(context,'Iniciando');
                        if(!state.loading)
                         Navigator.of(context).pop();
                        if(state.logiado){
                          context.read<HomeCubit>().updateUsuario(state.usuario);
                          NavigationService().back();
                        }
                        _snacKBarError(state.error,context);
            },
            listenWhen: (previo,actual) {
                         if(previo.loading != actual.loading)
                           return true;
                         return false;
            },
            child: GestureDetector(
                   onTap : () => FocusScope.of(context).unfocus(),
                   child : SingleChildScrollView( 
                           child   : Padding(
                                     padding : EdgeInsets.all(40.0),
                                     child   : Form(
                                               key: formKey,
                                               child   : Column(
                                                        children: <Widget>[
                                                                   Image.asset(
                                                                   'assets/imagenes/logo.png',
                                                                   height: MediaQuery.of(context).size.width *0.5,//Get.width * 0.5,
                                                                   width: 270,
                                                                   ),
                                                                   InputForm(
                                                                   placeholder : "Usuario",
                                                                   foco        : focoUsuario,
                                                                   leftIcon    : Icons.person,
                                                                   requerido   : true,
                                                                   isEmail     : true,
                                                                   onChanged: (value) => usuario = value,                                                                   
                                                                   onEditingComplete: ()=> FocusScope.of(context).requestFocus(focoPassword),
                                                                   ), 
                                                                   InputForm(
                                                                   placeholder: "Contraseña",
                                                                   foco: focoPassword,
                                                                   leftIcon: Icons.lock_outline,
                                                                   obscure: true,
                                                                   lastInput: true,
                                                                   requerido: true,
                                                                   onChanged: (value) => password = value,
                                                                   onEditingComplete: () => _submit(context),
                                                                   ),
                                                                   _olvidoPassword(context),
                                                                   _buttonSubmit(true,context),
                                                                   SizedBox(height: 20),
                                                                   Text('O ingresa con'),
                                                                   SizedBox(height: 5),
                                                                   Row(
                                                                     children: [
                                                                       Expanded(child: _googleSingInButton(context)),
                                                                       Expanded(child: _facebookSingInButton(context)),
                                                                     ],
                                                                   ),
                                                                   if (Platform.isIOS) _appleSingInButton(context),
                                                                 ],
                                              )
                                    ),
                          )
                   )
                  )
        
      )
      );
  }


  _buttonSubmit(bool loading, BuildContext context) {
    return MaterialButton(
           textColor : Colors.white,
           padding   : EdgeInsets.all(15),
           child     : Text('Ingresar'),
           color     : Theme.of(context).primaryColor,
           minWidth  : double.maxFinite,
           onPressed : () => _submit(context)
    );
  }

  _submit(BuildContext context) {
    if(formKey.currentState!.validate()){
       context.read<LoginCubit>().loginWithPassword(usuario, password);
    }
    else snacKBar('Error en el formulario',context);
  }

  _olvidoPassword(BuildContext context) {
    return GestureDetector(
           child: Container(
                  height    : 30,
                  alignment : Alignment.topRight,
                  child     : Text('Olvido su contraseña ?',style: TextStyle(color: Colors.blue))),
                  onTap     : () => _dialogRecoveryPassword(context)
    );
  }

  Widget _googleSingInButton(BuildContext context) {
    return ButtonSocialSing(
      logo: 'assets/imagenes/google_icon.jpg',
      texto: 'Google',
      fontSize: 11.5,
      onPress: () => context.read<LoginCubit>().loginWithSocialAuth(SocialAuthType.GOOGLE)
    );
  }

  Widget _facebookSingInButton(BuildContext context) {
    return ButtonSocialSing(
      logo: 'assets/imagenes/facebook_icon.png',
      texto: 'Facebook',
      fontSize: 10.1,
      onPress: () => context.read<LoginCubit>().loginWithSocialAuth(SocialAuthType.FACEBOOK),
    );
  }

  Widget _appleSingInButton(BuildContext context) {
    return ButtonAppleSing(
           texto: 'Iniciar sesión con Apple', 
           onTap: ()=> context.read<LoginCubit>().loginWithSocialAuth(SocialAuthType.APPLE)
           );
  }


  void _snacKBarError(ErrorLoginResponse error,BuildContext context) {
    if(error == ErrorLoginResponse.USER_NO_EXITS){
     snacKBar('Usuario no existe',context);
    }
    if(error == ErrorLoginResponse.DATA_INCORRECT){
     snacKBar('Contraseña incorrecta',context);
    }
    if(error == ErrorLoginResponse.ERROR_DATA_BASE){
     snacKBar('Ocurrio un error en el Servidor',context);
    }
    if(error == ErrorLoginResponse.ERROR_SOCIAL_AUTH){
     snacKBar('Ocurrio un error',context);
    }
  }
  
  _dialogRecoveryPassword(BuildContext context){
    showDialog(
    context: context, 
    builder: (context) {
      return DialogRecoveryPassword();
    }
    );
  }

 

  
}
