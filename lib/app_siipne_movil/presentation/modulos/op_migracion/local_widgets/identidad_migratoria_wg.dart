part of '../../pages.dart';

mixin IdentidadMigratoriaViewMixin on OpMigracionPageBase {
  Widget selectorExtranjeros() {
    return _MigracionCard(
      borderColor: const Color(0xFFB8D0E5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _MigracionSectionHeader(
            icono: Icons.people_alt_outlined,
            titulo: 'COINCIDENCIAS ENCONTRADAS',
            subtitulo: 'Seleccione la persona para consultar su detalle.',
            badge: '${controller.extranjerosEncontrados.length}',
          ),
          const SizedBox(height: 10),
          ...controller.extranjerosEncontrados.map(
            (DataExtranjeroDocumento extranjero) {
              final DatosBiograficosMigracion? bio =
                  extranjero.datosBiograficosPrincipal;
              return Container(
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: _MigracionColors.fondo,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD5E3EF)),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4F0FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: _MigracionColors.azul,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            bio?.nombresCompletos.isNotEmpty == true
                                ? bio!.nombresCompletos
                                : 'PERSONA SIN NOMBRE REGISTRADO',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _MigracionColors.texto,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            extranjero.idCiudadano,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _MigracionColors.textoSuave,
                              fontSize: 7.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Consultar detalle',
                      onPressed: () =>
                          controller.seleccionarExtranjero(extranjero),
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: _MigracionColors.azul,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget identidadMigratoria() {
    final DataExtranjeroDocumento? extranjero =
        controller.extranjeroSeleccionado.value;
    final DatosBiograficosMigracion? bio = controller.datosBiograficos;

    if (extranjero == null || bio == null) {
      return const _MigracionCard(
        child: _MigracionVacio(
          icono: Icons.person_off_outlined,
          texto: 'No existen datos biográficos para mostrar.',
        ),
      );
    }

    return _MigracionCard(
      borderColor: const Color(0xFF9FC2E2),
      child: Column(
        children: <Widget>[
          _MigracionSectionHeader(
            icono: Icons.account_box_outlined,
            titulo: 'IDENTIDAD MIGRATORIA',
            subtitulo: extranjero.idCiudadano,
            badge: 'IDENTIFICADO',
          ),
          const SizedBox(height: 11),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFFF4F9FD), Color(0xFFEBF3FA)],
              ),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFFC7DCEB)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: _MigracionColors.azul,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        bio.nombresCompletos,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _MigracionColors.texto,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${bio.genero} · ${bio.estadoCivil}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _MigracionColors.textoSuave,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _MigracionDato(
                  titulo: 'FECHA DE NACIMIENTO',
                  valor: bio.fechaNacimiento,
                  icono: Icons.cake_outlined,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _MigracionDato(
                  titulo: 'PAÍS DE NACIMIENTO',
                  valor: bio.paisNacimiento,
                  icono: Icons.public_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: <Widget>[
              Expanded(
                child: _MigracionDato(
                  titulo: 'PAÍS DE RESIDENCIA',
                  valor: bio.paisResidencia,
                  icono: Icons.home_work_outlined,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _MigracionDato(
                  titulo: 'PROFESIÓN',
                  valor: bio.profesion,
                  icono: Icons.work_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
