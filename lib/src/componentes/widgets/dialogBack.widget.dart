import 'package:flutter/material.dart';

class DialogBack extends StatelessWidget {
  const DialogBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
           title   :  const Text('Esta seguro de salir?'),
           content : const Text('Perdera todos los cambios'),
           actions : [
                     ElevatedButton(
                     child : const Text('Aceptar'),
                     style : ElevatedButton.styleFrom(
                             primary: Theme.of(context).primaryColor,
                             textStyle: TextStyle(color: Colors.white)
                     ),
                     onPressed:  () => Navigator.pop(context,true),
                     ),
                     ElevatedButton(
                     child : const Text('Cancelar'),
                     style : ElevatedButton.styleFrom(
                             primary: Theme.of(context).accentColor,
                             textStyle: TextStyle(color: Colors.white)
                     ),
                     onPressed: () => Navigator.pop(context,false),
                     )
           ],

    );
  }
}
  