import 'package:appyocomproacacias_refactoring/src/componentes/categorias/bloc/categorias_bloc.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/categoria.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/categorias/views/searchEmpresas.view.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/models/empresa.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/empresas/widgets/loadingSearch.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/cubit/home.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/cardEmpresa.widget.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/widgets/shimmer.widget.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/navigator.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListEmpresaCategorias extends StatefulWidget {

  final String assetImage;
  final String titulo;
  final CategoriaEnum categoria;
  final String? otherCategoria;
  const ListEmpresaCategorias(
        {Key? key,
         this.otherCategoria,
         required this.assetImage,
         required this.titulo,
         required this.categoria}) : super(key: key);

  @override
  _ListEmpresaCategoriasState createState() => _ListEmpresaCategoriasState();
}

class _ListEmpresaCategoriasState extends State<ListEmpresaCategorias> {
   
  final _controller = ScrollController();

   
  @override
  void initState() {
    _controller.addListener(_scrollLinstener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final url = context.read<HomeCubit>().state.url;
    return Scaffold(
           appBar : AppBar(
                    elevation : 0,
                    title     : Text(widget.titulo),
                    centerTitle: true,
                    actions   : [
                      if(widget.assetImage.isNotEmpty)
                      Image.asset(widget.assetImage,height: 45,width: 45),
                      SizedBox(width: 10)
                    ],
           ),
           body   : BlocBuilder<CategoriasBloc,CategoriasState>(
                      builder : (context,state){
                           if(state.loading)
                             return SeachEmpresasLoading();
                           return Column(
                                  children: [
                                    _SearchBar(titulo:widget.titulo,categoria: _getCategoria()),
                                    Expanded(
                                    child: _ListEmpresasCategoria(
                                           controller : _controller,
                                           empresas   : state.empresas, 
                                           url        : url,
                                           end        : state.end,
                                    )
                                    )
                                  ],
                           );
                      },
             ),
    );
  }

  void _scrollLinstener() {
     if (_controller.position.pixels == _controller.position.maxScrollExtent){
       context.read<CategoriasBloc>().add(GetNewEmpresasEvent(_getCategoria()));
   }
  }

  String _getCategoria(){
    return widget.categoria.toString().split('.')[1];
  }
}

class _ListEmpresasCategoria extends StatelessWidget {

  final List<Empresa> empresas;
  final String url;
  final ScrollController controller;
  final bool end;
  const _ListEmpresasCategoria(
         {Key? key,
          required this.empresas,
          required this.url,
          required this.controller,
          required this.end}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return ListView.builder(
            controller  : controller,
            itemCount   : end ? empresas.length : empresas.length +1,
            itemBuilder : (context,index) {
               if(index == empresas.length && !end)
                 return _CardEmpresaLoading();
               return CardEmpresa(
                       empresa     : empresas[index],
                       url         : url
               );
            }
    );
  }
}

class _CardEmpresaLoading extends StatelessWidget {
  const _CardEmpresaLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
           child: Padding(
                  padding : const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child   : ListTile(
                            leading : ShimmerLoading(
                                      child: CircleAvatar(backgroundColor: Colors.grey,radius: 30,)),
                            title   : ShimmerLoading(
                                      child: Container(
                                             height : 12,
                                             width  : double.infinity,
                                             color  : Colors.grey,
                                      )),
                  ),
           ),
    );
  }
}

class  _SearchBar extends StatelessWidget {
  final String titulo,categoria;
  const  _SearchBar(
         {Key? key,
          required this.titulo,
          required this.categoria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
         onTap: () => NavigationService().navigateToRoute(
           MaterialPageRoute(builder: (context) => SearchEmpresasByCategoriaPage(
                                                   categoria: categoria,

           ))
         )
  );
  }
}