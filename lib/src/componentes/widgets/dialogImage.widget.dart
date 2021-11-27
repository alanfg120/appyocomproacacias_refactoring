import 'package:flutter/material.dart';


class DialogImagePiker extends StatelessWidget {
     final String titulo;
     final VoidCallback onTapArchivo;
     final VoidCallback onTapCamera;
     final VoidCallback complete;
  const DialogImagePiker(
        {Key? key,
        required this.titulo,
        required this.onTapArchivo,
        required this.onTapCamera,
        required this.complete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
           title   : Text(titulo),
           shape   : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           content : Container(
                     height : 120,
                     width  : 300,
                     child  : ListView(children: [
                              ListTile(
                                  leading : Icon(Icons.folder,size: 35),
                                  title   : Text('Selecciona desde galeria'),
                                  onTap   : onTapArchivo),
                              ListTile(
                                  leading : Icon(Icons.photo_camera,size: 35),
                                  title   : Text('Toma la foto'),
                                  onTap   :  onTapCamera)
                     ]), 
           ),
    );
  }
}
