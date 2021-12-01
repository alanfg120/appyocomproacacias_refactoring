
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/bloc/empresas_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/cubit/perfil_empresa_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/widgets/calificacion.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/widgets/calificar.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/widgets/datosCard.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/widgets/loadingsEmpresa.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/widgets/productoCardSmall.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/widget/publicacion.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/InputForm.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/url_laucher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class PerfilEmpresaPage extends StatefulWidget {

  final Empresa empresa;
  final bool propia;
  PerfilEmpresaPage({Key? key,required this.empresa,this.propia = false}) : super(key: key);

  @override
  _PerfilEmpresaPageState createState() => _PerfilEmpresaPageState();
}

class _PerfilEmpresaPageState extends State<PerfilEmpresaPage> {

  final _controller = PageController(initialPage: 0);
  final bloc = PerfilEmpresaCubit(repositorio: EmpresaRepositorio(),prefs: PreferenciasUsuario());

  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

        final homeState = context.read<HomeCubit>().state;
        final url = homeState.url;
        final TipoUsuario usuario = homeState.currentUsuario;
        context.read<EmpresasBloc>().add(
           RegistarVisitaEmpresaEvent(
           idEmpresa: widget.empresa.id!
           )
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
               value: SystemUiOverlayStyle(
                       statusBarIconBrightness : Brightness.light,
                       statusBarBrightness     : Brightness.dark,
               ),
               child: Scaffold(
                      backgroundColor: Colors.grey[300],
                      body : BlocProvider<PerfilEmpresaCubit>(
                             create  : (BuildContext context) => bloc,
                             child  : Column(
                                      children: <Widget>[
                                                _Header(
                                                empresa : widget.empresa, 
                                                url     : url,
                                                propia  : widget.propia,
                                                usuario : usuario,
                                                ),
                                                SizedBox(height:30),
                                                _Titulo(controller: _controller,usuario: usuario),
                                                Expanded(
                                                child: PageView(
                                                       controller : _controller,
                                                       children   : <Widget>[
                                                                    _DatosEmpresa(empresa : widget.empresa),
                                                                    _PublicacionesEmpresa(
                                                                     usuario : usuario, 
                                                                     url     : url,
                                                                    ),
                                                                    _CalificacionesEmpresa(url: url),
                                                                    if(usuario == TipoUsuario.LODGET)
                                                                    _ProductosEmpresa(url: url)
                                                       ],
                                                       onPageChanged: (pagina){
                                                         bloc.selectPagina(pagina);
                                                         _getData(pagina);
                                                       }
                                                ),
                                                )
                                      ],
                            ),
                      ), 
              ),
        );
           
  }

  void _getData(int pagina) {
    if(pagina == 1)
     context.read<PublicacionesCubit>().getPublicacionesEmpresa(widget.empresa.id!);
    if(pagina == 2)
     bloc.getCalificacionesEmpresa(widget.empresa.id!);
  }

}


class _Header extends StatelessWidget {

  final Empresa empresa;
  final String  url;
  final bool propia;
  final TipoUsuario usuario;
  

  const _Header(
        {Key? key,
        required this.empresa,
        required this.url,
        required this.propia,
        required this.usuario,
       }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final cubit = context.read<PerfilEmpresaCubit>();
     return  SizedBox(
             height : 260,
             width  : MediaQuery.of(context).size.width,
             child  : Stack(
                      clipBehavior: Clip.none, 
                      children : <Widget>[
                                 Positioned.fill(
                                 child :  empresa.urlLogo == ''
                                          ?
                                          Container()
                                          :
                                          CachedNetworkImage(
                                          imageUrl    : '$url/logo/${empresa.urlLogo}',
                                          fit         : BoxFit.cover,
                                 ),
                                 ),
                                 Positioned.fill(
                                 child: Opacity(
                                        opacity: 0.6,
                                        child: Container(color: Colors.black),
                                 )
                                 ),
                                Positioned(
                                top   : 40,
                                left  : 10,
                                child : IconButton(
                                        icon     : BackButtonIcon(), 
                                        color    : Colors.white,
                                        onPressed: () =>NavigationService().back()
                                ),
                                ),
                                Align(
                                alignment: Alignment(0.0,-0.2),
                                child: Text(empresa.nombre,
                                            style : TextStyle(
                                                    color      : Colors.white,
                                                    fontSize   : 20,
                                                    fontWeight : FontWeight.bold
                                                    )
                                           ),
                                ),
                                if(!propia && usuario == TipoUsuario.LODGET)
                                Align(
                                alignment: Alignment(0.92,1),
                                child: RawChip(
                                       backgroundColor : Colors.transparent,
                                       visualDensity   : VisualDensity.compact,
                                       label           : Text('Calificar'),
                                       labelStyle      : TextStyle(color: Colors.blue),
                                       onPressed       : () => showDialog(
                                                               context: context,
                                                               builder: (ctx) => _DialogCalificar(cubit:cubit,empresa: empresa)
                                                               ) 
                                       )
                                ),
                                Align(
                                alignment : Alignment(0.0, 1.5),
                                child     :  empresa.urlLogo == ''
                                             ?
                                             CircleAvatar(
                                             radius          : 75,
                                             backgroundImage : AssetImage('assets/imagenes/logo_no_img.png')
                                             )
                                             :
                                             CircleAvatar(
                                             radius          : 75,
                                             backgroundImage : CachedNetworkImageProvider('$url/logo/${empresa.urlLogo}'),
                                             )
                                )
                      ]
             ),
     );
  }
}

