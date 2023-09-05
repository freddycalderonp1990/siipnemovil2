
import 'package:get/get.dart';
import '../../../../../app_elecciones/dependency_injection_elecciones.dart';

import '../app_siipne_movil/dependency_injection_siipne.dart';


class DependencyInjectionApp extends Bindings{

  static ini(){
    DependencyInjectionSiipne.ini();
    DependencyInjectionElecciones.ini();

  }

  @override
  void dependencies() {
    print('DependencyInjection');
    ini();




  }


}