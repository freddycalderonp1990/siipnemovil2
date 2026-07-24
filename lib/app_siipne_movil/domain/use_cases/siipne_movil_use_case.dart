

import '../../data/models/models_siipne_movil.dart';
import '../repository/repository_siipne_movil.dart';
import '../request/request_siipne_movil.dart';

class ModulosUseCase {
  final SiipneMovilRepository repository;

  ModulosUseCase({required this.repository});

  Future<List<DataModulo>> call({required GetPermisosModulosRequest request}) {
    return repository.getPermisosModulos(request: request);
  }
}
