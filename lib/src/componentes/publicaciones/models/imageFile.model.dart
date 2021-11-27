import 'dart:io';

import 'package:equatable/equatable.dart';

class ImageFile extends Equatable{

  final File? file;
  final String nombre;
  final bool isaFile;

  ImageFile({this.file,required this.nombre,this.isaFile = false});
 
  ImageFile copyWith({
   File? file,
   String? nombre,
   bool? isaFile
  }) => ImageFile(
        file   : file   ?? this.file,
        nombre : nombre ?? this.nombre,
        isaFile: isaFile  ?? this.isaFile
  );

  @override
  List<Object?> get props => [file,nombre,isaFile];
}