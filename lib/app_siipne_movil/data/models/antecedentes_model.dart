part of 'models_siipne_movil.dart';

AntecedentesModel antecedentesModelFromJson(String str) =>
    AntecedentesModel.fromJson(json.decode(str));

String antecedentesModelToJson(AntecedentesModel data) =>
    json.encode(data.toJson());

class AntecedentesModel {
  final int statusCode;
  final String message;
  final DataAntecedentes dataAntecedentes;

  const AntecedentesModel({
    required this.statusCode,
    required this.message,
    required this.dataAntecedentes,
  });

  factory AntecedentesModel.fromJson(Map<String, dynamic> json) {
    final dynamic data = json["data"];

    return AntecedentesModel(
      statusCode: ParseModel.parseToInt(json["status_code"]),
      message: ParseModel.parseToString(json["message"]),
      dataAntecedentes: data is Map<String, dynamic>
          ? DataAntecedentes.fromJson(data)
          : DataAntecedentes.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": dataAntecedentes.toJson(),
  };
}

class DataAntecedentes {
  final List<String> antecedentes;

  const DataAntecedentes({required this.antecedentes});

  factory DataAntecedentes.empty() {
    return const DataAntecedentes(antecedentes: <String>[]);
  }

  factory DataAntecedentes.fromJson(Map<String, dynamic> json) {
    final dynamic raw = json["antecedentes"];

    if (raw is! List) {
      return DataAntecedentes.empty();
    }

    final List<String> datos = raw
        .where((dynamic item) => item != null)
        .map((dynamic item) => item.toString().trim())
        .where((String item) => item.isNotEmpty)
        .toList();

    return DataAntecedentes(antecedentes: datos);
  }

  bool get tieneAntecedentes => antecedentes.isNotEmpty;

  Map<String, dynamic> toJson() => {"antecedentes": antecedentes};
}
