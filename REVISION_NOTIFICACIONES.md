# Revisión del proyecto y corrección de notificaciones

Fecha: 6 de octubre de 2026.

## Alcance y estructura

Se ejecutó el analizador de Flutter sobre todo el proyecto y se revisaron los flujos de inicio, inyección de dependencias, permisos, consultas operativas, recepción de Firebase, notificaciones locales, navegación y cierre de sesión. La revisión manual se concentró en estos flujos; el análisis estático cubrió todo `lib`.

- `lib/main.dart`: arranque, Firebase y handler de segundo plano.
- `lib/app`: configuración general, pantallas iniciales, utilidades y rutas.
- `lib/feactures/user`: autenticación, sesión y almacenamiento.
- `lib/feactures/gps`: permisos y ubicación usada por las consultas.
- `lib/feactures/pushNotification`: permisos, registro de tokens, notificaciones generales y persistencia SQLite.
- `lib/app_siipne_movil`: módulos de operativos urbanos y migratorios, controladores GetX, casos de uso, solicitudes, modelos y acceso a APIs.

El cliente envía las consultas de persona y vehículo a las APIs mediante los casos de uso y el datasource. No contiene el código que publica las alertas en Firebase desde el servidor.

## Fallos identificados y cambios

1. **Identificación por `alertaId`.** El servicio y el controlador descartaban futuras alertas si el backend reutilizaba ese valor. Ahora usan `messageId` de Firebase para distinguir envíos. Sin ese identificador, la identidad se construye con fecha de envío y contenido ordenado. Entregas repetidas del mismo mensaje se deduplican; nuevos mensajes con el mismo `alertaId` pueden mostrarse. Si no hay identificador ni fecha y el contenido es idéntico, el cliente no puede distinguir un nuevo envío de una entrega repetida.
2. **Segundo plano con mensajes solo data.** El handler descartaba explícitamente `BOLETA` y `VEHICULO_ROBADO`. Ahora los procesa con el canal operativo, leyendo el ID activo desde almacenamiento seguro. Los mensajes con `notification` siguen siendo mostrados por el sistema.
3. **Preparación de listeners.** Antes de consultar personas, vehículos, conductores u ocupantes, el controlador conecta sus listeners y espera el intento de activación del topic. La activación conserva su manejo de errores para que un fallo push no convierta la consulta en un fallo de negocio. Los listeners de Firebase permanecen únicos durante la vida del servicio.
4. **Alertas cercanas entre sí.** El indicador de diálogo programado descartaba la segunda alerta que llegaba antes del siguiente frame. Ahora cada mensaje se encola y su diálogo espera a que se cierre el anterior.
5. **Renovación de token.** El bloc general solo imprimía el token renovado. Ahora vuelve a registrar el token con los datos de usuario y aplicación disponibles en la sesión; el servicio operativo mantiene su resincronización del topic. Se cancelan las suscripciones al cerrar el bloc.
6. **Cierre de sesión operativo.** Se borra el ID persistido y se solicita la baja del topic antes de navegar desde el operativo o desde el menú SIIPNE. La baja fallida conserva el mecanismo de reintento existente.
7. **Android.** Se declaran el permiso de notificaciones, el canal por defecto de Firebase `alertas_operativo_v2` y el icono existente `ic_stat_operativo`.
8. Se eliminó un handler de segundo plano duplicado y no registrado en el bloc; el handler registrado permanece en `main.dart`.

Se conservaron los cambios previos presentes en el workspace y no se modificó `.env`.

## Verificación

- `flutter analyze --no-pub`: 0 errores, 99 advertencias y 434 avisos informativos. El comando devuelve código 1 por las observaciones; no constituye una ejecución sin advertencias.
- Entre las observaciones generales están imports y variables sin uso, APIs obsoletas y la referencia a `flutter_lints/flutter.yaml` que no se resuelve con la configuración actual.
- Cuatro pruebas en `test/operativo_push_identity_test.dart`: envíos distintos con igual `alertaId`, entrega repetida, diferenciación por fecha sin `messageId` y contenido sin identificadores con distinto orden de claves.
- `git diff --check`: sin errores de espacios.
- No se realizó una prueba de entrega real de Firebase ni una compilación Android/iOS.

Como hallazgo adicional de la revisión, `MyHttpOverrides` acepta cualquier certificado TLS. No se modificó ese comportamiento dentro de esta corrección de notificaciones.

## Comprobación necesaria con dos dispositivos

1. Abrir el mismo operativo en A y B y comprobar `Suscrito a operativo_<id>` en ambos.
2. Consultar desde A un vehículo robado; comprobar la alerta en ambos dispositivos.
3. Consultar después un conductor y un ocupante con orden de captura; comprobar que cada envío llega a ambos y que sus diálogos aparecen en orden.
4. Repetir con B en segundo plano, tanto con `notification + data` como con solo `data`.
5. Cerrar sesión en B y comprobar la baja del topic para las alertas de solo data. Si falla la baja remota, un mensaje con `notification` aún puede mostrarse automáticamente por el sistema hasta que se complete el reintento.

Para cada envío operativo, el backend debe publicar al topic `operativo_<id>` y adjuntar `idHdrEvento` y `tipo` (`BOLETA` o `VEHICULO_ROBADO`). Debe publicar cada nueva detección, incluidas las consultas de conductor/ocupante. El listener no publica alertas hacia otros teléfonos. Si no aparece un nuevo evento `[PUSH] MENSAJE RECIBIDO` en B, se debe revisar el envío y las suscripciones; si aparece, se debe revisar el contenido y el resultado de visualización. Esta separación permite confirmar si el fallo restante está en el servidor o en el cliente.
