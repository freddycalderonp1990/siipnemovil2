part of 'repository_siipne_movil.dart';

abstract class SiipneMovilRepository {
  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  });

  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  });

  Future<DataCreateOp> crearOperativo({
    required CreateOperativoRequest request,
  });

  Future<OpePersonaModelData> consultarPersona({
    required ConsultarPersonaRequest request,
  });



}
