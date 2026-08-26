part of 'models_siipne_movil.dart';

ResultadoOperativoModel resultadoOperativoModelFromJson(String str) =>
    ResultadoOperativoModel.fromJson(json.decode(str));

String resultadoOperativoModelToJson(ResultadoOperativoModel data) =>
    json.encode(data.toJson());

class ResultadoOperativoModel {
  final int statusCode;
  final String message;
  final ResultadosOperativo resultadosOperativo;

  ResultadoOperativoModel({
    required this.statusCode,
    required this.message,
    required this.resultadosOperativo,
  });

  factory ResultadoOperativoModel.fromJson(Map<String, dynamic> json) {
    final dynamic data = json["data"];

    return ResultadoOperativoModel(
      statusCode: ParseModel.parseToInt(json["status_code"]),
      message: ParseModel.parseToString(json["message"]),
      resultadosOperativo: data is Map
          ? ResultadosOperativo.fromJson(Map<String, dynamic>.from(data))
          : ResultadosOperativo.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": resultadosOperativo.toJson(),
  };
}

// ============================================================
// RESULTADOS DEL OPERATIVO
// ============================================================

class ResultadosOperativo {
  final int idHdrEvento;

  final String codigoEvento;
  final String descripcionOperativo;

  final String fechaEvento;
  final String fechaRegistro;
  final String fechaFinalizacion;

  final String zona;
  final String subzona;
  final String distrito;
  final String circuito;
  final String subcircuito;

  final String tipoOperativo;

  final int totalConsultas;
  final int totalPersonas;
  final int totalVehiculos;

  final int totalAlertas;
  final int totalAlertasPersona;
  final int totalAlertasVehiculo;

  final int totalVehiculosRobados;

  final int totalConductores;
  final int totalOcupantes;

  // ============================================================
  // VARIABLES / RESULTADOS CONSOLIDADOS
  // ============================================================

  final List<VariableResultadoOperativo> variablesResultado;

  ResultadosOperativo({
    required this.idHdrEvento,
    required this.codigoEvento,
    required this.descripcionOperativo,
    required this.fechaEvento,
    required this.fechaRegistro,
    required this.fechaFinalizacion,
    required this.zona,
    required this.subzona,
    required this.distrito,
    required this.circuito,
    required this.subcircuito,
    required this.tipoOperativo,
    required this.totalConsultas,
    required this.totalPersonas,
    required this.totalVehiculos,
    required this.totalAlertas,
    required this.totalAlertasPersona,
    required this.totalAlertasVehiculo,
    required this.totalVehiculosRobados,
    required this.totalConductores,
    required this.totalOcupantes,
    required this.variablesResultado,
  });

