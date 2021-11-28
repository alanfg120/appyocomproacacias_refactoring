import 'package:appyocomproacacias_refactoring/src/componentes/empresas/cubit/perfil_empresa_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/calificacion.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/views/perfil.empresa.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/widgets/calificacion.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalificacionesWidget extends StatelessWidget {

  const CalificacionesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerfilEmpresaCubit,PerfilEmpresaState>(
           builder: (context,state){
             if(state.loading)
              return Center(child: CircularProgressIndicator());
           return  Column(
                   children: [
                    Padding(
                    padding : EdgeInsets.all(8.0),
                    child   : Text('Empresa',style:TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    _CardEmpresa(empresa: state.empresa!),
                    Padding(
                    padding : EdgeInsets.all(8.0),
                    child   : Text('Calificaciones',style:TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                    child: _ListCalificaciones(calificaciones: state.calificaciones)
                    )
                   ],
                    );
             
           }
    );
  }
}

class _CardEmpresa extends StatelessWidget {
  final Empresa empresa;
  const _CardEmpresa({Key? key,required this.empresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
     return GestureDetector(
          child: Card(
                 elevation: 0,
                 child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                   MaterialPageRoute(builder: (context) => PerfilEmpresaPage(empresa: empresa))
      )
   );
  }
}
class _ListCalificaciones extends StatelessWidget {

  final List<Calificacion> calificaciones;
  const _ListCalificaciones({Key? key,required this.calificaciones}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().urlImagenes;
    return ListView.builder(
           itemCount  : calificaciones.length,
           itemBuilder: (_,i){
              return Card(
                     elevation: 0,
                     color    : Colors.white,
                     shape    : RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(15)
                     ),
                     child    : Padding(
                                padding :  EdgeInsets.symmetric(horizontal: 4,vertical: 10),
                                child   :  Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                            ListTile(
                                            title   : Text(calificaciones[i].usuario!.nombre!),
                                            leading : calificaciones[i].usuario!.nombre == ''
                                                      ? CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage: AssetImage('assets/imagenes/logo_no_img.png'),
                                                      )
                                                      : CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage: CachedNetworkImageProvider('$url/usuarios/${calificaciones[i].usuario!.imagen}'),
                                                      )
                                            ),
                                            Padding(
                                            padding : EdgeInsets.only(left: 25),
                                            child   : CalificacionWidget(
                                                      extrellas : calificaciones[i].extrellas,
                                                      centrado  : false,
                                                      size      : 20
                                            ),
                                            ),
                                            Padding(
                                            padding : const EdgeInsets.only(left: 30),
                                            child   : Text(calificaciones[i].comentario),
                                            )
                                          ],
                                ),
                     )
              );
           }
    );
  }
}