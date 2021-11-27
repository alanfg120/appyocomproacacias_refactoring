
import 'package:flutter/material.dart';

void snacKBar(String texto,BuildContext context,[String action = 'Aceptar']){
   final snackBar = SnackBar(
                     content : Text(texto),
                     action  : SnackBarAction(
                               label     : action,
                               onPressed : (){},
                               textColor : Theme.of(context).primaryColor
                     ),
                     duration: Duration(seconds: 2),
                     behavior: SnackBarBehavior.fixed,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

