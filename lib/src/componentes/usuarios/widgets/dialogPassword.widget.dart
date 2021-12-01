import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/cubit/usuario_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DialogChangePassword extends StatelessWidget {


   DialogChangePassword(
        {Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

   String _currentPassword = '';
   String _newPassword = '';
   String _conFirmpassword = '';

   final  formKey = GlobalKey<FormState>();
   FocusNode  focusCurrentPassword = FocusNode();
   FocusNode  focusNewPassword = FocusNode();
   FocusNode  focusConfirmPassword = FocusNode();

    return AlertDialog(
           shape   : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
           title   : Text('Cambiar Contraseña'),
           content : Container(
                     width : 400,
                     height: 304,
                     child: Form(
                       key: formKey,
                       child: Column(
                              children: [
                                BlocBuilder<UsuarioCubit, UsuarioState>(
                                  builder: (context, state) {
                                    return InputForm(
                                           placeholder       : 'Contraseña actual',
                                           obscure           : true,
                                           autofocus         : true,
                                           foco              : focusCurrentPassword,
                                           onEditingComplete : () => FocusScope.of(context).requestFocus(focusNewPassword),
                                           requerido         : true,
                                           errorText         : state.error == ErrorResponseUsuario.PASS_INVALID
                                                               ? 'Contraseña invalida'
                                                               : null,
                                           onChanged         : (text) => _currentPassword = text,  
                                           );
                                  },
                                ),
                                InputForm(
                                placeholder       : 'Contraseña nueva',
                                obscure           : true,
                                requerido         : true,
                                foco              : focusNewPassword,
                                onEditingComplete : () => FocusScope.of(context).requestFocus(focusConfirmPassword),
                                onChanged         : (text) => _newPassword = text,  
                                ),
                                InputForm(
                                placeholder : 'Confirme contraseña',
                                obscure     : true,
                                requerido   : true,
                                foco        : focusConfirmPassword,
                                onChanged   : (text) => _conFirmpassword = text,
                                validator   :  (text){
                                      if(text!.isEmpty)
                                        return "es requerido";
                                      if(_newPassword != text)
                                        return "No Coincide las contraseñas";
                                },  
                                )
                              ],
                       )
             ),
           ),
           actions : [
                 ElevatedButton(
                 child     : const Text('Aceptar'),
                 style     : ElevatedButton.styleFrom(
                             primary   : Theme.of(context).primaryColor,
                             textStyle : TextStyle(color: Colors.white)
                 ),
                 onPressed: (){
                  if(formKey.currentState!.validate() && _newPassword == _conFirmpassword)
                    context.read<UsuarioCubit>()
                           .updatePassword(_currentPassword, _newPassword);      
                 },
                 ),
                 ElevatedButton(
                 child     : const Text('Cancelar'),
                 onPressed : () => NavigationService().back(),
                 style     : ElevatedButton.styleFrom(
                             primary   : Theme.of(context).accentColor,
                             textStyle : TextStyle(color: Colors.white)
                 ),
                 )
           ],
    );
  }
}