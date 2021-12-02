
import 'package:flutter/material.dart';

void snacKBar(String texto,BuildContext context,{String action = 'Aceptar',Function()? onPressed,Function()? onclose}){
   final snackBar = SnackBar(
                     content : Text(texto),
                     action  : SnackBarAction(
                               label     : action,
                               onPressed : onPressed != null
                                           ? onPressed
                                           :(){},
                               textColor : Theme.of(context).primaryColor
                     ),
                     duration: Duration(seconds: 2),
                     behavior: SnackBarBehavior.fixed,
    );
     ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value) => onPressed!.call());
  
}

