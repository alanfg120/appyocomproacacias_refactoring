

import 'package:appyocomproacacias_refactoring/src/componentes/empresas/bloc/empresas_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/data/empresa.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/widgets/loadingSearch.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/cardEmpresa.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchEmpresasPage extends StatefulWidget {

  SearchEmpresasPage({Key? key}) : super(key: key);

  @override
  _SearchEmpresasPageState createState() => _SearchEmpresasPageState();
}

class _SearchEmpresasPageState extends State<SearchEmpresasPage> {

  final _bloc = EmpresasBloc(repositorio: EmpresaRepositorio(),prefs: PreferenciasUsuario());

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().state.url;
    return Scaffold(
            appBar: AppBar(
                    title: TextField(
                           style      : TextStyle(fontSize: 18),
                           autofocus  : true,
                           decoration : InputDecoration(
                                        hintText  : "Buscar",
                                        hintStyle : TextStyle(fontSize: 15),
                                        border    : InputBorder.none
                                        ),
                           onChanged  : (value) => _bloc.add(SearchEmpresaEvent(value))
                    ),
                    elevation: 0,
            ),
            body: BlocBuilder<EmpresasBloc,EmpresasState>(
                  bloc   : _bloc,
                  builder: (context,state){
                    if(state.loading)
                      return SeachEmpresasLoading();
                    if(state.resultEmpresa.length == 0)
                      return Center(child: const Text('Sin resultados'));
                    return _listEmpresas(state.resultEmpresa,url);
                  },
            )
    );
  }

  Widget _listEmpresas(List<Empresa> empresas,String url) {
    return ListView.builder(
           itemCount   : empresas.length,
           itemBuilder : (context,index) {
               return CardEmpresa(
                      empresa     : empresas[index],
                      url         : url
              );
           }
    );
  }
}