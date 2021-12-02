import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class LoadingCategoriasProductos extends StatelessWidget {
  
  const LoadingCategoriasProductos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
             child: ListView.builder(
               itemCount: 10,
               itemBuilder: (_,int index) {
                 return ListTile(
                        contentPadding : EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                        title: ShimmerLoading(
                               child: Container(
                                      height: 17,
                                      color: Colors.grey,            
                               ),
                        ),
                 );
               },
        ),
      ),
    );
  }
}