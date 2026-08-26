part of '../models_siipne_movil.dart';

Map<String, dynamic> _migracionDecodeMap(String source) {
  final String contenido = source.trim();
  if (contenido.isEmpty || contenido.toLowerCase() == 'null') {
    return <String, dynamic>{};
  }
  return _migracionMap(json.decode(contenido));
}

String _migracionString(dynamic value) {
  if (value == null) return '';
  final String result = value.toString().trim();
  return result.toLowerCase() == 'null' ? '' : result;
}

String _migracionBase64(dynamic value) {
  String contenido = _migracionString(value);
  if (contenido.isEmpty) return '';

  // También admite respuestas con formato data:image/...;base64,XXXX.
  final int separador = contenido.indexOf(',');
  if (contenido.startsWith('data:') && separador >= 0) {
    contenido = contenido.substring(separador + 1);
  }

  // Elimina saltos de línea o espacios agregados durante el transporte.
  return contenido.replaceAll(RegExp(r'\s+'), '');
}

int _migracionInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(_migracionString(value)) ?? 0;
}

Map<String, dynamic> _migracionMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<dynamic> _migracionList(dynamic value) {
  if (value is List) return value;
  return <dynamic>[];
}

/// Convierte una lista o un único objeto en una colección homogénea.
///
/// Algunos endpoints de migración devuelven un objeto cuando existe un solo
/// registro y una lista cuando existen varios.
List<dynamic> _migracionItems(dynamic value) {
  if (value is List) return value;
  if (value is Map) return <dynamic>[value];
  return <dynamic>[];
}

/// Obtiene el objeto de datos aunque el backend lo envíe dentro de una lista.
Map<String, dynamic> _migracionFirstMap(dynamic value) {
  if (value is Map) return _migracionMap(value);
  if (value is List && value.isNotEmpty) return _migracionMap(value.first);
  return <String, dynamic>{};
}
