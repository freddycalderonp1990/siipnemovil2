import '../../data/models/models_siipne_movil.dart';
import '../repository/repository_siipne_movil.dart';
import '../request/request_siipne_movil.dart';

class SiipneMovilUseCase {
  final SiipneMovilRepository repository;

  SiipneMovilUseCase({required this.repository});

  Future<List<DataModulo>> getModulos({
    required GetPermisosModulosRequest request,
  }) {
    return repository.getPermisosModulos(request: request);
  }

  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  }) {
    return repository.getTipoOperativos(request: request);
  }

  Future<DataCreateOp> createOperativo({
    required CreateOperativoRequest request,
  }) {
    return repository.crearOperativo(request: request);
  }
}
