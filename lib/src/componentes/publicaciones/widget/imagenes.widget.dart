
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagenesWidgetPage extends StatelessWidget {

  final List<String> imagenes;
  final int id;

  ImagenesWidgetPage(
    {Key? key,
    required this.imagenes,
    required this.id}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return Scaffold(
           appBar: AppBar(
                   iconTheme: IconThemeData(color:Colors.white),
                   backgroundColor: Colors.black,
           ),
           backgroundColor: Colors.black45,
           body: InteractiveViewer(
                 child: Hero(
                        tag   : id,
                        child : PageView.builder(
                               itemCount   : imagenes.length,
                               itemBuilder : (context,i){
                                    return CachedNetworkImage(
                                           imageUrl :'$url/galeria/${imagenes[i]}',
                                           fit      : BoxFit.contain,
                               );
                            },
                 ),
               ),
           ),
           
    );
  }
}