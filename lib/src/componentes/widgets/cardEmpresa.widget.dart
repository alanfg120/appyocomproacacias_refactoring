import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/views/perfil.empresa.view.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardEmpresa extends StatelessWidget {
  final Empresa empresa;
  final String url;
  const CardEmpresa({Key? key,required this.empresa,required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          child: Card(
                 elevation: 2,
                 child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: ListTile(
                               title    : Text(empresa.nombre,
                                          style: TextStyle(
                                                 fontWeight: FontWeight.bold
                                          )),
                               subtitle : Text(empresa.descripcion,
                                          overflow: TextOverflow.ellipsis,
                                          ),
                               leading  : empresa.urlLogo == ''
                                          ? 
                                          CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage('assets/imagenes/logo_no_img.png'),
                                          )
                                          :
                                          CircleAvatar(
                                          radius: 30,
                                          backgroundImage: CachedNetworkImageProvider('$url/logo/${empresa.urlLogo}'),
                                          )
                        ),
                 ),
                 shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                 ),
          ),
        onTap: ()=> NavigationService().navigateToRoute(
           MaterialPageRoute(builder: (context)=> PerfilEmpresaPage(empresa: empresa))
        ),
   );
  }
}
