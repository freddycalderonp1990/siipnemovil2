class OperativoCreateRequest {
  final String latitude;
  final String longitude;
  final int idGenPersona;
  final int idGenTipoTipificacion;
  final int idSubTipoOperativo;
  final int idGenUsuario;

  OperativoCreateRequest(
      {required this.latitude,
      required this.longitude,
      required this.idGenPersona,
      required this.idGenTipoTipificacion,
      required this.idSubTipoOperativo,
      required this.idGenUsuario});
}
