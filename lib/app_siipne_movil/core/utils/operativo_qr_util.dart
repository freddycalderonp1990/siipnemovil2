import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';

class OperativoQrUtil {
  OperativoQrUtil._();

  static const String _claveBase = 'SIIPNE-MOVIL-2-OPERATIVOS-QR-2026';

  static final AesGcm _algoritmo = AesGcm.with256bits();

  static final Sha256 _sha256 = Sha256();

  // ============================================================
  // OBTENER CLAVE AES-256
  // ============================================================

  static Future<SecretKey> _obtenerClave() async {
    final Hash hash = await _sha256.hash(utf8.encode(_claveBase));

    /*
     * SHA-256 devuelve exactamente 32 bytes.
     */
    return SecretKey(hash.bytes);
  }

  // ============================================================
  // ENCRIPTAR ID OPERATIVO
  // ============================================================

  static Future<String> encriptarIdOperativo(int idHdrEvento) async {
    if (idHdrEvento <= 0) {
      throw Exception('Identificador de operativo inválido.');
    }

    try {
      debugPrint('==========================================');
      debugPrint('GENERANDO QR OPERATIVO');
      debugPrint('ID HDR EVENTO: $idHdrEvento');

      final SecretKey secretKey = await _obtenerClave();

      final List<int> nonce = _algoritmo.newNonce();

      final Map<String, dynamic> payload = <String, dynamic>{
        'tipo': 'SIIPNE_OPERATIVO',
        'id': idHdrEvento,
        'ts': DateTime.now().millisecondsSinceEpoch,
      };

      final String texto = jsonEncode(payload);

      debugPrint('PAYLOAD: $texto');

      final SecretBox secretBox = await _algoritmo.encrypt(
        utf8.encode(texto),
        secretKey: secretKey,
        nonce: nonce,
      );

      /*
       * SecretBox contiene:
       *
       * nonce
       * cipherText
       * mac
       *
       * AES-GCM utiliza el MAC para validar que
       * el contenido no haya sido alterado.
       */
      final Map<String, dynamic> contenidoQr = <String, dynamic>{
        'v': 1,
        'n': base64UrlEncode(secretBox.nonce),
        'c': base64UrlEncode(secretBox.cipherText),
        'm': base64UrlEncode(secretBox.mac.bytes),
      };

      final String resultado = base64UrlEncode(
        utf8.encode(jsonEncode(contenidoQr)),
      );

      debugPrint('QR GENERADO CORRECTAMENTE');
      debugPrint('LONGITUD: ${resultado.length}');
      debugPrint('==========================================');

      return resultado;
    } catch (e, stackTrace) {
      debugPrint('==========================================');
      debugPrint('ERROR GENERANDO QR OPERATIVO');
      debugPrint('ERROR: $e');
      debugPrint('$stackTrace');
      debugPrint('==========================================');

      rethrow;
    }
  }

  // ============================================================
  // DESENCRIPTAR ID OPERATIVO
  // ============================================================

  static Future<int> desencriptarIdOperativo(String codigo) async {
    final String valor = codigo.trim();

    if (valor.isEmpty) {
      throw Exception('Código QR vacío.');
    }

    try {
      debugPrint('==========================================');
      debugPrint('LEYENDO QR OPERATIVO');

      // ==========================================================
      // DECODIFICAR CONTENEDOR
      // ==========================================================

      final List<int> bytesQr = base64Url.decode(base64Url.normalize(valor));

      final String jsonQr = utf8.decode(bytesQr);

      final dynamic qr = jsonDecode(jsonQr);

      if (qr is! Map) {
        throw Exception('Código QR inválido.');
      }

      final int version = int.tryParse(qr['v']?.toString() ?? '') ?? 0;

      if (version != 1) {
        throw Exception('Versión de código QR no compatible.');
      }

      final String nonceString = qr['n']?.toString() ?? '';

      final String cipherString = qr['c']?.toString() ?? '';

      final String macString = qr['m']?.toString() ?? '';

      if (nonceString.isEmpty || cipherString.isEmpty || macString.isEmpty) {
        throw Exception('Contenido QR incompleto.');
      }

      // ==========================================================
      // RECONSTRUIR SECRET BOX
      // ==========================================================

      final List<int> nonce = base64Url.decode(
        base64Url.normalize(nonceString),
      );

      final List<int> cipherText = base64Url.decode(
        base64Url.normalize(cipherString),
      );

      final List<int> macBytes = base64Url.decode(
        base64Url.normalize(macString),
      );

      final SecretBox secretBox = SecretBox(
        cipherText,
        nonce: nonce,
        mac: Mac(macBytes),
      );

      final SecretKey secretKey = await _obtenerClave();

      // ==========================================================
      // DESENCRIPTAR
      // ==========================================================

      final List<int> clearText = await _algoritmo.decrypt(
        secretBox,
        secretKey: secretKey,
      );

      final String texto = utf8.decode(clearText);

      debugPrint('PAYLOAD DESENCRIPTADO: $texto');

      final dynamic payload = jsonDecode(texto);

      if (payload is! Map) {
        throw Exception('Contenido QR inválido.');
      }

      final String tipo =
          payload['tipo']?.toString().trim().toUpperCase() ?? '';

      if (tipo != 'SIIPNE_OPERATIVO') {
        throw Exception('Este QR no corresponde a un operativo SIIPNE.');
      }

      final int idHdrEvento =
          int.tryParse(payload['id']?.toString() ?? '') ?? 0;

      if (idHdrEvento <= 0) {
        throw Exception('El QR no contiene un operativo válido.');
      }

      debugPrint('ID HDR EVENTO: $idHdrEvento');
      debugPrint('QR DESENCRIPTADO CORRECTAMENTE');
      debugPrint('==========================================');

      return idHdrEvento;
    } catch (e, stackTrace) {
      debugPrint('==========================================');
      debugPrint('ERROR LEYENDO QR OPERATIVO');
      debugPrint('ERROR: $e');
      debugPrint('$stackTrace');
      debugPrint('==========================================');

      rethrow;
    }
  }
}
