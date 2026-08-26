part of '../../pages.dart';

mixin DocumentosMigracionViewMixin on OpMigracionPageBase {
  Widget documentosMigratorios() {
    final List<DocumentoExtranjeroMigracion> documentos =
        controller.extranjeroSeleccionado.value?.documentos ??
            <DocumentoExtranjeroMigracion>[];

    return _MigracionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _MigracionSectionHeader(
            icono: Icons.folder_shared_outlined,
            titulo: 'DOCUMENTOS REGISTRADOS',
            subtitulo: 'Documentos encontrados en los sistemas institucionales.',
            badge: '${documentos.length}',
          ),
          const SizedBox(height: 10),
          if (documentos.isEmpty)
            const _MigracionVacio(
              icono: Icons.folder_off_outlined,
              texto: 'No existen documentos migratorios registrados.',
            )
          else
            ...documentos.asMap().entries.map(
              (MapEntry<int, DocumentoExtranjeroMigracion> entry) {
                final DocumentoExtranjeroMigracion documento = entry.value;
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    bottom: entry.key == documentos.length - 1 ? 0 : 7,
                  ),
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: _MigracionColors.fondo,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD5E2ED)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: documento.tipoDocumento
                                  .toUpperCase()
                                  .contains('PASAPORTE')
                              ? const Color(0xFFE4F0FA)
                              : const Color(0xFFE8F5EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          documento.tipoDocumento
                                  .toUpperCase()
                                  .contains('PASAPORTE')
                              ? Icons.menu_book_rounded
                              : Icons.badge_rounded,
                          color: documento.tipoDocumento
                                  .toUpperCase()
                                  .contains('PASAPORTE')
                              ? _MigracionColors.azul
                              : _MigracionColors.verde,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              documento.tipoDocumento,
                              style: const TextStyle(
                                color: _MigracionColors.texto,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              documento.numeroDocumento,
                              style: const TextStyle(
                                color: _MigracionColors.azul,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              documento.nacionalidadDocumento,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3FC),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          documento.sistema.toUpperCase(),
                          style: const TextStyle(
                            color: _MigracionColors.azul,
                            fontSize: 6.8,
                            fontWeight: FontWeight.w900,
                          ),
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
}
