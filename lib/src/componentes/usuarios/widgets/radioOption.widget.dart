import 'package:flutter/material.dart';



class RadioOptionHelp extends StatelessWidget {

  final int valueradio;
  final int value;
  final Function(int? value) onChange;
  final String titulo;

  RadioOptionHelp(
    {Key? key,
     required this.valueradio,
     required this.value,
     required this.onChange,
     required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
           children: [
             Radio(
             value      : value, 
             groupValue : valueradio, 
             onChanged  : onChange,
             activeColor: Theme.of(context).primaryColor
             ),
             Text(titulo)
           ],
    );
  }
}