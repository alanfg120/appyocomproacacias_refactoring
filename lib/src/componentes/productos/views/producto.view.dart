import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/models/producto.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/cardEmpresa.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductoDetallePage extends StatelessWidget {
  final Producto producto;
  const ProductoDetallePage({Key? key,required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
             statusBarIconBrightness : Brightness.light,
             statusBarBrightness     : Brightness.dark,
      ),
      child: Scaffold(
             backgroundColor: Colors.white,
             body: Padding(
                   padding : const EdgeInsets.only(bottom: 90),
                   child   : SingleChildScrollView(
                             child : Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                              _Imagenes(imagenes: producto.imagenes,empresa: producto.empresa),
                               Container(
                               margin  : const EdgeInsets.only(top: 50),
                               padding : const EdgeInsets.all(18),
                               child   : Text('${producto.nombre}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                               ),
                               Padding(
                               padding : const EdgeInsets.symmetric(horizontal: 18),
                               child   : Text('${producto.descripcion}',
                                         style: TextStyle(
                                                fontSize   : 18,
                                                fontWeight : FontWeight.w300
                                         )
                               ),
                               ),
                                Padding(
                               padding : const EdgeInsets.symmetric(horizontal: 18),
                               child   : Row(
                                         mainAxisSize: MainAxisSize.max,
                                         children: [
                                           Text('Cantidad',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                                           Spacer(),
                                           IconButton(
                                           icon      : Icon(Icons.arrow_left_sharp),
                                           iconSize  : 60,
                                           color     : Theme.of(context).primaryColor,
                                           onPressed : (){},
                                           ),
                                           Text('1',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w300)),
                                           IconButton(
                                           icon      : Icon(Icons.arrow_right_sharp),
                                           iconSize  : 60,
                                           color     : Theme.of(context).accentColor,
                                           onPressed : (){},
                                           ),
                                         ],  
                               ),
                               ),
                               if(producto.oferta)
                               Padding(
                               padding : const EdgeInsets.symmetric(horizontal: 18),
                               child   : Container(
                                         padding    : const EdgeInsets.all(10),
                                         height     : 40,
                                         width      : 120,
                                         decoration : BoxDecoration(
                                                      color        : Colors.grey.shade100,
                                                      borderRadius : BorderRadius.circular(40)
                                         ),  
                                         child      :  Row(
                                                       crossAxisAlignment: CrossAxisAlignment.end,
                                                       children: [
                                                         Icon(Icons.star_outlined,color: Colors.yellow,size: 25),
                                                         Text('Oferta',style: TextStyle(fontSize: 20),textAlign: TextAlign.end)
                                                       ],        
                                         ),
                               )
                               ),
                               if(producto.oferta)
                               SizedBox(height: 15),
                               if(producto.oferta)
                               Padding(
                               padding : const EdgeInsets.symmetric(horizontal: 18),
                               child   : Text('${producto.descripcionOferta}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300)),
                               ),
                              
                            ],
                     ),
               ),
             ),
             bottomSheet: Container(
                          height     : 80,
                          width      : double.infinity,
                          decoration : BoxDecoration(
                                       color: Theme.of(context).primaryColor,
                                       borderRadius: BorderRadius.only(
                                                     topLeft  : Radius.circular(30),
                                                     topRight : Radius.circular(30),
                                       )
                          ),
                          child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   Text('${producto.precioFormat}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
                                   SizedBox(
                                   height : 50,
                                   width  : 150,
                                   child  : OutlinedButton.icon(
                                            label  : Text('Pedir'),
                                            icon   : Icon(Icons.add),
                                            style  : OutlinedButton.styleFrom(
                                                     backgroundColor : Colors.white,
                                                     primary         : Theme.of(context).primaryColor,
                                                     shape           : RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                     textStyle       : TextStyle(fontSize: 25)
                                            ),
                                            onPressed: (){},
                                   ),
                                   )
                                 ],
                          ),
             ),
      ),
    );
  }
}

class _Imagenes extends StatelessWidget {

  final List<String> imagenes;
  final Empresa empresa;
  const _Imagenes({Key? key,required this.imagenes,required this.empresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return  Container(
            height : MediaQuery.of(context).size.height * 0.5,
            child  : Stack(
                     children: [
                       Positioned.fill(
                       child: Swiper(
                              itemCount   : imagenes.length,
                              itemBuilder : (BuildContext context,int index){
                                     return CachedNetworkImage(
                                             imageUrl    : '$url/galeria/${imagenes[index]}',
                                             placeholder : (context, url) =>  Image.asset('assets/imagenes/load_image.gif'),
                                             errorWidget : (context, url, error) => Icon(Icons.error),
                                             fit         : BoxFit.fill,
                                    );
                              },
                              control: SwiperControl(
                                       color        : Colors.white,
                                       iconNext     : Icons.arrow_right_sharp,
                                       iconPrevious : Icons.arrow_left_sharp,
                                       size         : 50,
                              ),
                       ),
                       ),
                       Align(
                       alignment : Alignment(0,1.3),
                       child     : CardEmpresa(empresa: empresa, url: url)
                       ),
                       Positioned(
                       top   : 40,
                       left  : 10,
                       child : Container(
                               decoration: BoxDecoration(
                                           color        : Colors.white,
                                           borderRadius : BorderRadius.circular(100)               
                               ),
                               child: IconButton(
                                      icon      : BackButtonIcon(), 
                                      color     : Colors.black,
                                      onPressed : () =>NavigationService().back()
                               ),
                       ),
                       ),
              ],
      ),
    );
  }
}