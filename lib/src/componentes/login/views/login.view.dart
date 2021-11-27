import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/socialAuth.enum.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/cubit/login.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/state/login.state.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/widgets/button_apple.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/login/widgets/button_google.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/snack.widged.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if(state.error == ErrorLoginResponse.ERROR_SOCIAL_SING)
         snacKBar('Ocurrio un Error', context);
        if(state.error == ErrorLoginResponse.USER_EXITS)
         snacKBar('Ya existe el usuario', context);
        if(state.logiado){
            context.read<HomeCubit>().updateUsuario(state.usuario);
        }
      },
      listenWhen: (prevState,currentState){
        if(prevState.loading != currentState.loading)
          return true;
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _cortina(),
            _logo(),
            _ButtonLogin(titulo: 'Iniciar Sesión'),
            _ButtonLogin(titulo: 'Registrate'),
            _politica()
          ],
        ),
      ),
    );
  }

  Widget _cortina() {
    return SlideInDown(
        //manualTrigger: true,
        //controller   : (controller)=> Get.find<HomeController>().controller = controller,
        delay: Duration(milliseconds: 100),
        duration: Duration(milliseconds: 300),
        child: Image.asset('assets/imagenes/cortina.png'));
  }

  Widget _logo() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      alignment: Alignment(0.0, -0.8),
      child: Image.asset(
        'assets/imagenes/logo.png',
        width: 250,
        height: 250,
      ),
    );
  }

  Widget _politica() {
    return Align(
      alignment: Alignment(0, 0.9),
      child: GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(19.0),
            child: Text(
              'Ver politica de privacidad',
              style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  color: Colors.blue),
            ),
          ),
          onTap: () {}),
    );
  }
}

class _ButtonLogin extends StatelessWidget {
  final String titulo;
  const _ButtonLogin({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: titulo == 'Iniciar Sesión'
          ? Alignment(0.0, 0.45)
          : Alignment(0.0, 0.7),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: Colors.white),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            primary: titulo == 'Iniciar Sesión'
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
            padding: EdgeInsets.all(18),
          ),
          child: Text(titulo, style: TextStyle(fontSize: 20)),
          onPressed: () {
            titulo == 'Iniciar Sesión'
                ? NavigationService().navigateTo('loginForm')
                : dialogOptionRegistro(context);
          },
        ),
      ),
    );
  }

  void dialogOptionRegistro(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade50,
            title: Text('Registrate'),
            content: Container(
              height: 320,
              child: Column(children: [
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        child: Text('Ingresa tus Datos'),
                        style: ElevatedButton.styleFrom(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          padding: EdgeInsets.all(15),
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () {
                          NavigationService().back();
                          NavigationService().navigateTo('registro');
                        })),
                SizedBox(height: 20),
                ButtonSocialSing(
                    logo: 'assets/imagenes/google_icon.jpg',
                    texto: 'Regístrate con Google',
                    onPress: () {
                      NavigationService().back();
                      BlocProvider.of<LoginCubit>(context)
                          .resgistreWithSocial(SocialAuthType.GOOGLE);
                    }),
                SizedBox(height: 20),
                ButtonSocialSing(
                    logo: 'assets/imagenes/facebook_icon.png',
                    texto: 'Regístrate con Facebook',
                    onPress: () {
                      NavigationService().back();
                      BlocProvider.of<LoginCubit>(context)
                          .resgistreWithSocial(SocialAuthType.FACEBOOK);
                    }),
                SizedBox(height: 20),
                if (Platform.isIOS)
                  ButtonAppleSing(
                      texto: 'Registrarse con Apple',
                      onTap: () {
                        NavigationService().back();
                        BlocProvider.of<LoginCubit>(context)
                            .resgistreWithSocial(SocialAuthType.APPLE);
                      })
              ]),
            ),
          );
        });
  }
}