class _Titulo extends StatelessWidget {
  final TipoUsuario usuario;
  final PageController controller;
  const _Titulo(
        {Key? key,
         required this.controller,
         required this.usuario}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 15),
     child: Container(
       height: 50,
       decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(10)
       ),
       child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               _tabItem(context,controller,'Datos',0),
               _tabItem(context,controller,'Publicaciones',1),
               _tabItem(context,controller,'Calificaciones',2),
               if(usuario == TipoUsuario.LODGET)
               _tabItem(context,controller,'Productos',3)
              ],
       )
     ),
   );
 }

 _tabItem(BuildContext context,PageController controller,String titulo, int index) {
    return  BlocBuilder<PerfilEmpresaCubit, PerfilEmpresaState>(
      builder: (context, state) {
        return Container(
                height     : 50,
                decoration : state.pagina == index
                            ? BoxDecoration(
                              border : Border(
                              bottom : BorderSide(
                                       color : Theme.of(context).primaryColor,
                                       width : 3
                              )
                            )
                            )
                            : null,
                child     : GestureDetector(
                            child : Center(child: Text(titulo,textAlign: TextAlign.center)),
                            onTap : () {
                              controller.animateToPage(
                                         index, 
                                         duration: Duration(milliseconds: 300), 
                                         curve: Curves.easeIn
                                         );
                              context.read<PerfilEmpresaCubit>().selectPagina(index);
                            }
                )
        );
      },
    );
  }
}

class _DatosEmpresa extends StatelessWidget {

  final Empresa empresa;
  const _DatosEmpresa({Key? key,required this.empresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
           child: Column(
             children: <Widget>[
                      DatosCard(
                      titulo  : empresa.descripcion,
                      tipo    : "Descripción",
                      icon    : Icons.info_outline,
                      ),
                      DatosCard(
                      titulo  : empresa.direccion,
                      vinculo : "Como Llegar",
                      tipo    : "Dirección",
                      icon    : Icons.map,
                      onPressed: (titulo) async {
                          gotoMap(empresa.latitud, empresa.longitud);
                      },
                      ),
                      DatosCard(
                      titulo  :  empresa.telefono,
                      vinculo : "Llamar",
                      tipo    : "Telefono",
                      icon    : Icons.phone_android,
                      onPressed: (telefono){
                         gotoCall(telefono);
                      },
                      ),
                      DatosCard(
                      titulo  :  empresa.whatsapp,
                      vinculo : "Enviar Mensaje",
                      tipo    : "Whatsapp",
                      icon    : Icons.message,
                      onPressed: (whatsapp){
                         goToWhatsapp(whatsapp);
                      },
                      ),
                      DatosCard(
                      titulo  :  empresa.email,
                      vinculo : "Enviar",
                      tipo    : "Correo",
                      icon    : Icons.mail,
                      onPressed: (mail){
                        gotoMail(mail);
                      },
                      ),
                      DatosCard(
                      titulo  :  empresa.web,
                      vinculo : "Ver",
                      tipo    : "Web",
                      icon    : Icons.web_asset,
                      onPressed: (web){
                         gotoWeb(web);
                      },
                      ),
             ],
           ),
    );
  }
}

class _PublicacionesEmpresa extends StatelessWidget {  

  final TipoUsuario usuario;
  final String url;
  const _PublicacionesEmpresa(
         {Key? key,
          required this.usuario,
          required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicacionesCubit,PublicacionesState>(
             builder: (context,state){
             if(state.loading)
                return PublicacionesEmpresaLoading();
              if(state.publicacionesByEmpresa.length == 0)
                return Center(child: const Text('No hay publicaciones'));
              return ListView.builder(
                     padding: EdgeInsets.all(10),
                     itemCount: state.publicacionesByEmpresa.length,
                     itemBuilder: (contex,i){
                      return PublicacionCard(
                             publicacion : state.publicacionesByEmpresa[i],
                             onlyEmpresa : true,
                             usuario     : usuario,
                             url         : url,
                      );
                     }
                     );
             },
    );
}
}

class _CalificacionesEmpresa extends StatelessWidget {

