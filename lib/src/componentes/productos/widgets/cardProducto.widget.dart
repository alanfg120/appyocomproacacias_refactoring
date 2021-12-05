
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/views/producto.view.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardProducto extends StatelessWidget {
  final String url;
  final Producto producto;
  
  const CardProducto({Key? key,required this.producto,required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
            child: Container(
                   constraints: BoxConstraints(minHeight: 190),
                   child : Card(
                           elevation: 1,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                           child: Padding(
                                  padding : const EdgeInsets.symmetric(vertical: 20),
                                  child   : Row(
                                  children: [
                                    ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child  : producto.imagenes.length == 0
                                             ? Image.asset(
                                               'assets/imagenes/no_product.png',
                                               width : 150,
                                               height : 150,
                                             )
                                             : CachedNetworkImage(
                                             width  : 150,
                                             height : 150,
                                             imageUrl    : '$url/galeria/${producto.imagenes[0]}',
                                             placeholder : (context, url) =>  Image.asset('assets/imagenes/load_image.gif'),
                                             errorWidget : (context, url, error) => Icon(Icons.error),
                                             fit         : BoxFit.cover,
                                    )
                                    ),
                                    SizedBox(width: 10),
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
      ),
      onTap: () => NavigationService().navigateToRoute(
         MaterialPageRoute(builder: (context) => ProductoDetallePage(producto: producto))
      ),
    );
  }
}