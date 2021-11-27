import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class ListCategoriasLoading extends StatelessWidget {
  const ListCategoriasLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
           padding    : const EdgeInsets.all(10),
           itemCount  : 2,
           itemBuilder: (_,i){
             return Card(
                    child: ListTile(
                           leading : ShimmerLoading(
                                     child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                     )
                           ),
                    ),
             );
           }
           );
  }
}