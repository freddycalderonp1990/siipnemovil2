import 'package:flutter/material.dart';

import '../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../core/values/app_siipne_movil_images.dart';
import '../../../../data/models/models_siipne_movil.dart';
import 'btnIconOperativoWidget.dart';
import 'colors_local.dart';
import 'operativo_polco_local_widgets.dart';
import 'package:get/get.dart';

class DesingBusquedaPorCedulaWidget extends StatelessWidget {
  final List<DataConsultaPersona> dataPersona;
  final VoidCallback? onPressedAceptar;
  final VoidCallback? onPressedAntecedentes;
  final Widget? widgetAntesNuevaConsulta;

  const DesingBusquedaPorCedulaWidget({
    super.key,
    required this.dataPersona,
    this.onPressedAceptar,
    this.onPressedAntecedentes,
    this.widgetAntesNuevaConsulta,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPersona.isEmpty) {
      return const SizedBox.shrink();
    }

    return _contenido();
  }

  // ============================================================
  // CONTENIDO
  // ============================================================

  Widget _contenido() {
    final ResponsiveUtil responsive = ResponsiveUtil();

    return ListView.separated(
      /*
       * IMPORTANTE:
       * este widget puede encontrarse dentro de otro ListView.
       */
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),

      padding: EdgeInsets.fromLTRB(
        responsive.anchoP(1),
        responsive.altoP(.4),
        responsive.anchoP(1),
        responsive.altoP(.8),
      ),

      itemCount: dataPersona.length,

      separatorBuilder: (_, __) => const SizedBox(height: 8),

      itemBuilder: (context, i) {
        final DataConsultaPersona data = dataPersona[i];

        return KeyedSubtree(
          key: ValueKey('persona_${data.idHdrEventoResum}_$i'),
          child: _cardResultado(data: data),
        );
      },
    );
  }

  // ============================================================
  // CARD PRINCIPAL
  // ============================================================

  Widget _cardResultado({required DataConsultaPersona data}) {
    final bool tieneOrdenCaptura = data.ordenCaptura.success;

    final Color colorTexto = tieneOrdenCaptura
        ? ColorsLocal.colorTextoOrdenCaptura
        : ColorsLocal.colorTextoNormal;

    final Color colorTitulos = tieneOrdenCaptura
        ? ColorsLocal.colorTitulosOrdenCaptura
        : ColorsLocal.colorTitulosNormal;

    final LocalPersonSuModel persona = setDatosPersona(data);

    final LocalOrdenCapturaSuModel orden = setDatosOrdenCaptura(data);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: tieneOrdenCaptura
              ? const Color(0xFFE48787)
              : const Color(0xFFD8E3EE),
          width: tieneOrdenCaptura ? 1.3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: tieneOrdenCaptura
                ? Colors.red.withOpacity(.07)
                : const Color(0xFF0D4C9C).withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================
            // HEADER PRINCIPAL
            // ==================================================

            _headerResultado(
              tieneOrdenCaptura: tieneOrdenCaptura,
              persona: persona,
            ),

            // ==================================================
            // ACCIÓN ANTECEDENTES
            // ==================================================
            if (onPressedAntecedentes != null) _barraAccionesPersona(),

            // ==================================================
            // CONTENIDO
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ============================================
                  // DATOS PERSONALES
                  // ============================================

                  DesingDatosPersonaWg(
                    colorTitulos: colorTitulos,
                    colorTexto: colorTexto,
                    data: persona,
                    tieneOrdenCaptura: tieneOrdenCaptura,
                  ),

                  if (data.dataSiipne.success &&
                      _tieneFechaDefuncion(
                        data.dataSiipne.datosSiipne.fechaDefuncion,
                      )) ...[
                    const SizedBox(height: 8),

                    _fechaDefuncionPersona(data),
                  ],

                  const SizedBox(height: 8),

                  _cardDatosAnt(data),
                  const SizedBox(height: 8),

                  // ============================================
                  // BOLETAS
                  // ============================================
                  _cardBoletaCaptura(
                    tieneOrdenCaptura: tieneOrdenCaptura,
                    data: data,
                    orden: orden,
                  ),

                  const SizedBox(height: 8),

                  // ============================================
                  // FUENTES CONSULTADAS
                  // ============================================
                  _estadoServicios(data),

                  const SizedBox(height: 8),

                  // ============================================
                  // NUEVA CONSULTA
                  // ============================================
                  if (widgetAntesNuevaConsulta != null) ...<Widget>[
                    widgetAntesNuevaConsulta!,
                    const SizedBox(height: 8),
                  ],
                  _botonAceptar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER RESULTADO
  // ============================================================

  Widget _headerResultado({
    required bool tieneOrdenCaptura,
    required LocalPersonSuModel persona,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: tieneOrdenCaptura
              ? [const Color(0xFFB42318), const Color(0xFF7A1710)]
              : [const Color(0xFF195BA6), const Color(0xFF0A3D7E)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              tieneOrdenCaptura
                  ? Icons.warning_amber_rounded
                  : Icons.person_search_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tieneOrdenCaptura
                      ? "ALERTA EN CONSULTA"
                      : "RESULTADO DE CONSULTA",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .4,
                  ),
                ),

                Text(
                  persona.documento.trim().isEmpty
                      ? "SIN DOCUMENTO"
                      : persona.documento,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.82),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tieneOrdenCaptura
                      ? Icons.error_rounded
                      : Icons.verified_rounded,
                  color: Colors.white,
                  size: 12,
                ),

                const SizedBox(width: 3),

                Text(
                  tieneOrdenCaptura ? "ALERTA" : "CONSULTADO",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
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
  // BARRA ACCIONES PERSONA
  // ============================================================

  Widget _barraAccionesPersona() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 1),
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Color(0xFF8796A5),
                  size: 13,
                ),

                SizedBox(width: 5),

                Flexible(
                  child: Text(
                    "ACCIONES DE CONSULTA",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF8796A5),
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 7),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressedAntecedentes,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFB7D0E7)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fact_check_outlined,
                      color: Color(0xFF195BA6),
                      size: 14,
                    ),

                    SizedBox(width: 5),

                    Text(
                      "ANTECEDENTES",
                      style: TextStyle(
                        color: Color(0xFF195BA6),
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .1,
                      ),
                    ),

                    SizedBox(width: 3),

                    Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF5E87AD),
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CARD BOLETAS / CAPTURA
  // ============================================================

  Widget _cardBoletaCaptura({
    required bool tieneOrdenCaptura,
    required DataConsultaPersona data,
    required LocalOrdenCapturaSuModel orden,
  }) {
    final List<_DatoBoletaItem> datos = <_DatoBoletaItem>[];

    if (tieneOrdenCaptura) {
      datos.addAll([
        _DatoBoletaItem(
          icono: Icons.account_balance_rounded,
          titulo: "AUTORIDAD / JUZGADO",
          valor: orden.juzgado,
        ),

        _DatoBoletaItem(
          icono: Icons.badge_outlined,
          titulo: "DOCUMENTO",
          valor: orden.documento,
        ),

        _DatoBoletaItem(
          icono: Icons.description_outlined,
          titulo: "NÚMERO DE OFICIO",
          valor: orden.oficio,
        ),

        _DatoBoletaItem(
          icono: Icons.public_rounded,
          titulo: "PAÍS",
          valor: data.ordenCaptura.datosCaptura.pais,
        ),
      ]);

      if (data.ordenCaptura.datosCaptura.causapenal.trim().isNotEmpty) {
        datos.add(
          _DatoBoletaItem(
            icono: Icons.balance_rounded,
            titulo: "CAUSA PENAL",
            valor: data.ordenCaptura.datosCaptura.causapenal,
          ),
        );
      }

      if (data.ordenCaptura.datosCaptura.descrtipoinfra.trim().isNotEmpty) {
        datos.add(
          _DatoBoletaItem(
            icono: Icons.report_problem_rounded,
            titulo: "TIPO DE INFRACCIÓN",
            valor: data.ordenCaptura.datosCaptura.descrtipoinfra,
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tieneOrdenCaptura
            ? const Color(0xFFFFF6F5)
            : const Color(0xFFF3FAF6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: tieneOrdenCaptura
              ? const Color(0xFFE69A95)
              : const Color(0xFFB9DCC7),
          width: tieneOrdenCaptura ? 1.4 : 1,
        ),
        boxShadow: tieneOrdenCaptura
            ? [
                BoxShadow(
                  color: const Color(0xFFB42318).withOpacity(.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: tieneOrdenCaptura
                      ? [const Color(0xFFB42318), const Color(0xFF8C1D15)]
                      : [const Color(0xFF238457), const Color(0xFF176A45)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      tieneOrdenCaptura
                          ? Icons.gavel_rounded
                          : Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "BOLETAS / ÓRDENES DE CAPTURA",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.7,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .25,
                          ),
                        ),

                        const SizedBox(height: 1),

                        Text(
                          tieneOrdenCaptura
                              ? "SE ENCONTRÓ INFORMACIÓN VIGENTE"
                              : "NO SE REGISTRAN NOVEDADES",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.80),
                            fontSize: 7.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tieneOrdenCaptura
                              ? Icons.priority_high_rounded
                              : Icons.check_rounded,
                          color: Colors.white,
                          size: 12,
                        ),

                        const SizedBox(width: 3),

                        Text(
                          tieneOrdenCaptura ? "ALERTA" : "SIN NOVEDAD",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // CONTENIDO
            // ==================================================
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                children: [
                  if (tieneOrdenCaptura) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE7E5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFB42318),
                            size: 18,
                          ),

                          SizedBox(width: 7),

                          Expanded(
                            child: Text(
                              "ATENCIÓN: La persona consultada registra una boleta u orden de captura.",
                              style: TextStyle(
                                color: Color(0xFF8E2922),
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        const double espacio = 6;

                        final double ancho =
                            (constraints.maxWidth - espacio) / 2;

                        return Wrap(
                          spacing: espacio,
                          runSpacing: 6,
                          children: datos.map((item) {
                            return SizedBox(
                              width: ancho,
                              child: _datoBoleta(
                                icono: item.icono,
                                titulo: item.titulo,
                                valor: item.valor,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.72),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 31,
                            height: 31,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0xFFE0F3E8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: Color(0xFF198754),
                                size: 18,
                              ),
                            ),
                          ),

                          SizedBox(width: 8),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SIN BOLETAS VIGENTES",
                                  style: TextStyle(
                                    color: Color(0xFF2E6548),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                SizedBox(height: 1),

                                Text(
                                  "No registra boletas u órdenes de captura vigentes.",
                                  style: TextStyle(
                                    color: Color(0xFF5E796B),
                                    fontSize: 8.3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DATO BOLETA
  // ============================================================

  Widget _datoBoleta({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    final String dato = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.80),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9C4C1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8E6),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icono, color: const Color(0xFFB42318), size: 12),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF8B6B69),
                    fontSize: 6.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  dato,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF4C3634),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
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
  // FUENTES CONSULTADAS
  // ============================================================

  Widget _estadoServicios(DataConsultaPersona data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E7EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.cloud_done_outlined,
                size: 14,
                color: Color(0xFF195BA6),
              ),

              SizedBox(width: 5),

              Text(
                "FUENTES CONSULTADAS",
                style: TextStyle(
                  color: Color(0xFF52667A),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              Expanded(
                child: _badgeServicio(
                  titulo: "SIIPNE",
                  activo: data.dataSiipne.success,
                ),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: _badgeServicio(
                  titulo: "DINARDAP",
                  activo: data.dataDinardap.success,
                ),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: _badgeServicio(
                  titulo: "ANT",
                  activo: data.datosAnt.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badgeServicio({required String titulo, required bool activo}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: activo ? const Color(0xFFEAF7F0) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: activo ? const Color(0xFFA8DDBE) : const Color(0xFFDDE2E7),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            activo
                ? Icons.check_circle_rounded
                : Icons.remove_circle_outline_rounded,
            color: activo ? const Color(0xFF198754) : const Color(0xFF97A3AF),
            size: 13,
          ),

          const SizedBox(width: 4),

          Flexible(
            child: Text(
              titulo,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: activo
                    ? const Color(0xFF22663F)
                    : const Color(0xFF7D8995),
                fontSize: 7.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTÓN NUEVA CONSULTA
  // ============================================================

  Widget _botonAceptar() {
    return SizedBox(
      width: double.infinity,
      child: BtnIconOperativoWidget(
        colorTxt: Colors.white,
        select: true,
        icon: Icons.search_rounded,
        colorIcon: Colors.white,
        titulo: "NUEVA CONSULTA",
        onPressed: onPressedAceptar,
      ),
    );
  }

  // ============================================================
  // DATOS PERSONA
  // ============================================================

  LocalPersonSuModel setDatosPersona(DataConsultaPersona data) {
    final DataSiipne dataSiipne = data.dataSiipne;

    final DataDinardap dataDinardap = data.dataDinardap;

    String nombres = "SIN DATOS";

    String fechaNacimiento = "";

    String edad = "";

    String sexo = "";

    String documento = "";

    String? foto;
    String? pais;
    String? domicilio;
    String? estadoCivil;
    String? madre;
    String? padre;
    String? conyuge;

    if (dataSiipne.success) {
      nombres = dataSiipne.datosSiipne.apenom;

      documento = dataSiipne.datosSiipne.documento;

      fechaNacimiento = dataSiipne.datosSiipne.fechaNacimiento;

      sexo = dataSiipne.datosSiipne.sexo;

      pais = dataSiipne.datosSiipne.pais;

      foto = dataSiipne.datosSiipne.foto64;

      final Edad dataEdad = dataSiipne.datosSiipne.edad;

      edad = "${dataEdad.anos} AÑOS";
    }

    if (dataDinardap.datosDinardap != null) {
      final dynamic dinardap = dataDinardap.datosDinardap;

      if (documento.trim().isEmpty) {
        documento = dinardap.cedula ?? "";
      }

      domicilio = dinardap.domicilio;

      estadoCivil = dinardap.estadoCivil;

      madre = dinardap.nombreMadre;

      padre = dinardap.nombrePadre;

      final String datoConyuge = dinardap.conyuge ?? "";

      if (datoConyuge.trim().length > 5) {
        conyuge = datoConyuge;
      }

      final dynamic fotografia = dinardap.fotografia;

      if (fotografia != null && fotografia.toString().trim().length > 5) {
        foto = fotografia.toString();
      }

      if (!dataSiipne.success && dataDinardap.success) {
        nombres = dinardap.nombre ?? "SIN DATOS";

        sexo = dinardap.genero ?? "";

        fechaNacimiento = dinardap.fechaNacimiento ?? "";

        final dynamic dataEdad = dinardap.edad;

        if (dataEdad != null) {
          edad =
              "${dataEdad.anos} AÑOS - ${dataEdad.meses} MESES - ${dataEdad.dias} DÍAS";
        }
      }
    }

    return LocalPersonSuModel(
      documento: documento,
      nombres: nombres,
      sexo: sexo,
      fechaNcaimiento: fechaNacimiento,
      edad: edad,
      foto: foto,
      conyugue: conyuge,
      domicilio: domicilio,
      estadoCivil: estadoCivil,
      madre: madre,
      padre: padre,
      pais: pais,
    );
  }
  // ============================================================
  // VALIDAR FECHA DEFUNCIÓN
  // ============================================================

  bool _tieneFechaDefuncion(String? fecha) {
    if (fecha == null) {
      return false;
    }

    final String valor = fecha.trim();

    if (valor.isEmpty) {
      return false;
    }

    final String normalizado = valor.toUpperCase();

    const List<String> valoresInvalidos = [
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

    return !valoresInvalidos.contains(normalizado);
  }

  // ============================================================
  // FECHA DEFUNCIÓN PERSONA
  // ============================================================

  Widget _fechaDefuncionPersona(DataConsultaPersona data) {
    if (!data.dataSiipne.success) {
      return const SizedBox.shrink();
    }

    final String fecha = data.dataSiipne.datosSiipne.fechaDefuncion.trim();

    if (!_tieneFechaDefuncion(fecha)) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5AAA5)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD9D5),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFB42318),
              size: 19,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "REGISTRO DE DEFUNCIÓN",
                  style: TextStyle(
                    color: Color(0xFF9C241B),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .2,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "FECHA DE DEFUNCIÓN: $fecha",
                  style: const TextStyle(
                    color: Color(0xFF7C2923),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.error_rounded, color: Color(0xFFB42318), size: 18),
        ],
      ),
    );
  }
  // ============================================================
  // DATOS ORDEN CAPTURA
  // ============================================================

  LocalOrdenCapturaSuModel setDatosOrdenCaptura(DataConsultaPersona data) {
    String descripcion = "NO REGISTRADO";

    String documento = "";

    String oficio = "";

    if (data.ordenCaptura.success) {
      descripcion = data.ordenCaptura.datosCaptura.juzgado;

      documento = data.ordenCaptura.datosCaptura.documento;

      oficio = data.ordenCaptura.datosCaptura.numoficio;
    }

    return LocalOrdenCapturaSuModel(
      documento: documento,
      juzgado: descripcion,
      oficio: oficio,
    );
  }

  // ============================================================
  // CARD ANT
  // ============================================================

  Widget _cardDatosAnt(DataConsultaPersona data) {
    final bool existe = data.datosAnt.success;

    if (!existe) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDDE4EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDF2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                AppSiipneMovilImages.icon_ANT,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AGENCIA NACIONAL DE TRÁNSITO",
                    style: TextStyle(
                      color: Color(0xFF41566A),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    data.datosAnt.message.trim().isEmpty
                        ? "SIN INFORMACIÓN"
                        : data.datosAnt.message,
                    style: const TextStyle(
                      color: Color(0xFF82909D),
                      fontSize: 8.5,
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

    final DataAnt ant = data.datosAnt.data;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB8D2E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 135,
                height: 38,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    AppSiipneMovilImages.icon_ANT,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: ant.tieneLicencia
                      ? const Color(0xFFDDF1E5)
                      : const Color(0xFFFFE3E0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ant.tieneLicencia
                        ? const Color(0xFFB5DFC5)
                        : const Color(0xFFF0BBB6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      ant.tieneLicencia
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 13,
                      color: ant.tieneLicencia
                          ? const Color(0xFF198754)
                          : const Color(0xFFB42318),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      ant.tieneLicencia ? "CON LICENCIA" : "SIN LICENCIA",
                      style: TextStyle(
                        color: ant.tieneLicencia
                            ? const Color(0xFF198754)
                            : const Color(0xFFB42318),
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          _gridDatosAnt(ant),

          if (ant.licencias.isNotEmpty) ...[
            const SizedBox(height: 9),

            const Divider(height: 1, color: Color(0xFFD6E3ED)),

            const SizedBox(height: 8),

            const Row(
              children: [
                Icon(
                  Icons.credit_card_rounded,
                  color: Color(0xFF195BA6),
                  size: 15,
                ),

                SizedBox(width: 5),

                Text(
                  "LICENCIAS",
                  style: TextStyle(
                    color: Color(0xFF38536A),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            ...ant.licencias.map((licencia) => _cardLicenciaAnt(licencia)),
          ],

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _estadoAnt(
                  titulo: "PUNTOS",
                  valor: ant.puntos.isEmpty ? "0" : ant.puntos,
                  icono: Icons.stars_rounded,
                  positivo: true,
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: _estadoAnt(
                  titulo: "INFRACCIONES",
                  valor: ant.infracciones.cantidad.isEmpty
                      ? "0"
                      : ant.infracciones.cantidad,
                  icono: Icons.warning_amber_rounded,
                  positivo: ant.infracciones.cantidad == "0",
                  onTap: () {
                    // _mostrarDialogoInfracciones(ant);
                  },
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: _estadoAnt(
                  titulo: "RESTRICCIONES",
                  valor: "${ant.restricciones.length}",
                  icono: Icons.block_rounded,
                  positivo: ant.restricciones.isEmpty,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRID DATOS ANT
  // ============================================================

  Widget _gridDatosAnt(DataAnt ant) {
    final List<_DatoAntItem> datos = [
      _DatoAntItem(
        icono: Icons.bloodtype_outlined,
        titulo: "TIPO SANGRE",
        valor: ant.tipoSangre,
      ),

      _DatoAntItem(
        icono: Icons.phone_android_rounded,
        titulo: "CELULAR",
        valor: ant.celular,
      ),
    ].where((e) => e.valor.trim().isNotEmpty).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const double espacio = 6;

        final double ancho = (constraints.maxWidth - espacio) / 2;

        return Wrap(
          spacing: espacio,
          runSpacing: 6,
          children: datos.map((item) {
            return SizedBox(
              width: ancho,
              child: _datoAnt(
                icono: item.icono,
                titulo: item.titulo,
                valor: item.valor,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ============================================================
  // DATO ANT
  // ============================================================

  Widget _datoAnt({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    final String dato = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFD8E5EF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFFE4F0FA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icono, color: const Color(0xFF195BA6), size: 12),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF718496),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  dato,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF263E52),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
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
  // LICENCIA ANT
  // ============================================================

  Widget _cardLicenciaAnt(LicenciaAnt licencia) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCFE0EC)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "LICENCIA DE CONDUCIR TIPO",
                  style: TextStyle(
                    color: Color(0xFF708292),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    Expanded(
                      child: _fechaLicencia(
                        titulo: "DESDE",
                        fecha: licencia.fechaDesde,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: _fechaLicencia(
                        titulo: "HASTA",
                        fecha: licencia.fechaHasta,
                      ),
                    ),

                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF195BA6),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        licencia.tipo.isEmpty ? "-" : licencia.tipo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FECHA LICENCIA
  // ============================================================

  Widget _fechaLicencia({required String titulo, required String fecha}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF95A1AD),
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),

        Text(
          _soloFecha(fecha),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF334D62),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _soloFecha(String fecha) {
    if (fecha.trim().isEmpty) {
      return "NO REGISTRADO";
    }

    final String valor = fecha.trim();

    if (valor.contains(" ")) {
      return valor.split(" ").first;
    }

    return valor;
  }

  // ============================================================
  // ESTADO ANT
  // ============================================================

  Widget _estadoAnt({
    required String titulo,
    required String valor,
    required IconData icono,
    required bool positivo,
    VoidCallback? onTap,
  }) {
    final Widget contenido = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: positivo ? const Color(0xFFEAF7F0) : const Color(0xFFFFF0EF),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: positivo ? const Color(0xFFB7DDC7) : const Color(0xFFE8B8B4),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icono,
            color: positivo ? const Color(0xFF198754) : const Color(0xFFB42318),
            size: 15,
          ),

          const SizedBox(height: 2),

          Text(
            valor,
            style: TextStyle(
              color: positivo
                  ? const Color(0xFF176F47)
                  : const Color(0xFF9D2821),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),

          Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6C7B89),
              fontSize: 6.5,
              fontWeight: FontWeight.w800,
            ),
          ),

          /*  if(onTap!=null)...[
            const SizedBox(height:2),

            const Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children:[
                Text(
                  "VER DETALLE",
                  style:TextStyle(
                    color:Color(0xFF607589),
                    fontSize:5.5,
                    fontWeight:FontWeight.w900,
                  ),
                ),

                SizedBox(width:2),

                Icon(
                  Icons.chevron_right_rounded,
                  color:Color(0xFF607589),
                  size:11,
                ),
              ],
            ),
          ],*/
        ],
      ),
    );

    if (onTap == null) {
      return contenido;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: contenido,
      ),
    );
  }
}

void _mostrarDialogoInfracciones(DataAnt ant) {
  final BuildContext? context = Get.context;

  if (context == null) return;

  final String cantidad = ant.infracciones.cantidad.trim().isEmpty
      ? "0"
      : ant.infracciones.cantidad.trim();

  final String valor = ant.infracciones.valor.trim();

  final bool tieneInfracciones = cantidad != "0" && cantidad != "0.0";

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    barrierColor: Colors.black.withOpacity(.68),
    builder: (dialogContext) {
      final double alto = MediaQuery.sizeOf(dialogContext).height;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: alto * .78),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.22),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==============================================
                // HEADER
                // ==============================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(13, 11, 6, 11),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: tieneInfracciones
                          ? const [Color(0xFFB42318), Color(0xFF7A1710)]
                          : const [Color(0xFF238457), Color(0xFF176A45)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          tieneInfracciones
                              ? Icons.warning_amber_rounded
                              : Icons.verified_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "INFRACCIONES ANT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .25,
                              ),
                            ),

                            const SizedBox(height: 1),

                            Text(
                              tieneInfracciones
                                  ? "INFORMACIÓN REGISTRADA"
                                  : "SIN INFRACCIONES REGISTRADAS",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.82),
                                fontSize: 7.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 34,
                          minHeight: 34,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                ),

                // ==============================================
                // CONTENIDO
                // ==============================================
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // ========================================
                        // RESUMEN
                        // ========================================

                        Row(
                          children: [
                            Expanded(
                              child: _datoDialogoInfraccion(
                                icono: Icons.format_list_numbered_rounded,
                                titulo: "CANTIDAD",
                                valor: cantidad,
                                alerta: tieneInfracciones,
                              ),
                            ),

                            const SizedBox(width: 7),

                            Expanded(
                              child: _datoDialogoInfraccion(
                                icono: Icons.account_balance_wallet_outlined,
                                titulo: "VALOR",
                                valor: valor.isEmpty ? "NO REGISTRADO" : valor,
                                alerta: tieneInfracciones,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ========================================
                        // ESTADO
                        // ========================================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tieneInfracciones
                                ? const Color(0xFFFFF0EF)
                                : const Color(0xFFF0F8F4),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: tieneInfracciones
                                  ? const Color(0xFFE7B8B4)
                                  : const Color(0xFFB8DCC8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: tieneInfracciones
                                      ? const Color(0xFFFFDCD8)
                                      : const Color(0xFFDDF1E5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  tieneInfracciones
                                      ? Icons.report_problem_rounded
                                      : Icons.verified_user_rounded,
                                  color: tieneInfracciones
                                      ? const Color(0xFFB42318)
                                      : const Color(0xFF198754),
                                  size: 20,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tieneInfracciones
                                          ? "REGISTRA INFRACCIONES"
                                          : "SIN NOVEDADES",
                                      style: TextStyle(
                                        color: tieneInfracciones
                                            ? const Color(0xFF9C241B)
                                            : const Color(0xFF267149),
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      tieneInfracciones
                                          ? "La Agencia Nacional de Tránsito registra $cantidad infracción${cantidad == "1" ? "" : "es"}."
                                          : "No se registran infracciones en la información consultada.",
                                      style: const TextStyle(
                                        color: Color(0xFF718496),
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ========================================
                        // INFORMACIÓN SERVICIO
                        // ========================================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F6FA),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF607589),
                                size: 16,
                              ),

                              SizedBox(width: 7),

                              Expanded(
                                child: Text(
                                  "La información mostrada corresponde a los datos entregados por el servicio de la Agencia Nacional de Tránsito.",
                                  style: TextStyle(
                                    color: Color(0xFF6E8091),
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 11),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            icon: const Icon(Icons.check_rounded, size: 18),
                            label: const Text(
                              "CERRAR",
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(44),
                              backgroundColor: const Color(0xFF195BA6),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _datoDialogoInfraccion({
  required IconData icono,
  required String titulo,
  required String valor,
  required bool alerta,
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: alerta ? const Color(0xFFE6C0BD) : const Color(0xFFD8E3ED),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: alerta ? const Color(0xFFFFE8E6) : const Color(0xFFE8F2FC),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icono,
            color: alerta ? const Color(0xFFB42318) : const Color(0xFF195BA6),
            size: 18,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFF8291A0),
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                valor,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: alerta
                      ? const Color(0xFF9C241B)
                      : const Color(0xFF29445D),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
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
// MODELOS LOCALES DE APOYO
// ============================================================

class _DatoBoletaItem {
  final IconData icono;
  final String titulo;
  final String valor;

  const _DatoBoletaItem({
    required this.icono,
    required this.titulo,
    required this.valor,
  });
}

class _DatoAntItem {
  final IconData icono;
  final String titulo;
  final String valor;

  const _DatoAntItem({
    required this.icono,
    required this.titulo,
    required this.valor,
  });
}
