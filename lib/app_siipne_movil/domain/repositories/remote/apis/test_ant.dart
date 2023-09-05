part of '../../domain_repositories.dart';

abstract class TestAntRepository {
  //Se define que cosas quiero hacer
  //se definen los contartos

  Future<String> getDataString(String placa);
  Future<TestAntModel> getData(String placa);
}
