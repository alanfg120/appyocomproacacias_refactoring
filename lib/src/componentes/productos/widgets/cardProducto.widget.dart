
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:flutter/material.dart';

class CardProducto extends StatelessWidget {
  final Producto producto;
  const CardProducto({Key? key,required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
           constraints: BoxConstraints(minHeight: 190),
           child : Card(
                   elevation: 1,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                   child: Padding(
                          padding : const EdgeInsets.symmetric(vertical: 20),
                          child   : Row(
                          children: [
                            SizedBox(
                            width  : 150,
                            height : 100,
                            child: FlutterLogo()
                            ),
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               SizedBox(
                               width: 220,
                               child: Text(
                                      producto.nombre,
                                      maxLines : 2,
                                      overflow : TextOverflow.ellipsis,
                                      softWrap : false,
                                      style    : TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                               ),
                               SizedBox(
                               width: 220,
                               child: Text(
                                      producto.descripcion,
                                      maxLines : 2,
                                      overflow : TextOverflow.ellipsis,
                                      softWrap : false,
                                      style    : TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 15.0),
                               ),
                               ),
                               Text(producto.precioFormat,style: TextStyle(fontSize: 28)),
                               if(producto.oferta)
                               RawChip(
                               backgroundColor: Colors.transparent,
                               label: Text('Oferta'),
                               avatar: Icon(Icons.star_outlined,color: Colors.yellow),
                               ),
                               if(!producto.oferta)
                               SizedBox(height: 35)
                             ],
                            )
                          ], 
               ),
             ),
           ),
    );
  }
}