  final String url;
  const _CalificacionesEmpresa({Key? key,required this.url}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
  

    return BlocBuilder<PerfilEmpresaCubit,PerfilEmpresaState>(
           builder: (context,state){
           final calificaciones = state.calificaciones;
           if(state.loading)
              return LoadingCalificaciones();
           if(calificaciones.length == 0)
              return Center(child: Text('No hay Calificaciones'));
           return ListView.builder(
                 padding  : EdgeInsets.all(10),
                 itemCount: calificaciones.length,
                 itemBuilder: (_,i){
                   return Card(
                          elevation: 0,
                          color    : Colors.white,
                          shape    : RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(15)
                          ),
                          child    : Padding(
                                     padding : const EdgeInsets.symmetric(horizontal: 4,vertical: 10),
                                     child   : Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                           ListTile(
                                                           leading: calificaciones[i].usuario!.imagen!.nombre.isEmpty
                                                                    ? CircleAvatar(
                                                                      radius          : 30,
                                                                      backgroundImage : AssetImage('assets/imagenes/logo_no_img.png')
                                                                      )
                                                                    : CircleAvatar(
                                                                      radius          : 30,
                                                                      backgroundImage : CachedNetworkImageProvider('$url/usuarios/${calificaciones[i].usuario!.imagen!.nombre}')
                                                                      ),
                                                           title    : Text(calificaciones[i].usuario!.nombre!),
                                                           ),
                                                           Padding(
                                                           padding : const EdgeInsets.only(left: 25),
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
          );
  }
}

class _ProductosEmpresa extends StatelessWidget {

  final String url;
  const _ProductosEmpresa({Key? key,required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerfilEmpresaCubit,PerfilEmpresaState>(
           builder: (context,state){
            if(state.loading)
              return Center(child: CircularProgressIndicator());
            if(state.productos.length == 0)
              return Center(child: const Text('No hay Productos'));
            return GridView.builder(
                    padding      : EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                    itemCount    : state.productos.length,
                    gridDelegate : SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 10),
                    itemBuilder  : (_, index){
                      return  GestureDetector(
                              child : ProductoCardSmall(producto: state.productos[index],url: url),
                              onTap : () {
                                /*    Get.to(ProductoPage());
                                   state.getProductosByEmpresa(state.productos[index].empresa.id);
                                   Get.find<ProductosController>().selectProducto(state.productos[index]); */
                              }
                      );
                    },
         
            );
           }
    );
  }
}

class _DialogCalificar extends StatelessWidget {
  final Empresa empresa;
  final PerfilEmpresaCubit cubit;

  _DialogCalificar(
    {Key? key,
     required this.cubit,
     required this.empresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      String texto = '';

    return  AlertDialog(
            title   : const Text('Calificar empresa'),
            content : BlocConsumer<PerfilEmpresaCubit,PerfilEmpresaState>(
                      listener: (context,state){
                        if(!state.loadingCalifiacion && !state.duplicado){
                           NavigationService().back();
                        }
                        if(state.duplicado){
                          snacKBar('Ya Calificaste esta empresa', context);
                        }
                      },
                      listenWhen: (previusState,state) {
                       return previusState.loadingCalifiacion != state.loadingCalifiacion 
                              || previusState.duplicado != state.duplicado;
                      },
                      bloc : cubit,
                      builder: (context,state){
                         if(state.loadingCalifiacion)
                          return Container(
                                 height: 100,
                                 child: Center(child: CircularProgressIndicator()));
                         return  Column(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                     CalificarWidget(cubit: cubit),
                                     SizedBox(height: 20),
                                     InputForm(
                                     placeholder : "Escribe un Comentario",
                                     autofocus   : true, 
                                     textcenter  : false,
                                     onChanged   : (text) => texto = text,
                                     )
                     ],
                     );
            },
            ),
            actions : [
              ElevatedButton(
                     child : const Text('Aceptar'),
                     style : ElevatedButton.styleFrom(
                             primary: Theme.of(context).primaryColor,
                             textStyle: TextStyle(color: Colors.white)
                     ),
                     onPressed:  () {
                       cubit.calicarEmpresa(
                             context.read<HomeCubit>().state.usuario!,
                             empresa.idUsuario, 
                             empresa.id!, 
                             texto
                       );
                     }
                     ),
                     ElevatedButton(
                     child : const Text('Cancelar'),
                     style : ElevatedButton.styleFrom(
                             primary: Theme.of(context).accentColor,
                             textStyle: TextStyle(color: Colors.white)
                     ),
                     onPressed: () => Navigator.pop(context,false),
                     )
            ],
    );
  }
}