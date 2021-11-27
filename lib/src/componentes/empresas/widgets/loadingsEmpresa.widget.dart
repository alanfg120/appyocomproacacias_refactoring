import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/widget/loadingPublicaciones.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class LoadingCalificaciones extends StatelessWidget {
  const LoadingCalificaciones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
           padding  : EdgeInsets.all(10),
           itemCount   : 5,
           itemBuilder : (_,i) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 10),
                  child: ListTile(
                         leading : ShimmerLoading(
                                   child: CircleAvatar(
                                          radius         : 30,
                                          backgroundColor: Colors.grey,
                                   ),
                         ),
                         title   : Row(
                                   children: List.generate(5, 
                                             (index) => ShimmerLoading(
                                                        child: Icon(Icons.star_rate,size: 20)
                                                        )
                                   ),
                         ),
                         subtitle: ShimmerLoading(
                                   child: Container(width: double.infinity,height: 10,color: Colors.grey)
                         ),
                  ),
                ),
              );
           }
    );
  }
}

class PublicacionesEmpresaLoading extends StatelessWidget {
  const PublicacionesEmpresaLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       return ListView.builder(
           padding  : EdgeInsets.all(10),
           itemCount   : 3,
           itemBuilder : (_,i) {
                return PublicacionCardLoading();
           });
  }
}