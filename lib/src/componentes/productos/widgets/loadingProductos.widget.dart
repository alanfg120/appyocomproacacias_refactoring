
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class LoadingProductos extends StatelessWidget {
  const LoadingProductos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated( 
             separatorBuilder: (_,i) => SizedBox(height: 10),
             itemCount: 20,
             itemBuilder: (BuildContext context, int index) {
             return LoadingCardProducto();
        },
      ),
    );
  }
}
class LoadingSearchProductos extends StatelessWidget {
  const LoadingSearchProductos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated( 
           separatorBuilder: (_,i) => SizedBox(height: 10),
           itemCount: 2,
           itemBuilder: (BuildContext context, int index) {
           return LoadingCardProducto();
      },
    );
  }
}


class LoadingCardProducto extends StatelessWidget {

  const LoadingCardProducto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
           height: 192,
           child : Card(
                   elevation: 1,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                   child: Padding(
                          padding : const EdgeInsets.symmetric(vertical: 23,horizontal: 10),
                          child   : Row(
                          children: [
                           ShimmerLoading(
                           child: Container(
                                  height     : 200,
                                  width      : MediaQuery.of(context).size.width * 0.3,
                                  decoration : BoxDecoration(
                                               color       : Colors.grey,
                                               borderRadius: BorderRadius.circular(20)
                                  ),
                           ),
                           ),
                           SizedBox(width: 10),
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               SizedBox(height: 10),
                               ShimmerLoading(
                                 child: Container(
                                 width: 180,
                                 height: 10,
                                 color: Colors.grey
                                 ),
                               ),
                               SizedBox(height: 10),
                               ShimmerLoading(
                                 child: Container(
                                 width: 180,
                                 height: 10,
                                 color: Colors.grey
                                 ),
                               ),
                                SizedBox(height: 10),
                               ShimmerLoading(
                                 child: Container(
                                 width: 180,
                                 height: 10,
                                 color: Colors.grey
                                 ),
                               )
                              
                             ],
                            )
                          ], 
               ),
             ),
           ),
    );
  }
}