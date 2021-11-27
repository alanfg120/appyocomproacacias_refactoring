import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeachEmpresasLoading extends StatelessWidget {
  const SeachEmpresasLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
           itemCount: 6,
           itemBuilder: (context,i){
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            );
           }
    );
  }
}