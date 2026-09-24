part of 'request_siipne_movil.dart';

class ConductorVehiculoRequest {
  final int idHdrEvento;
  final String placa;

  const ConductorVehiculoRequest({required this.idHdrEvento, required this.placa});

  Map<String, dynamic> toJson() {
    return {"idHdrEvento": idHdrEvento, "placa": placa};
  }
}
