import 'package:appyocomproacacias_refactoring/src/componentes/categorias/models/response.model.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/home/models/usuario.enum.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/cubit/inicio.cubit.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/data/inicio.repositorio.dart';
import 'package:appyocomproacacias_refactoring/src/componentes/inicio/state/inicio.state.dart';
import 'package:appyocomproacacias_refactoring/src/recursos/shared.service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockInicioRepocitorio extends Mock implements InicioRepositorio {}

class MockPreferencias extends Mock implements PreferenciasUsuario {}

void main() {

   late MockInicioRepocitorio repocitorio;
   late MockPreferencias preferencias;
   late InicioCubit inicioCubit;

   setUp(() {
      repocitorio = MockInicioRepocitorio();
      preferencias = MockPreferencias();
      inicioCubit =
          InicioCubit(repocitorio: repocitorio, prefs: preferencias);
    });
  group('InicioCubit', () {
   

    blocTest<InicioCubit, InicioState>(
      'emits [MyState] when MyEvent is added.',
      setUp: (){
       when(() => repocitorio.getTop10Empresas()).thenReturn(() => Future.value(ResponseCategorias(categorias: [])));
      },
      build: () => inicioCubit,
      act: (bloc) => inicioCubit.getDataInitial(TipoUsuario.LODGET),
      expect: () => const <InicioState>[],
    );
  });
}
