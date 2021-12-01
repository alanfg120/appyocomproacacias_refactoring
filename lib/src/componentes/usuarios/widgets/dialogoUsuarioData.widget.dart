import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/cubit/usuario_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DialogChangeData extends StatelessWidget {

   
   DialogChangeData(
        {Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

   String _email  = context.read<UsuarioCubit>().usuario.email!;
   String _nombre = context.read<UsuarioCubit>().usuario.nombre!;
 

   final  formKey = GlobalKey<FormState>();
   FocusNode  focusEmail = FocusNode();
   FocusNode  focusNombre = FocusNode();
 
    return AlertDialog(
           shape   : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
           title   : Text('Cambiar Datos'),
           content : Container(
                     width : 400,
                     height: 205,
                     child: Form(
                       key: formKey,
                       child: Column(
                              children: [
                                InputForm(
                                placeholder       : 'Correo',
                                initialValue      : _email,
                                foco              : focusNombre,
                                isEmail           : true,
                                autofocus         : true,
                                onEditingComplete : () => FocusScope.of(context).requestFocus(focusNombre),
                                requerido         : true,
                                onChanged         : (text) => _email = text,        
                                ),
                                InputForm(
                                placeholder       : 'Nombre',
                                initialValue      : _nombre,
                                requerido         : true,
                                foco              : focusEmail,
                                onEditingComplete : () => FocusScope.of(context).requestFocus(focusEmail),
                                onChanged         : (text) => _nombre = text,  
                                ),
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
                  if(formKey.currentState!.validate())
                      context.read<UsuarioCubit>().updateDataUsuario(
                        {
                          "nombre" : _nombre,
                          "usuario": _email
                        }
                      );
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