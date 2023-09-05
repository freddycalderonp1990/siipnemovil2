part of 'elecciones_request.dart';
class FinalizarRecintoElectoralRequest {
  final int idGenUsuario;
  final int idDgoCreaOpReci;
  final String ip;
  final int idDgoPerAsigOpe;
  final int idDgoTipoEje;

  FinalizarRecintoElectoralRequest(
      {required this.idGenUsuario,
      required this.idDgoCreaOpReci,
      required this.ip,
      required this.idDgoPerAsigOpe,
      required this.idDgoTipoEje});
}
