
import 'package:flutter/material.dart';

class DatosCard extends StatelessWidget {

  final  String titulo;
  final  String? vinculo;
  final  String tipo;
  final  Function(String)? onPressed;
  final  IconData icon;

  DatosCard({
  Key? key,
  required this.titulo,
  this.vinculo,
  this.onPressed,
  required this.tipo,
  required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Padding(
             padding: EdgeInsets.symmetric(horizontal: 10),
             child: Card(
                    child: ListTile(
                           leading  : Icon(icon),
                           title    : titulo.isEmpty
                                      ? 
                                      Text('No disponible')
                                      :
                                      Text(titulo),
                           subtitle : Text(tipo),
                           trailing : vinculo == null
                                      ?
                                      null
                                      :
                                      RawChip(
                                      label           : Text(vinculo!),
                                      backgroundColor : Theme.of(context).primaryColor,
                                      labelStyle      : TextStyle(color : Colors.white),
                                      onPressed       : titulo.isEmpty
                                                        ? 
                                                        null
                                                        :
                                                        () => onPressed!(titulo),
                                     ),
                           
                    ),
                    shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(15)
                    ),
                    elevation: 0,
             ),
             );
  }
}