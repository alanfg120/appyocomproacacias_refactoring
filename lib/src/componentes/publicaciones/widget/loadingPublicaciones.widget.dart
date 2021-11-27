import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class PublicacionesLoading extends StatelessWidget {
  const PublicacionesLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
           delegate: SliverChildBuilderDelegate(
                     (context,index){
                       return const PublicacionCardLoading();
                     },
                     childCount: 10
           ),
    );
  }
}

class PublicacionCardLoading extends StatelessWidget {

  const PublicacionCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Card(
           shape     : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
           elevation : 0,
           margin    : EdgeInsets.all(4),
           child     : Column(
                       children: [
                         _header(),
                         _imagen(),
                         _texto(),
                         _footer()
                       ],
           )
      );
  }

  _header() {
    return ListTile(
          contentPadding : const EdgeInsets.all(10),
          title          : ShimmerLoading(
                           child: Container(
                                  height: 12,
                                  width: 10,
                                  color: Colors.grey
                           ),
          ),
          subtitle      : ShimmerLoading(
                          child: Container(
                             height: 8,
                             width: 10,
                             color: Colors.grey
                          ),
          ),
          leading  : ShimmerLoading(
                      child: CircleAvatar(
                             radius: 30,
                             backgroundImage: AssetImage('assets/imagenes/logo_no_img.png'),
                      ),
          )             
          );
  }

  _imagen() {
    return ShimmerLoading(
           child: Padding(
             padding: const EdgeInsets.all(10.0),
             child: Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey,
             ),
           )
           );
  }

  _texto() {
    return ShimmerLoading(
           child: Padding(
             padding: const EdgeInsets.all(10.0),
             child: Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.grey,
             ),
           )
           );
  }

  _footer() {
    return Padding(
           padding: const EdgeInsets.all(10.0),
           child: Container(
                  width: double.infinity,
                  height: 30,
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                           ShimmerLoading(child: const Icon(Icons.thumb_up,)),
                           ShimmerLoading(child: const Icon(Icons.textsms)),
                           ShimmerLoading(
                           child: Container(
                                  height : 20,
                                  width  : 50,
                                  decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey
                                  ),
                           )
                           ),
                           ShimmerLoading(
                           child: Container(
                                  height : 20,
                                  width  : 50,
                                  decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey
                                  ),
                           )
                           )
                         ]
                         ),
      ),
    );
  }
}