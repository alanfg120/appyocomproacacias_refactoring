import 'package:appyocomproacacias_refactoring/src/componentes/empresas/cubit/perfil_empresa_cubit.dart';
import 'package:flutter/material.dart';



class CalificarWidget extends StatefulWidget {
  final PerfilEmpresaCubit cubit;
  const CalificarWidget({Key? key,required this.cubit}) : super(key: key);

  @override
  _CalificarWidgetState createState() => _CalificarWidgetState();
}

class _CalificarWidgetState extends State<CalificarWidget> {
  
  List<bool> startValue = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Container(
           
           child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (start)=>
                   IconButton(
                   icon: startValue[start] 
                         ?
                         Icon(Icons.star,color:Colors.yellow)
                         :
                         Icon(Icons.star_border),
                   onPressed: (){
                     setState(() {
                       for (var i = 0; i <= 4; i++) {
                            if(i <= start)
                            startValue[i] = true; 
                            else 
                            startValue[i] = false; 
                       }
                     });
                       final count = startValue.where((e) => e == true).length;
                       widget.cubit.getCalificacionEmpresa(count);
                   },
                   iconSize: 33,
                   )
                  )
           ),
    );
  }
}