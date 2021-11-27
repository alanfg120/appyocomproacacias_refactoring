import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/cubit/inicio.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/state/inicio.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/widgets/loading.widgtes.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/cardEmpresa.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final homeState = context.read<HomeCubit>().state;
    final usuario = homeState.currentUsuario;
    final urlImagenes = homeState.url;

 /*    if(homeState.page == 1 
       || (homeState.page == 0 && usuario == TipoUsuario.LODGET)) */
    return Scaffold(
           backgroundColor: Colors.grey[100],
             appBar: AppBar(
                     leading : Image.asset('assets/imagenes/logo.png'),
                     title   : Text('Yo Compro Acacias',style: TextStyle(fontSize: 21,fontWeight: FontWeight.w400)),
                     elevation: 0,
                     actions: [
                       if(usuario == TipoUsuario.LODGET)
                       _butonIconNotification(context),
                       SizedBox(width: 15),
                     ],
             ),
           body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                           crossAxisAlignment : CrossAxisAlignment.start,
                           children: [
                               _search(context),
                               _titulo('Nuestros videos'),
                               _videos(context),
                               _titulo('Top 10'),
                               _top(context,urlImagenes)
                           ],
             ),
            ), 
    );
    //return Container();
  
  }
_titulo(String titulo) {
    return Padding(
           padding:  EdgeInsets.all(8.0),
           child: Text(titulo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19)),
   );
  }

_butonIconNotification(BuildContext context) {
   return BlocSelector<InicioCubit,InicioState,int>(
          selector : (state) => state.notificacionesNoLeidas,
          builder  : (context,notificaciones){
             return Badge(
                    badgeContent : notificaciones > 0
                                   ? Text('$notificaciones',
                                          style: TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 13
                                          )
                                   )
                                   : null,
                    position     : BadgePosition(top: 3,start: 28),
                    badgeColor   : Colors.red,
                    child        : IconButton(
                                   icon      : Icon(Icons.notifications_outlined),
                                   color     : Theme.of(context).primaryColor,
                                   iconSize  : 30,
                                   onPressed : () => NavigationService().navigateTo('notificaciones')
                    ),
     );
     }
   );
           /* return IconButton(
                  icon      : Icon(Icons.notifications_outlined),
                  color     : Colors.grey,
                  iconSize  : 30,
                  onPressed : ()=>Get.to(NotificationPage())
           ); */
}
           
_search(BuildContext context) {
  return GestureDetector(
         child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                       height    : 50,
                       padding   : EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                       decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(40)
                       ),
                       child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Buscar Comercios'),
                                Icon(Icons.search,color: Theme.of(context).primaryColor),
                              ]
                       ),
                ),
         ),
         onTap: () => NavigationService().navigateTo('search_empresa')
  );
} 
 
_videos(BuildContext context) {
    return BlocBuilder<InicioCubit,InicioState>(
      builder: (context,state){
        if(state.loading)
          return LoadingVideoYoutubeWidget();
        return Container(
             color   : Colors.white,
             padding : EdgeInsets.all(15),
             height  : MediaQuery.of(context).size.height * 0.25,
             child   : ListView.separated(
                       separatorBuilder : (_,index) => SizedBox(width: 10),
                       scrollDirection  : Axis.horizontal,
                       itemCount        : state.videos.length,
                       itemBuilder      : (_,int index) {
                                            return GestureDetector(
                                                   child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(20),
                                                          child: CachedNetworkImage(
                                                                 fit         : BoxFit.cover,
                                                                 width       : 200,
                                                                 height      : 200,
                                                                 imageUrl    : state.videos[index].urlImagen,
                                                                 placeholder : (context, url) =>  Image.asset('assets/imagenes/load_image.gif'),
                                                                 errorWidget : (context, url, error) => Icon(Icons.error),
                                                     ),
                                                   ),
                                                   onTap: ()=> state.videos[index].goToVideo()
                                            );
                        }
             )
      );
      }
    );
  }
    
_top(BuildContext context,String url) {
    return BlocBuilder<InicioCubit,InicioState>(
           builder: (context,state){
             if(state.loading)
               return TopLoadindWidget();
             return Expanded(
             child : ListView.builder(
                      itemCount   : state.empresas.length,
                      itemBuilder : (_, int index) {
                      return CardEmpresa(
                             empresa : state.empresas[index],
                             url     : url
                      );
                     },
           )            
           );
    },
    );
}



}
