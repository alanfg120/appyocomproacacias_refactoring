

import 'package:appyocomproacacias_refactoring/src/componentes/categorias/bloc/categorias_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/data/categorias.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/widgets/loadingSearch.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/cardEmpresa.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchEmpresasByCategoriaPage extends StatelessWidget {

  final String categoria;

  SearchEmpresasByCategoriaPage({Key? key,required this.categoria}) : super(key: key);
  final _bloc = CategoriasBloc(CategoriaRepositorio());
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
                           onChanged  : (value) => _bloc.add(SearchEmpresasEvent(categoria: categoria,text: value))
                    ),
                    elevation: 0,
            ),
            body: BlocProvider<CategoriasBloc>(
                  create: (context) => _bloc,
                  child: BlocBuilder<CategoriasBloc,CategoriasState>(
                         builder: (context,state){
                           if(state.loading)
                             return SeachEmpresasLoading();
                           if(state.resultEmpresas.length == 0)
                             return Center(child: const Text('Sin resultados'));
                           return _ListEmpresas(empresas: state.resultEmpresas, url: url);
                         },
                        ),
            )
    );
  }

}

class _ListEmpresas extends StatelessWidget {

  final List<Empresa> empresas;
  final String url;
  const _ListEmpresas({Key? key,required this.empresas,required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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