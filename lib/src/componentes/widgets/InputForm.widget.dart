import 'package:appyocomproacacias_refactoring/src/recursos/pattern.dart';
import 'package:flutter/material.dart';


class InputForm extends StatelessWidget {

  final TextEditingController? controller;
  final String? placeholder,textHelp,initialValue,errorText;
  final IconData? leftIcon,rightIcon;
  final FocusNode? foco;
  final bool lastInput,requerido,obscure,isEmail,readOnly,isButtonIcon,textarea,autofocus,textcenter,enabled,number;
  final VoidCallback? onEditingComplete,onButtonIcon;
  final Function(String)? onChanged;
  final String? Function(String? value)? validator;


  InputForm({
  Key? key, 
  this.placeholder,
  this.initialValue,
  this.textHelp,
  this.errorText,
  this.leftIcon, 
  this.rightIcon, 
  this.foco, 
  this.controller,
  this.lastInput = false,
  this.obscure   = false,
  this.requerido = false,
  this.isEmail   = false,
  this.readOnly  = false,
  this.isButtonIcon  = false,
  this.textarea = false,
  this.autofocus   = false,
  this.textcenter = false,
  this.enabled = true,
  this.number = false,
  this.onEditingComplete,
  this.onButtonIcon,
  this.onChanged,
  this.validator
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
   
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
             key               : ValueKey(placeholder),
             autovalidateMode  : AutovalidateMode.onUserInteraction,
             enabled           : enabled,
             initialValue      : initialValue,
             textAlign         : textcenter ? TextAlign.center : TextAlign.start,
             readOnly          : readOnly,
             focusNode         : foco,
             autofocus         : autofocus,
             textInputAction   : lastInput
                                 ?
                                 TextInputAction.done
                                 :
                                 TextInputAction.next,
             maxLines          : textarea ? null : 1,
             keyboardType      : _keyboardType(),
             obscureText       : obscure,
             controller        : controller,
             onEditingComplete : onEditingComplete,
             decoration        : InputDecoration(
                                 suffixIcon       : rightIcon == null
                                                  ?
                                                  null
                                                  :
                                                  isButtonIcon
                                                  ?
                                                  IconButton(
                                                  icon: Icon(rightIcon,color: primaryColor), 
                                                  onPressed: onButtonIcon
                                                  )
                                                  :
                                                  Icon(rightIcon,color: primaryColor),
                                 prefixIcon      :leftIcon == null
                                                  ?
                                                  null
                                                  :
                                                  isButtonIcon
                                                  ?
                                                  IconButton(
                                                  icon: Icon(leftIcon,color: primaryColor), 
                                                  onPressed: onButtonIcon
                                                  )
                                                  :
                                                  Icon(leftIcon,color: primaryColor),
                         
                                 hintText       : placeholder,
                                 helperText     : textHelp,
                                 errorText      : errorText,
                                 helperMaxLines : 3,
                                 border         : OutlineInputBorder(),
                                 focusedBorder  : OutlineInputBorder(
                                                  borderSide: BorderSide(color: primaryColor)
                                 )
             ),
             validator         : validator == null
                                 ? _validator
                                 : validator,
             onChanged: onChanged,
      ),
    );
  }

 

 TextInputType? _keyboardType() {
    if(textarea)
     return TextInputType.multiline;
    if(number)
     return TextInputType.number;
    return null;
  }

  String? _validator(String? texto) {
     if(texto!.isEmpty && requerido) 
       return "es requerido"; 
     if(isEmail && !isAEmail(texto))
       return 'no es un email valido';          
     if(isEmail && !isAEmail(texto))
       return 'no es un email valido';                 
     return null;
  }
}
