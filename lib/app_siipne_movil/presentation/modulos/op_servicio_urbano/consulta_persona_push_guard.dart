import 'dart:async';

enum _EstadoConsultaPersona { repetida, relacionadaVehiculo }

/// Espera la respuesta de la consulta antes de mostrar su alerta de persona.
class ConsultaPersonaPushGuard {
  final Map<String, ConsultaPersonaPushPendiente> _pendientes = {};
  final Map<String, _EstadoConsultaPersona> _documentos = {};
  final Map<String, _EstadoConsultaPersona> _registros = {};

  ConsultaPersonaPushPendiente iniciar({
    required int idOperativo,
    required String documento,
    bool relacionadaVehiculo = false,
  }) {
    final consulta = ConsultaPersonaPushPendiente._(
      idOperativo,
      documento.trim().toUpperCase(),
      relacionadaVehiculo,
    );
    _pendientes[consulta._clave] = consulta;
    return consulta;
  }

  void finalizar(
    ConsultaPersonaPushPendiente consulta, {
    bool? consultaRepetida,
    int idHdrEventoResum = 0,
  }) {
    if (consulta._finalizada.isCompleted) return;
    consulta._repetida =
        consultaRepetida == true && !consulta._relacionadaVehiculo;
    consulta._registro = idHdrEventoResum;
    final registro = '${consulta._operativo}:$idHdrEventoResum';
    if (consultaRepetida != null) {
      final estado = consulta._relacionadaVehiculo
          ? _EstadoConsultaPersona.relacionadaVehiculo
          : consulta._repetida
          ? _EstadoConsultaPersona.repetida
          : null;
      if (estado != null) {
        _documentos[consulta._clave] = estado;
        if (idHdrEventoResum > 0) _registros[registro] = estado;
      } else {
        _documentos.remove(consulta._clave);
        _registros.remove(registro);
      }
    }
    if (identical(_pendientes[consulta._clave], consulta)) {
      _pendientes.remove(consulta._clave);
    }
    consulta._finalizada.complete();
  }

  Future<bool> permitirAlerta(Map<String, dynamic> data) async {
    if (data['tipo']?.toString().trim().toUpperCase() != 'BOLETA') {
      return true;
    }
    final relacion = data['tipoRelacion']?.toString().trim().toUpperCase();
    if (relacion == 'CONDUCTOR' || relacion == 'OCUPANTE') return true;

    final operativo = int.tryParse('${data['idHdrEvento']}') ?? 0;
    final registro = int.tryParse('${data['idHdrEventoResum']}') ?? 0;
    final documento = (data['cedula'] ?? data['documento'] ?? '')
        .toString()
        .trim()
        .toUpperCase();
    final clave = '$operativo:$documento';
    final pendientes = _pendientes.values
        .where(
          (consulta) =>
              consulta._operativo == operativo &&
              (documento.isEmpty || consulta._documento == documento),
        )
        .toList();
    for (final consulta in pendientes) {
      await consulta._finalizada.future;
      if (documento.isNotEmpty &&
          (registro <= 0 ||
              consulta._registro <= 0 ||
              consulta._registro == registro)) {
        if (consulta._relacionadaVehiculo) return true;
        if (consulta._repetida) return false;
      }
    }
    final estado = registro > 0
        ? _registros['$operativo:$registro']
        : _documentos[clave];
    if (estado == _EstadoConsultaPersona.relacionadaVehiculo) return true;
    if (estado == _EstadoConsultaPersona.repetida) return false;

    final repetida = data['consultaRepetida']?.toString().trim().toLowerCase();
    return repetida != 'true' && repetida != '1';
  }

  void limpiar() {
    for (final consulta in _pendientes.values) {
      if (!consulta._finalizada.isCompleted) consulta._finalizada.complete();
    }
    _pendientes.clear();
    _documentos.clear();
    _registros.clear();
  }
}

class ConsultaPersonaPushPendiente {
  ConsultaPersonaPushPendiente._(
    this._operativo,
    this._documento,
    this._relacionadaVehiculo,
  );

  final int _operativo;
  final String _documento;
  final bool _relacionadaVehiculo;
  final Completer<void> _finalizada = Completer<void>();
  bool _repetida = false;
  int _registro = 0;
  String get _clave => '$_operativo:$_documento';
}
