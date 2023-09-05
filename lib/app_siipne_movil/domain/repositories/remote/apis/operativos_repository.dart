part of '../../domain_repositories.dart';

abstract class OperativosRepository {
  //Se define que cosas quiero hacer
  //se definen los contartos

  Future<List<TipoOperativo>> getTipoOperativos(int idTipoOperativo);

  Future<List<OperativoPendiente>> getOperativosPendientes(
      {required int idGenUsuario,
      required int idGenPersona});

  Future<String> crearOperativo(OperativoCreateRequest operativoCreateRequest);

  Future<PersonaModel> consultarPersona(
      {required int idOperativo,
      required String cedula,
      required int idGenUsuario,
        required String ip,
        required String latitud,
        required String longitud,
         String descOcupante='',
         String? detalle,
      int idHdrEventoResum = 0});

  Future<DataVehiculo> consultarVehiculo(
      {required int idOperativo,
      required String placa,
        required String ip,
        required String latitud,
        required String longitud,
      required int idGenUsuario});

  Future<bool> finalizarOperativo(
      {required String user,
      required String pass,
      required int idGenPersona,
      required int idHdrEvento});


  Future<bool> updateResumenConsultas(
      {required int idHdrEventoResum,
        required int idHdrTipoResum,
        });

  Future<List<DataCatalogoTipoConsulta>> consultarCatalogoTipoConsulta(
      {required String filtro, });

  Future<ResumenConsultaModel> getResumenConsulta(
      {required int idHdrEvento_idOperativo, });
}
