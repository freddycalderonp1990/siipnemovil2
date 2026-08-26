part of '../operativo_polco_local_widgets.dart';

class DesingDatosVehiculoWg extends StatelessWidget {
  final DataVehiculo data;
  final Color colorTexto;
  final Color colorTitulos;
  final bool onlyDataCar;
  final VoidCallback? onPressedOcupantes;
  final VoidCallback? onPressedNewConsulta;

  const DesingDatosVehiculoWg({
    Key? key,
    required this.data,
    this.colorTexto = Colors.blueAccent,
    this.colorTitulos = Colors.blueAccent,
    this.onlyDataCar = false,
    this.onPressedOcupantes,
    this.onPressedNewConsulta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool robado = data.restriccionPj.data.robado;

    return Column(
      children: [
        _resumenPrincipal(robado),
        const SizedBox(height: 7),
        _datosVehiculo(),
        const SizedBox(height: 7),
        _datosPropietario(),
        const SizedBox(height: 7),
        DesingRestriccionVehiculoWg(
          data: data.restriccionPj,
          colorTexto: robado
              ? ColorsLocal.colorTextoOrdenCaptura
              : ColorsLocal.colorTextoNormal,
          colorTitulos: robado
              ? ColorsLocal.colorTitulosOrdenCaptura
              : ColorsLocal.colorTitulosNormal,
        ),
        if (!onlyDataCar) ...[const SizedBox(height: 8), _acciones()],
      ],
    );
  }

  // ============================================================
  // RESUMEN PRINCIPAL
  // ============================================================

  Widget _resumenPrincipal(bool robado) {
    final DatosVehiculoSiipneData v = data.datosVehiculo.data;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: robado
              ? const [Color(0xFFB42318), Color(0xFF78170F)]
              : const [Color(0xFF195BA6), Color(0xFF0A3D7E)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: (robado ? const Color(0xFFB42318) : const Color(0xFF195BA6))
                .withOpacity(.15),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _valor(v.placa),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .7,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            robado
                                ? Icons.warning_amber_rounded
                                : Icons.verified_rounded,
                            color: Colors.white,
                            size: 11,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            robado ? "ALERTA" : "SIN NOVEDAD",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 5.8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  "${v.marca} · ${v.modelo}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.88),
                    fontSize: 7.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${v.color} · ${v.anoFabricacion > 0 ? v.anoFabricacion : ''} · ${v.descServicio}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.67),
                    fontSize: 6.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMACIÓN VEHICULAR
  // 3 COLUMNAS × 4 FILAS
  // MISMO ESTILO COMPACTO DEL PROPIETARIO
  // ============================================================

  Widget _datosVehiculo() {
    final DatosVehiculoSiipneData v = data.datosVehiculo.data;

    return _cardSeccion(
      icono: Icons.directions_car_outlined,
      titulo: "INFORMACIÓN VEHICULAR",
      subtitulo: "Datos registrados en SIIPNE",
      child: Column(
        children: [
          _fila2(
            _miniDatoCompacto(
              icono: Icons.pin_outlined,
              titulo: "PLACA",
              valor: v.placa,
            ),
            _miniDatoCompacto(
              icono: Icons.fact_check_outlined,
              titulo: "MODELO",
              valor: v.modelo,
            ),
          ),
          const SizedBox(height: 4),
          _fila2(
            _miniDatoCompacto(
              icono: Icons.branding_watermark_outlined,
              titulo: "MARCA",
              valor: v.marca,
            ),
            _miniDatoCompacto(
              icono: Icons.speed_rounded,
              titulo: "CILINDRAJE",
              valor: v.cilindraje,
            ),
          ),
          const SizedBox(height: 4),
          _fila2(
            _miniDatoCompacto(
              icono: Icons.settings_outlined,
              titulo: "MOTOR",
              valor: v.motor,
            ),
            _miniDatoCompacto(
              icono: Icons.car_repair_outlined,
              titulo: "CHASIS",
              valor: v.chasis,
            ),
          ),
          const SizedBox(height: 4),
          _fila2(
            _miniDatoCompacto(
              icono: Icons.calendar_month_outlined,
              titulo: "AÑO",
              valor: v.anoFabricacion > 0 ? v.anoFabricacion.toString() : "",
            ),
            _miniDatoCompacto(
              icono: Icons.palette_outlined,
              titulo: "COLOR",
              valor: v.color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROPIETARIO
  // FOTO GRANDE IZQUIERDA + DATOS DERECHA
  // 2 COLUMNAS × 3 FILAS
  // ============================================================

  Widget _datosPropietario() {
    final DatospropietarioData p = data.datospropietario.data;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD6E1EB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D4C9C).withOpacity(.045),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.person_pin_circle_outlined,
                color: Color(0xFF195BA6),
                size: 17,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PROPIETARIO / ANT",
                      style: TextStyle(
                        color: Color(0xFF29445D),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Identificación y datos del propietario del vehículo",
                      style: TextStyle(
                        color: Color(0xFF8493A1),
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fotoPropietarioGrande(p.foto64),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  children: [
                    _fila2(
                      _miniDatoPropietario(
                        icono: Icons.person_outline_rounded,
                        titulo: "PROPIETARIO",
                        valor: p.propietario,
                      ),
                      _miniDatoPropietario(
                        icono: Icons.badge_outlined,
                        titulo: "DOCUMENTO",
                        valor: p.docPropietario,
                      ),
                    ),
                    if (_tieneFechaDefuncionPropietario(p.fechaDefuncion)) ...[
                      const SizedBox(height: 6),

                      _fechaDefuncionPropietario(p.fechaDefuncion),

                      const SizedBox(height: 4),
                    ] else
                      const SizedBox(height: 6),

                    _fila2(
                      _miniDatoPropietario(
                        icono: Icons.calendar_today_outlined,
                        titulo: "CADUCIDAD",
                        valor: p.fechaCaducidad,
                      ),
                      _miniDatoPropietario(
                        icono: Icons.phone_outlined,
                        titulo: "TELÉFONO",
                        valor: p.telefono,
                      ),
                    ),

                    const SizedBox(height: 4),

                    _miniDatoPropietario(
                      icono: Icons.alternate_email_rounded,
                      titulo: "CORREO",
                      valor: p.correo,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _tieneFechaDefuncionPropietario(String? fecha) {
    if (fecha == null) {
      return false;
    }

    final String valor = fecha.trim();

    if (valor.isEmpty) {
      return false;
    }

    final String normalizado = valor.toUpperCase();

    const List<String> noValidos = [
      'N/D',
      'N.D.',
      'ND',
      'NULL',
      'NO REGISTRA',
      'NO REGISTRADO',
      'NO DISPONIBLE',
      'SIN DATOS',
      'SIN INFORMACION',
      'SIN INFORMACIÓN',
      '0000-00-00',
      '0000-00-00 00:00:00',
    ];

    return !noValidos.contains(normalizado);
  }

  Widget _fechaDefuncionPropietario(String fecha) {
    final String valor = fecha.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5AAA5)),
      ),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: const Color(0xFFFFDCD8),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFB42318),
              size: 17,
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FECHA DE DEFUNCIÓN",
                  style: TextStyle(
                    color: Color(0xFF9C5B56),
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF9C241B),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.error_rounded, color: Color(0xFFB42318), size: 17),
        ],
      ),
    );
  }
  // ============================================================
  // CARD VEHÍCULO COMPACTO
  // ============================================================

  Widget _miniDatoCompacto({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40, maxHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE0E7EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icono, size: 16, color: const Color(0xFF195BA6)),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  _valor(valor),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF29445D),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CARD PROPIETARIO COMPACTO
  // ============================================================

  Widget _miniDatoPropietario({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE0E7EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icono, size: 14, color: const Color(0xFF195BA6)),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  _valor(valor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF29445D),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILAS
  // ============================================================

  Widget _fila3(Widget primero, Widget segundo, Widget tercero) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: primero),
        const SizedBox(width: 4),
        Expanded(child: segundo),
        const SizedBox(width: 4),
        Expanded(child: tercero),
      ],
    );
  }

  Widget _fila2(Widget primero, Widget segundo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: primero),
        const SizedBox(width: 5),
        Expanded(child: segundo),
      ],
    );
  }

  // ============================================================
  // FOTO PROPIETARIO BASE64
  // ============================================================

  Widget _fotoPropietarioGrande(String fotoBase64) {
    final String foto = fotoBase64.trim();

    Widget placeholder() {
      return Container(
        color: const Color(0xFFEAF2FA),
        child: const Center(
          child: Icon(Icons.person_rounded, color: Color(0xFF7796B3), size: 40),
        ),
      );
    }

    Widget contenedor(Widget child) {
      return Container(
        width: 86,
        height: 125,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FA),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFABC7DF)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF195BA6).withOpacity(.08),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );
    }

    if (foto.isEmpty) {
      return contenedor(placeholder());
    }

    try {
      String limpio = foto;

      if (limpio.contains(',')) {
        limpio = limpio.split(',').last;
      }

      limpio = limpio
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .replaceAll(' ', '');

      final bytes = base64Decode(limpio);

      return contenedor(
        Image.memory(
          bytes,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) {
            return placeholder();
          },
        ),
      );
    } catch (_) {
      return contenedor(placeholder());
    }
  }

  // ============================================================
  // CARD BASE
  // ============================================================

  Widget _cardSeccion({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD6E1EB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D4C9C).withOpacity(.045),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FC),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icono, color: const Color(0xFF195BA6), size: 17),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: Color(0xFF29445D),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        color: Color(0xFF8493A1),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // ACCIONES
  // ============================================================

  Widget _acciones() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPressedNewConsulta,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "NUEVA CONSULTA",
                maxLines: 1,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF195BA6),
              minimumSize: const Size(0, 43),
              padding: const EdgeInsets.symmetric(horizontal: 7),
              side: const BorderSide(color: Color(0xFFAFC9E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPressedOcupantes,
            icon: const Icon(Icons.groups_2_rounded, size: 17),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "CONDUCTOR / OCUPANTES",
                maxLines: 1,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 43),
              padding: const EdgeInsets.symmetric(horizontal: 7),
              backgroundColor: const Color(0xFF195BA6),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // UTILIDAD
  // ============================================================

  String _valor(String valor) {
    final String dato = valor.trim();

    return dato.isEmpty ? "NO DISPONIBLE" : dato;
  }
}
