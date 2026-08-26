part of '../bindings.dart';

class OpMigracionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpMigracionController>(() => OpMigracionController());
  }
}
