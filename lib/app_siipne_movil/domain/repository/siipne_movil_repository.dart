part of 'repository_siipne_movil.dart';

abstract class SiipneMovilRepository {
  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  });

  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  });
}
