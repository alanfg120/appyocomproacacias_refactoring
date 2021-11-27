import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class LoadingVideoYoutubeWidget extends StatelessWidget {
  const LoadingVideoYoutubeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
           children: [
            ShimmerLoading(
              child: Container(
                     height     : 200,
                     width      : MediaQuery.of(context).size.width * 0.4,
                     decoration : BoxDecoration(
                                  color       : Colors.grey,
                                  borderRadius: BorderRadius.circular(20)
                     ),
              ),
            ),
            SizedBox(width: 30),
            ShimmerLoading(
              child: Container(
                     height     : 200,
                     width      : MediaQuery.of(context).size.width * 0.4,
                     decoration : BoxDecoration(
                                  color       : Colors.grey,
                                  borderRadius: BorderRadius.circular(20)
                     ),
              ),
            ),
           ],
    );
  }
}

class TopLoadindWidget extends StatelessWidget {
  const TopLoadindWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Expanded(
           child : ListView.builder(
                      itemCount   : 10,
                      itemBuilder : (_, int index) {
                      return _cardEmpresa();
                     },
           )
                  
    );
  }
   
  _cardEmpresa() {
   return Card(
          child: Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                 child: ListTile(
                        title    : ShimmerLoading(
                                   child: Container(
                                          height: 12,
                                          width: double.infinity,
                                          color: Colors.grey
                                   ),
                        ),
                        subtitle    : ShimmerLoading(
                                   child: Container(
                                          height: 8,
                                          width: double.infinity,
                                          color: Colors.grey
                                   ),
                        ),
                        leading  : ShimmerLoading(
                                    child: CircleAvatar(
                                               radius: 30,
                                               backgroundImage: AssetImage('assets/imagenes/logo_no_img.png'),
                                    ),
                        )             
                 ),
          ),
          shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(15)
          ),
   );
}
}




