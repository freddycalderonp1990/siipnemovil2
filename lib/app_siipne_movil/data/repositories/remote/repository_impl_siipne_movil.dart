part of '../data_repositories_siipne_movil.dart';

class SiipneMovilRepositoryImpl extends SiipneMovilRepository {
  final SiipneMovilRemoteDataSource siipneMovilRemoteDataSource;

  SiipneMovilRepositoryImpl({required this.siipneMovilRemoteDataSource});

  @override
  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  }) async {
    return await this.siipneMovilRemoteDataSource.getPermisosModulos(
      request: request,
    );
  }

  @override
  Future<List<DataTipoOperativo>> getTipoOperativos({required GetTipoOperativosRequest request}) async {
    return await this.siipneMovilRemoteDataSource.getTipoOperativos(
      request: request,
    );
  }
}
