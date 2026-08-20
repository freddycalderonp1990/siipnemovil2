part of 'request_siipne_movil.dart';

class AntecedentesRequest {
  final String documento;

  const AntecedentesRequest({
    required this.documento,
  });

  Map<String, dynamic> toJson() {
    return {
      "documento": documento.trim(),
    };
  }
}