import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';


class ProductoCardSmall extends StatelessWidget {
  
  final Producto producto;
  final String url;
  ProductoCardSmall({Key? key,required this.producto,required this.url}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      fit: StackFit.loose,
      children: [
        SizedBox(
        height: 150,
        width: 150,
        child: ClipRRect( 
                   borderRadius : BorderRadius.circular(20),
                   child        : CachedNetworkImage(
                                  imageUrl    : '$url/galeria/${producto.imagenes[0]}',
                                  fit         : BoxFit.cover,
                                  placeholder : (context, url) =>  Image.asset('assets/imagenes/load_image.gif'),
                                  errorWidget : (context, url, error) => Icon(Icons.error),
                   ),
          ),
        ),
        Align(
        alignment: Alignment(0,1.24),
        child: RawChip(
               backgroundColor: Theme.of(context).primaryColor,
               label: Text('\u0024 ${producto.precio}',style:TextStyle(color: Colors.white)),
               ), 
        )
      ],
      );
      
  }
}