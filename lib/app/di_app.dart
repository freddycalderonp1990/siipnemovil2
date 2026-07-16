
import 'package:app_mi_upc/app_mi_upc.dart';
import 'package:get/get.dart';


import '../feactures/di_feactures.dart';

class DependencyInjectionApp extends Bindings{

  static ini(){
    DependencyInjectionFeactures.init();
    DependencyInjectionMiUpc.ini();

  }

  @override
  void dependencies() {
    print('DependencyInjection');
    ini();


  }


}