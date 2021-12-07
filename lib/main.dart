import 'package:appyocomproacacias_refactoring/src/componentes/categorias/bloc/categorias_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/data/categorias.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/bloc/empresas_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/data/home.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/cubit/inicio.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/data/inicio.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/cubit/login.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/data/login.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/bloc/pedidos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/pedidos/data/pedidos.repocitorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/bloc/productos_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/productos/data/productos.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/cubit/publicaciones_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/publicaciones/data/publicaciones.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/cubit/usuario_cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/usuarios/data/usuario.repository.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/bloc.observer.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/dio.singleton.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/routes.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:intl/intl.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Intl.defaultLocale = 'es_ES';
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  //prefs.eraseall();
  DioHttp().initDio('http://192.168.1.2:8000',prefs.token);
  final homeCubit = HomeCubit(
                    repositorio  : HomeRepocitorio(),
                    preferencias : PreferenciasUsuario(),
                    urlImagenes  : 'http://192.168.1.2:8000/imagenes'
  );
 homeCubit.stream.firstWhere((state) => state.loading == false).then((value){
     BlocOverrides.runZoned(() async {
        await homeCubit.validateInternet();
         runApp(MyApp(homeCubit: homeCubit));
     },blocObserver: MyBlocObserver());
 });
  await homeCubit.validateInternet();
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final HomeCubit? homeCubit;
  MyApp({this.homeCubit,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context)  {
  
    return MultiBlocProvider(
           providers: [
             BlocProvider<LoginCubit>(
             create: (context) => LoginCubit(repositorio: LoginRepositorio(),prefs: PreferenciasUsuario())
             ),
             BlocProvider<InicioCubit>(
             create: (context) => InicioCubit(repocitorio: InicioRepositorio(),prefs:PreferenciasUsuario()),
             ),
             BlocProvider<PublicacionesCubit>(
             create: (context) => PublicacionesCubit(repositorio: PublicacionesRepositorio(),prefs:PreferenciasUsuario()),
             ),
             BlocProvider<EmpresasBloc>(
             //lazy: false,
             create: (context) => EmpresasBloc(repositorio: EmpresaRepositorio(),prefs:PreferenciasUsuario())..add(GetEmpresas(empresas: homeCubit!.state.usuario!.empresas)),
             ),
             BlocProvider<CategoriasBloc>(
             create: (context) => CategoriasBloc(CategoriaRepositorio())..add(GetCategoriasEvent()),
             ),
             BlocProvider.value(
             value: homeCubit!
             ),
             BlocProvider<UsuarioCubit>(
             create: (context) => UsuarioCubit(usuario: homeCubit!.state.usuario!,repocitorio: UsuarioRepocitorio()),
             ),
             BlocProvider<ProductosBloc>(
             create: (context) => ProductosBloc(repocitorio: ProductosRepositorio(),prefs: PreferenciasUsuario())..add(GetInitialData()),
             ),
             BlocProvider<PedidosBloc>(
             create: (context) => PedidosBloc(repocitorio: PedidoRepocitorio(),prefs: PreferenciasUsuario()),
             ),
           ],
           child: BlocSelector<HomeCubit,HomeState,bool>(
             selector: (state) => state.offline,
             builder: (context, offline){
             return MaterialApp(
               navigatorKey: NavigationService().navigationKey,
               localizationsDelegates: [
                 GlobalMaterialLocalizations.delegate,
                 GlobalWidgetsLocalizations.delegate,
                 GlobalCupertinoLocalizations.delegate,
                 DefaultCupertinoLocalizations.delegate
               ],
               supportedLocales: [  const Locale('es'),],
               debugShowCheckedModeBanner: false,
               title: 'YoComproAcacias',
               theme: ThemeData(
                      primaryColor  : Color.fromRGBO(255,57,163, 1),
                      accentColor   : Color.fromRGBO(0, 201, 211, 1),
                      visualDensity : VisualDensity.adaptivePlatformDensity,
                      appBarTheme   : AppBarTheme(
                                      brightness: Brightness.light,
                                      color: Colors.white,
                                      textTheme: TextTheme(
                                                 // ignore: deprecated_member_use
                                                 title: TextStyle(color:Colors.black,fontSize: 20)
                                      ),
                                      iconTheme:  IconThemeData(
                                                  color: Colors.black
                                      )
                       )
                ),
                initialRoute: offline ? 'offline' : 'home',
                routes: routes(context)
                );
                }
           ),
    );
  } 
}

 