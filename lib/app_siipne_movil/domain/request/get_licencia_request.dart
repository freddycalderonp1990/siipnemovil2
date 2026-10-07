part of 'request_siipne_movil.dart';

class GetLicenciaRequest {
  final String documento;

  const GetLicenciaRequest({required this.documento});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'documento': documento.trim(),
  };
}