  factory ResultadosOperativo.fromJson(Map<String, dynamic> json) {
    final dynamic variables = json["variablesResultado"];

    return ResultadosOperativo(
      idHdrEvento: ParseModel.parseToInt(json["idHdrEvento"]),

      codigoEvento: ParseModel.parseToString(json["codigoEvento"]),

      descripcionOperativo: ParseModel.parseToString(
        json["descripcionOperativo"],
      ),

      fechaEvento: ParseModel.parseToString(json["fechaEvento"]),

      fechaRegistro: ParseModel.parseToString(json["fechaRegistro"]),

      fechaFinalizacion: ParseModel.parseToString(json["fechaFinalizacion"]),

      zona: ParseModel.parseToString(json["zona"]),

      subzona: ParseModel.parseToString(json["subzona"]),

      distrito: ParseModel.parseToString(json["distrito"]),

      circuito: ParseModel.parseToString(json["circuito"]),

      subcircuito: ParseModel.parseToString(json["subcircuito"]),

      tipoOperativo: ParseModel.parseToString(json["tipoOperativo"]),

      totalConsultas: ParseModel.parseToInt(json["totalConsultas"]),

      totalPersonas: ParseModel.parseToInt(json["totalPersonas"]),

      totalVehiculos: ParseModel.parseToInt(json["totalVehiculos"]),

      totalAlertas: ParseModel.parseToInt(json["totalAlertas"]),

      totalAlertasPersona: ParseModel.parseToInt(json["totalAlertasPersona"]),

      totalAlertasVehiculo: ParseModel.parseToInt(json["totalAlertasVehiculo"]),

      totalVehiculosRobados: ParseModel.parseToInt(
        json["totalVehiculosRobados"],
      ),

      totalConductores: ParseModel.parseToInt(json["totalConductores"]),

      totalOcupantes: ParseModel.parseToInt(json["totalOcupantes"]),

      variablesResultado: variables is List
          ? variables
                .whereType<Map>()
                .map(
                  (dynamic item) => VariableResultadoOperativo.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : <VariableResultadoOperativo>[],
    );
  }

  factory ResultadosOperativo.empty() {
    return ResultadosOperativo(
      idHdrEvento: 0,
      codigoEvento: '',
      descripcionOperativo: '',
      fechaEvento: '',
      fechaRegistro: '',
      fechaFinalizacion: '',
      zona: '',
      subzona: '',
      distrito: '',
      circuito: '',
      subcircuito: '',
      tipoOperativo: '',
      totalConsultas: 0,
      totalPersonas: 0,
      totalVehiculos: 0,
      totalAlertas: 0,
      totalAlertasPersona: 0,
      totalAlertasVehiculo: 0,
      totalVehiculosRobados: 0,
      totalConductores: 0,
      totalOcupantes: 0,
      variablesResultado: <VariableResultadoOperativo>[],
    );
  }

  // ============================================================
  // GETTERS
  // ============================================================

  bool get tieneDatos => idHdrEvento > 0;

  bool get tieneConsultas => totalConsultas > 0;

  bool get tieneAlertas => totalAlertas > 0;

  bool get tieneVariablesResultado => variablesResultado.isNotEmpty;

  int get totalVariablesResultado => variablesResultado.fold<int>(
    0,
    (int total, VariableResultadoOperativo item) => total + item.cantidad,
  );

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() => {
    "idHdrEvento": idHdrEvento,
    "codigoEvento": codigoEvento,
    "descripcionOperativo": descripcionOperativo,
    "fechaEvento": fechaEvento,
    "fechaRegistro": fechaRegistro,
    "fechaFinalizacion": fechaFinalizacion,
    "zona": zona,
    "subzona": subzona,
    "distrito": distrito,
    "circuito": circuito,
    "subcircuito": subcircuito,
    "tipoOperativo": tipoOperativo,
    "totalConsultas": totalConsultas,
    "totalPersonas": totalPersonas,
    "totalVehiculos": totalVehiculos,
    "totalAlertas": totalAlertas,
    "totalAlertasPersona": totalAlertasPersona,
    "totalAlertasVehiculo": totalAlertasVehiculo,
    "totalVehiculosRobados": totalVehiculosRobados,
    "totalConductores": totalConductores,
    "totalOcupantes": totalOcupantes,
    "variablesResultado": variablesResultado
        .map((VariableResultadoOperativo item) => item.toJson())
        .toList(),
  };
}

// ============================================================
// VARIABLE / RESULTADO CONSOLIDADO
// ============================================================

class VariableResultadoOperativo {
  final int cantidad;
  final int idHdrTipoResum;
  final String desHdrTipoResum;

  const VariableResultadoOperativo({
    required this.cantidad,
    required this.idHdrTipoResum,
    required this.desHdrTipoResum,
  });

  factory VariableResultadoOperativo.fromJson(Map<String, dynamic> json) {
    return VariableResultadoOperativo(
      cantidad: ParseModel.parseToInt(json["cantidad"]),
      idHdrTipoResum: ParseModel.parseToInt(json["idHdrTipoResum"]),
      desHdrTipoResum: ParseModel.parseToString(json["desHdrTipoResum"]),
    );
  }

  factory VariableResultadoOperativo.empty() {
    return const VariableResultadoOperativo(
      cantidad: 0,
      idHdrTipoResum: 0,
      desHdrTipoResum: '',
    );
  }

  bool get tieneDatos =>
      idHdrTipoResum > 0 && desHdrTipoResum.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
    "cantidad": cantidad,
    "idHdrTipoResum": idHdrTipoResum,
    "desHdrTipoResum": desHdrTipoResum,
  };
}
