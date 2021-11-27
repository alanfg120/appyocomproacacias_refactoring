import 'package:appyocomproacacias_refactoring/src/componentes/categorias/views/listCategorias.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/views/searchEmpresas.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/views/home.vista.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/views/offline.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/views/notificaciones.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/views/iniciar.sesion.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/views/login.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/views/registro.view.dart';
import 'package:flutter/material.dart';

 routes(BuildContext context) => {
                'home'            : (context) => HomePage(),
                'login'           : (context) => LoginPage(),
                'loginForm'       : (context) => LoginFormPage(),
                'registro'        : (context) => RegistroFormPage(),
                'search_empresa'  : (context) => SearchEmpresasPage(),
                'offline'         : (context) => OfflinePage(),
                'notificaciones'  : (context) => NotificationPage(),
                'categorias'      : (context) => ListCategoriasPage(),
                };