

import 'package:appyocomproacacias_refactoring/src/componentes/login/cubit/login.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/state/login.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class DialogRecoveryPassword extends StatelessWidget {

  String correo = '';
  String codigo = '';
  String password = '';
  String confirmPassword = '';

  DialogRecoveryPassword({Key? key}) : super(key: key);

  
 
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context,state){
          if(state.recoveryPassword){
            NavigationService().back();
            snacKBar('Se ha restablecido la contraseña', context);
          }
          if(state.error == ErrorLoginResponse.UPDATE_PASSWORD_ERROR){
            NavigationService().back();
            snacKBar('Ocurrio un error', context);
          }
          
        },
        builder: (context, state) {
          return AlertDialog(
                 title          : _selectTitle(state),
                 titleTextStyle : TextStyle(
                                  color      : Colors.black,
                                  fontWeight : FontWeight.bold,
                                  fontSize   : 18
                                  ),
                 content        : _selectContentAction(state,context),
                 actions        : _selectActions(state,context),
          );
        },
      );
  }

  _selectContentAction(LoginState state,BuildContext context) {
    if(state.loadingRecovery)
       return  Container(
               width  : 50,
               height : 50,
               child  : Center(child: CircularProgressIndicator())
       );
    if(state.isCodeSend)
       return _contentRecoveryCode(context,state);
    if(state.isCodevalid)
       return _contentChangePassword(context,state);
    return _contentRecoveryEmail(context,state);
  }

  _contentRecoveryEmail(BuildContext context, LoginState state) {
    return SizedBox(
           height : 160,
           child  : Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Ingresa el correo electronico vinculado a la aplicación'),
                      SizedBox(height: 20),
                      InputForm(
                      placeholder : 'Correo',
                      autofocus   :  true,
                      onChanged   :  (value) => correo = value,
                      isEmail     :  true,
                      requerido   :  true,
                      errorText   :  state.error == ErrorLoginResponse.USER_NO_EXITS
                                     ? 'No existe el correo en la base de datos'
                                     : null
                      )
                    ],
           )
    );
  }
  _contentRecoveryCode(BuildContext context, LoginState state) {
    return SizedBox(
           height : 140,
           child  : Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Ingresa el codigo que llego al correo'),
                      SizedBox(height: 20),
                      InputForm(
                      placeholder : 'Codigo',
                      autofocus   :  true,
                      number      :  true,
                      errorText   :  state.error == ErrorLoginResponse.CODE_RECOVERY_INVALID 
                                     ? 'El codigo no es valido'
                                     : null,             
                      onChanged   :  (value) => codigo = value,
                      )
                    ],
           )
    );
  }
  _contentChangePassword(BuildContext context, LoginState state) {
    return SizedBox(
           height : 200,
           child  : Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Cambia tu contraseña'),
                      SizedBox(height: 20),
                      InputForm(
                      placeholder : 'Nueva Contraseña',
                      autofocus   :  true,
                      obscure     :  true,
                      requerido   :  true,
                      onChanged   :  (value) => correo = value,
                      ),
                      InputForm(
                      placeholder : 'Confirme Contraseña',
                      obscure     :  true,
                      requerido   :  true,
                      errorText   :  state.error == ErrorLoginResponse.UPDATE_PASSWORD_ERROR
                                     ? 'las Contraseñas no coinciden'
                                     : null,
                      onChanged   :  (value) => correo = value,
                      )
                    ],
           )
    );
  }

  _selectTitle(LoginState state) {
    if(state.loadingRecovery)
      return const Text('Enviando Codigo');
    if(state.isCodeSend)
      return const Text('Verifica Codigo');
    if(state.isCodevalid)
      return const Text('Cambia tu Contraseña');
    return const Text('Recupera tu contraseña');
  }

  _selectActions(LoginState state, BuildContext context) {
    if(state.loadingRecovery)
       return null;
    return [
      if(!state.isCodeSend && !state.isCodevalid)
       ElevatedButton(
       child     : const Text('Enviar Codigo'),
       onPressed : () => context.read<LoginCubit>().sendEmailRecoveryPassWord(correo),
       style     : ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
      ),
      if(state.isCodeSend)
         ElevatedButton(
         child     : const Text('Verificar Codigo'),
         onPressed : () => context.read<LoginCubit>().validateCodeRecovery(codigo),
         style     : ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
         ),
      if(state.isCodevalid)   
         ElevatedButton(
         child     : const Text('Cambiar Contraseña'),
         onPressed : () => context.read<LoginCubit>().changePassword(password,confirmPassword),
         style     : ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
         ),
      ElevatedButton(
      child     : const Text('Cancelar'),
      onPressed : () {
        NavigationService().back();
        context.read<LoginCubit>().resetState();
      },
      style     : ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
      )
    ];
  }
}