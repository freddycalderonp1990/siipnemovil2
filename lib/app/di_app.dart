
import 'package:app_mi_upc/app_mi_upc.dart';
import 'package:get/get.dart';
import 'package:siipnemovil_v2/app_siipne_movil/di.dart';


import '../feactures/di_feactures.dart';

class DependencyInjectionApp extends Bindings{

  static ini(){
    DependencyInjectionFeactures.init();
    DependencyInjectionMiUpc.ini();
    DependencyInjectionSiipneMovil.ini();

  }

  @override
  void dependencies() {
    print('DependencyInjection');
    ini();

  }


}