
part of '../../controllers.dart';

class TipoOperativoController extends GetxController {
final loginController = Get.find<LoginController>();
final SiipneMovilUseCase siipneMovilUseCase = Get.find();

late UserEntities user;

RxBool peticionServerState = false.obs;

DataModulo dataModuloResponse = DataModulo.empty();

RxList<DataTipoOperativo> listTipoOperativos = <DataTipoOperativo>[].obs;

Rx<DataTipoOperativo> selectTipoOperativo = DataTipoOperativo.empty().obs;

RxList<DataTipoOperativo> rutaSeleccionada = <DataTipoOperativo>[].obs;

RxBool showContinuar = false.obs;

final TextEditingController numeroOperativoController =
TextEditingController();

final Rxn<Anexarse> datosAnexarse = Rxn<Anexarse>();
final RxBool consultandoAnexarse = false.obs;
final RxBool operativoAnexarseValido = false.obs;
final RxString mensajeAnexarse = ''.obs;
final RxDouble distanciaAnexarseMetros = 0.0.obs;

static const double radioMaximoAnexarseMetros = 100.0;

String mensajeErrorAnexarse = '';
@override
void onInit() {
super.onInit();
user = loginController.user.value;
getDataToPage();
}

@override
void onReady() {
super.onReady();
}

@override
void onClose() {
numeroOperativoController.dispose();
super.onClose();
}

// =========================================================
// CARGAR DATOS DE LA PÁGINA
// =========================================================

Future<void> getDataToPage() async {
final arguments = Get.arguments as Map<String, dynamic>?;

if (arguments != null && arguments.containsKey('modulo')) {
try {
dataModuloResponse = arguments['modulo'] as DataModulo;

update();

await getTipoOperativos();

update();
} catch (e) {
print('Error getDataToPage: $e');
}
}
}

// =========================================================
// CARGAR TIPOS DE OPERATIVO
// =========================================================

Future<void> getTipoOperativos() async {
peticionServerState(true);

try {
await ExceptionDialogos.manejarErroresShowDialogo(
showMsjNodata: false,
() async {
GetTipoOperativosRequest request = GetTipoOperativosRequest(
idGenModulo: dataModuloResponse.idGenModulo,
);

listTipoOperativos.value = await siipneMovilUseCase.getTipoOperativos(
request: request,
);

rutaSeleccionada.clear();
selectTipoOperativo.value = DataTipoOperativo.empty();
showContinuar.value = false;

if (listTipoOperativos.isEmpty) {
print("Sin permisos cerrar");
return;
}

/*
           * ====================================================
           * NIVEL 1 AUTOMÁTICO
           * ====================================================
           *
           * El primer nivel corresponde al módulo seleccionado.
           * Como ya sabemos de qué módulo viene el usuario,
           * no necesitamos volver a preguntarlo.
           *
           * Lo agregamos internamente a rutaSeleccionada,
           * pero NO se mostrará como combo.
           */
_seleccionarPadreAutomatico();
},
);
} finally {
peticionServerState(false);
}
}

// =========================================================
// SELECCIONAR PADRE AUTOMÁTICAMENTE
// =========================================================

void _seleccionarPadreAutomatico() {
final List<DataTipoOperativo> padres = hijosRaiz;

if (padres.isEmpty) {
print('No existe elemento raíz para el módulo');
return;
}

/*
     * De acuerdo con tu estructura, el primer nivel
     * es único para el módulo seleccionado.
     */
final DataTipoOperativo padre = padres.first;

rutaSeleccionada.clear();
rutaSeleccionada.add(padre);

selectTipoOperativo.value = padre;

/*
     * Normalmente este padre tendrá hijos.
     * Si excepcionalmente no tiene, se considera final.
     */
showContinuar.value = !tieneHijos(padre.idGenTipoTipificacion);

rutaSeleccionada.refresh();

print('======================================');
print('NIVEL 1 AUTOMÁTICO');
print('Descripción: ${padre.descripcion}');
print(
'idGenTipoTipificacion: '
'${padre.idGenTipoTipificacion}',
);
print('Tiene hijos: ${tieneHijos(padre.idGenTipoTipificacion)}');
print('======================================');
}

// =========================================================
// CREAR OPERATIVO
// =========================================================

Future<void> crearOperativo() async {
if (selectTipoOperativo.value.idOperativo <= 0) {
DialogosAwesome.getInformation(
title: "Operativo requerido",
descripcion:
"Seleccione completamente el tipo de operativo antes de continuar.",
titleBtn: "Entendido",
);
return;
}

peticionServerState(true);

try {
await ExceptionDialogos.manejarErroresShowDialogo(
showMsjNodata: false,
() async {
final locationBloc = BlocProvider.of<LocationBloc>(Get.context!);

LatLng pos = await locationBloc.getCurrentPosition();

String ip = await DeviceInfoApp.getIp;

String realiza = "Realiza: ${user.nombres}";

CreateOperativoRequest request = CreateOperativoRequest(
latitud: pos.latitude,
longitud: pos.longitude,
dataModuloIdGenTipoTipificacionEcu:
dataModuloResponse.idGenTipoTipificacionEcu,
dataModuloIdTipoServicio: dataModuloResponse.idHdrTipoServicio,
idTipoOperativo: selectTipoOperativo.value.idOperativo,
ip: ip,
idGenPersona: user.idGenPersona,
idGenUsuario: user.idGenUsuario,
realiza: realiza,
);

DataCreateOp dataCreateOp = await siipneMovilUseCase.createOperativo(
request: request,
);

if (dataCreateOp.idHdrEvento > 0) {
DialogosAwesome.getSucess(
descripcion: "Operativo creado con éxito",
btnOkOnPress: () {
goToPageOperativo(dataCreateOp);
},
);
}
},
);
} finally {
peticionServerState(false);
}
}

// =========================================================
// ANEXARSE - LIMPIAR
// =========================================================

void limpiarAnexarse() {
numeroOperativoController.clear();
datosAnexarse.value = null;
operativoAnexarseValido.value = false;
mensajeAnexarse.value = '';
distanciaAnexarseMetros.value = 0;
}

// =========================================================
// ANEXARSE - CONSULTAR OPERATIVO
// =========================================================

Future<Anexarse?> consultarOperativoAnexarse(int numeroOperativo) async {
if (numeroOperativo <= 0) {
mensajeErrorAnexarse = 'Ingrese un número de operativo válido.';
return null;
}

if (peticionServerState.value) {
return null;
}

mensajeErrorAnexarse = '';
peticionServerState(true);

try {
debugPrint('==========================================');
debugPrint('CONSULTANDO OPERATIVO PARA ANEXARSE');
debugPrint('ID HDR EVENTO: $numeroOperativo');
debugPrint('==========================================');

final GetDatosAnexarseOperativoRequest request =
GetDatosAnexarseOperativoRequest(idHdrEvento: numeroOperativo);

final Anexarse respuesta = await siipneMovilUseCase.consultarAnexarse(
request: request,
);

debugPrint('==========================================');
debugPrint('RESPUESTA OPERATIVO ANEXARSE');
debugPrint('ID HDR: ${respuesta.idHdrEvento}');
debugPrint('ID TIPO: ${respuesta.idTipoOperativo}');
debugPrint('DESCRIPCIÓN: ${respuesta.descripcion}');
debugPrint('ESTADO: ${respuesta.estadoOperativo}');
debugPrint('ESTADO POLICÍA: ${respuesta.estadoPolicia}');
debugPrint('POLICÍA: ${respuesta.policia}');
debugPrint('==========================================');

if (respuesta.idHdrEvento <= 0) {
mensajeErrorAnexarse = 'El operativo consultado no es válido.';
return null;
}

if (respuesta.idTipoOperativo <= 0) {
mensajeErrorAnexarse =
'El operativo no posee una configuración válida.';
return null;
}

if (!_tipoOperativoPerteneceAlModulo(respuesta.idTipoOperativo)) {
final String modulo = dataModuloResponse.descripcion.trim();

mensajeErrorAnexarse =
'El operativo N.° ${respuesta.idHdrEvento} no pertenece al módulo '
'${modulo.isEmpty ? 'seleccionado' : modulo}. Ingrese desde la '
'opción correspondiente al tipo de operativo con el que fue creado.';

return null;
}

final bool ubicacionValida = await _validarRadioAnexarse(respuesta);

if (!ubicacionValida) {
return null;
}

debugPrint('==========================================');
debugPrint('OPERATIVO VÁLIDO PARA ANEXARSE');
debugPrint('ID HDR: ${respuesta.idHdrEvento}');
debugPrint('TIPO: ${respuesta.idTipoOperativo}');
debugPrint('ESTADO: ${respuesta.estadoOperativo}');
debugPrint('==========================================');

return respuesta;
} on ServerException catch (e, stackTrace) {
/*
   * Error genérico generado por la infraestructura.
   */
final dynamic error = e;

String mensaje = '';

try {
mensaje = error.message?.toString().trim() ?? '';
} catch (_) {}

mensajeErrorAnexarse = mensaje.isEmpty
? 'No fue posible verificar el operativo.'
    : mensaje;

debugPrint('==========================================');
debugPrint('SERVER EXCEPTION ANEXARSE');
debugPrint('MENSAJE: $mensajeErrorAnexarse');
debugPrint('$stackTrace');
debugPrint('==========================================');

return null;
} catch (e, stackTrace) {
/*
   * Aquí llegará el Exception lanzado por UrlApiProviderApp:
   *
   * Exception: BadRequest: Operativo 7142012 no existe
   */
mensajeErrorAnexarse = _limpiarMensajeAnexarse(e.toString());

debugPrint('==========================================');
debugPrint('ERROR BACKEND ANEXARSE');
debugPrint('ERROR ORIGINAL: $e');
debugPrint('MENSAJE FINAL: $mensajeErrorAnexarse');
debugPrint('$stackTrace');
debugPrint('==========================================');

return null;
} finally {
peticionServerState(false);
}
}

// =========================================================
// LIMPIAR MENSAJE BACKEND ANEXARSE
// =========================================================
String _limpiarMensajeAnexarse(String mensaje) {
String resultado = mensaje.trim();

if (resultado.isEmpty) {
return 'No fue posible verificar el operativo.';
}

resultado = resultado.replaceFirst(
RegExp(r'^Exception:\s*', caseSensitive: false),
'',
);

resultado = resultado.replaceFirst(
RegExp(r'^BadRequest:\s*', caseSensitive: false),
'',
);

return resultado.trim();
}

// =========================================================
// VALIDAR TIPO DE OPERATIVO DEL MÓDULO ACTUAL
// =========================================================

bool _tipoOperativoPerteneceAlModulo(int idTipoOperativo) {
if (idTipoOperativo <= 0 || listTipoOperativos.isEmpty) {
return false;
}

return listTipoOperativos.any(
(DataTipoOperativo item) => item.idOperativo == idTipoOperativo,
);
}

// =========================================================
// VALIDAR RADIO MÁXIMO DE 100 METROS
// =========================================================

Future<bool> _validarRadioAnexarse(Anexarse data) async {
distanciaAnexarseMetros.value = 0;

final double? latitudOperativo = _leerCoordenadaAnexarse(
data,
esLatitud: true,
);
final double? longitudOperativo = _leerCoordenadaAnexarse(
data,
esLatitud: false,
);

if (latitudOperativo == null ||
longitudOperativo == null ||
(latitudOperativo == 0 && longitudOperativo == 0)) {
mensajeErrorAnexarse =
'No fue posible validar la ubicación del operativo. La consulta debe '
'devolver la latitud y longitud registradas al momento de crearlo.';
return false;
}

try {
final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(
Get.context!,
);
final LatLng posicionActual = await locationBloc.getCurrentPosition();

final double distancia = _calcularDistanciaMetros(
posicionActual.latitude,
posicionActual.longitude,
latitudOperativo,
longitudOperativo,
);

distanciaAnexarseMetros.value = distancia;

debugPrint('==========================================');
debugPrint('VALIDACIÓN DE PROXIMIDAD PARA ANEXARSE');
debugPrint('ACTUAL: ${posicionActual.latitude}, ${posicionActual.longitude}');
debugPrint('OPERATIVO: $latitudOperativo, $longitudOperativo');
debugPrint('DISTANCIA: ${distancia.toStringAsFixed(2)} METROS');
debugPrint('RADIO PERMITIDO: $radioMaximoAnexarseMetros METROS');
debugPrint('==========================================');

if (distancia > radioMaximoAnexarseMetros) {
mensajeErrorAnexarse =
'Debe encontrarse dentro de un radio de 100 metros del lugar donde '
'se creó el operativo. Distancia actual aproximada: '
'${distancia.toStringAsFixed(0)} metros.';
return false;
}

return true;
} catch (e, stackTrace) {
mensajeErrorAnexarse =
'No fue posible obtener su ubicación actual. Active el GPS, conceda '
'el permiso de ubicación e intente nuevamente.';

debugPrint('ERROR VALIDANDO DISTANCIA PARA ANEXARSE: $e');
debugPrint('$stackTrace');

return false;
}
}

double? _leerCoordenadaAnexarse(
Anexarse data, {
required bool esLatitud,
}) {
final dynamic objeto = data;
dynamic valor;

try {
valor = esLatitud ? objeto.latitud : objeto.longitud;
} catch (_) {}

if (valor == null) {
try {
final dynamic jsonDinamico = objeto.toJson();

if (jsonDinamico is Map) {
final Map<String, dynamic> json = Map<String, dynamic>.from(
jsonDinamico,
);

valor = esLatitud
? json['latitud'] ?? json['latitude'] ?? json['lat']
    : json['longitud'] ??
json['longitude'] ??
json['lng'] ??
json['lon'];
}
} catch (_) {}
}

final double? coordenada = _convertirDouble(valor);

if (coordenada == null) return null;

if (esLatitud && (coordenada < -90 || coordenada > 90)) return null;
if (!esLatitud && (coordenada < -180 || coordenada > 180)) return null;

return coordenada;
}

double? _convertirDouble(dynamic valor) {
if (valor == null) return null;
if (valor is num) return valor.toDouble();

final String texto = valor.toString().trim().replaceAll(',', '.');

if (texto.isEmpty) return null;

return double.tryParse(texto);
}

double _calcularDistanciaMetros(
double latitudActual,
double longitudActual,
double latitudOperativo,
double longitudOperativo,
) {
// Aproximación plana de alta precisión para distancias cortas en Ecuador.
// Evita incorporar dependencias adicionales en este archivo `part of`.
const double metrosPorGrado = 111320.0;

final double diferenciaLatitud =
(latitudActual - latitudOperativo) * metrosPorGrado;
final double diferenciaLongitud =
(longitudActual - longitudOperativo) * metrosPorGrado;
final double distanciaCuadrada =
(diferenciaLatitud * diferenciaLatitud) +
(diferenciaLongitud * diferenciaLongitud);

return _raizCuadrada(distanciaCuadrada);
}

double _raizCuadrada(double valor) {
if (valor <= 0) return 0;

double aproximacion = valor < 1 ? 1 : valor;

for (int i = 0; i < 14; i++) {
aproximacion = (aproximacion + (valor / aproximacion)) / 2;
}

return aproximacion;
}
// =========================================================
// ANEXARSE - INGRESAR AL OPERATIVO
// =========================================================

// =========================================================
// RESOLVER MÓDULO Y RUTA
// =========================================================

String _normalizarTipoOperativo(String value) {
return value
    .trim()
    .toUpperCase()
    .replaceAll('Á', 'A')
    .replaceAll('É', 'E')
    .replaceAll('Í', 'I')
    .replaceAll('Ó', 'O')
    .replaceAll('Ú', 'U')
    .replaceAll('Ü', 'U')
    .replaceAll(RegExp(r'\s+'), ' ');
}

bool _esModuloMovilMigracion() {
final String modulo = _normalizarTipoOperativo(
dataModuloResponse.descripcion,
);

return modulo.contains('MOVIL MIGRACION');
}

String _rutaPorModulo() {
return _esModuloMovilMigracion()
? SiipneMovilRoutes.OPERATIVOS_MIGRACION
    : SiipneMovilRoutes.OPERATIVOS_SERVICIO_URBANO;
}

Future<bool> anexarseOperativo(Anexarse data) async {
if (data.idHdrEvento <= 0) {
DialogosAwesome.getInformation(
title: "Operativo inválido",
descripcion: "No se recibió un identificador válido del operativo.",
titleBtn: "Entendido",
);
return false;
}

if (data.idTipoOperativo <= 0) {
DialogosAwesome.getInformation(
title: "Configuración inválida",
descripcion: "No se recibió la configuración del operativo.",
titleBtn: "Entendido",
);
return false;
}

if (!_tipoOperativoPerteneceAlModulo(data.idTipoOperativo)) {
mensajeErrorAnexarse =
'El tipo del operativo no corresponde al módulo seleccionado.';

DialogosAwesome.getError(
title: 'MÓDULO NO COMPATIBLE',
descripcion: mensajeErrorAnexarse,
);

return false;
}

final bool continuaDentroDelRadio = await _validarRadioAnexarse(data);

if (!continuaDentroDelRadio) {
return false;
}

final String nombreModulo = dataModuloResponse.descripcion.trim();
final String nombreOperativo = data.descripcion.trim();
final String ruta = _rutaPorModulo();

debugPrint('==========================================');
debugPrint('CONFIRMANDO ANEXARSE');
debugPrint('ID HDR EVENTO: ${data.idHdrEvento}');
debugPrint('ID TIPO OPERATIVO: ${data.idTipoOperativo}');
debugPrint('MÓDULO: $nombreModulo');
debugPrint('DESCRIPCIÓN: $nombreOperativo');
debugPrint('RUTA: $ruta');
debugPrint('==========================================');

Get.offNamed(
ruta,
arguments: <String, dynamic>{
'tipoAcceso': 'ANEXARSE',
'anexarse': data,
'idHdrEvento': data.idHdrEvento,
'idOperativo': data.idTipoOperativo,
'idTipoOperativo': data.idTipoOperativo,
'nombreModulo': nombreModulo,
'nombreOperativo': nombreOperativo,
},
);

return true;
}

// =========================================================
// IR AL OPERATIVO
// =========================================================

// =========================================================
// IR AL OPERATIVO
// =========================================================

void goToPageOperativo(DataCreateOp dataCreateOp) {
final String nombreModulo = dataModuloResponse.descripcion.trim();
final String nombreOperativo =
selectTipoOperativo.value.descripcion.trim();
final String ruta = _rutaPorModulo();

debugPrint('==========================================');
debugPrint('ABRIENDO OPERATIVO CREADO');
debugPrint('ID HDR EVENTO: ${dataCreateOp.idHdrEvento}');
debugPrint('ID TIPO: ${dataCreateOp.idTipoOperativo}');
debugPrint('MÓDULO: $nombreModulo');
debugPrint('NOMBRE: $nombreOperativo');
debugPrint('RUTA: $ruta');
debugPrint('==========================================');

Get.offAndToNamed(
ruta,
arguments: <String, dynamic>{
'tipoAcceso': 'NUEVO',
'dataCreateOp': dataCreateOp,
'idHdrEvento': dataCreateOp.idHdrEvento,
'idGenGeoSenplades': dataCreateOp.idGenGeoSenplades,
'idOperativo': dataCreateOp.idTipoOperativo,
'nombreModulo': nombreModulo,
'nombreOperativo': nombreOperativo,
},
);
}

// =========================================================
// OBTENER RAÍCES
// =========================================================

List<DataTipoOperativo> get hijosRaiz {
final Map<int, DataTipoOperativo> unicos = {};

for (final item in listTipoOperativos) {
if (item.idPadre == 0) {
unicos[item.idGenTipoTipificacion] = item;
}
}

return unicos.values.toList();
}

// =========================================================
// OBTENER HIJOS
// =========================================================

List<DataTipoOperativo> getHijos(int idPadre) {
final Map<int, DataTipoOperativo> unicos = {};

for (final item in listTipoOperativos) {
if (item.idPadre == idPadre) {
unicos[item.idGenTipoTipificacion] = item;
}
}

return unicos.values.toList();
}

// =========================================================
// SABER SI TIENE HIJOS
// =========================================================

bool tieneHijos(int idGenTipoTipificacion) {
return listTipoOperativos.any(
(item) => item.idPadre == idGenTipoTipificacion,
);
}

// =========================================================
// DATOS POR NIVEL
// =========================================================

List<DataTipoOperativo> getDatosNivel(int nivel) {
/*
     * NIVEL INTERNO 0
     *
     * Sigue existiendo porque forma parte de la jerarquía,
     * pero ya no se mostrará visualmente.
     */
if (nivel == 0) {
return hijosRaiz;
}

/*
     * Para nivel 1 necesitamos:
     * rutaSeleccionada[0] = padre automático.
     *
     * Para nivel 2:
     * rutaSeleccionada[1] = selección nivel 2.
     */
if (rutaSeleccionada.length < nivel) {
return [];
}

final DataTipoOperativo padre = rutaSeleccionada[nivel - 1];

return getHijos(padre.idGenTipoTipificacion);
}

// =========================================================
// SELECCIONAR
// =========================================================

void seleccionarTipoOperativo(int nivel, DataTipoOperativo item) {
/*
     * Nunca permitimos reemplazar el nivel 0 desde los combos,
     * porque el nivel 0 corresponde al padre automático.
     */
if (nivel <= 0) {
return;
}

/*
     * Si cambia una selección anterior,
     * eliminamos todo lo que venga después.
     */
if (rutaSeleccionada.length > nivel) {
rutaSeleccionada.removeRange(nivel, rutaSeleccionada.length);
}

/*
     * El tamaño esperado antes de agregar nivel N es N.
     *
     * Ejemplo:
     * nivel 1 → ruta tiene únicamente nivel 0.
     * nivel 2 → ruta tiene niveles 0 y 1.
     */
if (rutaSeleccionada.length == nivel) {
rutaSeleccionada.add(item);
} else if (rutaSeleccionada.length > nivel) {
rutaSeleccionada[nivel] = item;
}

selectTipoOperativo.value = item;

print('-------------------------------');
print('Nivel interno seleccionado: $nivel');
print('Nivel visible: ${nivel + 1}');
print('Descripción: ${item.descripcion}');
print(
'idGenTipoTipificacion: '
'${item.idGenTipoTipificacion}',
);
print('idPadre: ${item.idPadre}');

if (tieneHijos(item.idGenTipoTipificacion)) {
print('Tiene hijos -> mostrar siguiente combo');

showContinuar.value = false;
} else {
print('No tiene hijos -> selección final');
print(
'idOperativo final: '
'${item.idOperativo}',
);

print(
'select idOperativo: '
'${selectTipoOperativo.value.idOperativo}',
);

showContinuar.value = true;
}

print('-------------------------------');

rutaSeleccionada.refresh();
}

// =========================================================
// SELECCIÓN POR NIVEL
// =========================================================

DataTipoOperativo? getSeleccionNivel(int nivel) {
if (nivel < 0) {
return null;
}

if (nivel < rutaSeleccionada.length) {
return rutaSeleccionada[nivel];
}

return null;
}

// =========================================================
// FINALIZADO
// =========================================================

bool get seleccionFinalizada {
/*
     * Si solo tenemos el padre automático,
     * todavía no existe selección del usuario.
     */
if (rutaSeleccionada.length <= 1) {
return false;
}

final DataTipoOperativo ultimo = rutaSeleccionada.last;

return !tieneHijos(ultimo.idGenTipoTipificacion);
}

DataTipoOperativo? get operativoFinal {
if (!seleccionFinalizada) {
return null;
}

return rutaSeleccionada.last;
}

// =========================================================
// LIMPIAR
// =========================================================

void limpiarTipoOperativo() {
/*
     * IMPORTANTE:
     *
     * Antes este método borraba rutaSeleccionada completamente.
     * Eso provocaba que el NIVEL 2 quedara sin padre y,
     * por consecuencia, getDatosNivel(1) devolviera [].
     *
     * Ahora reiniciamos la selección conservando automáticamente
     * el NIVEL 1.
     */
rutaSeleccionada.clear();

selectTipoOperativo.value = DataTipoOperativo.empty();

showContinuar.value = false;

if (listTipoOperativos.isNotEmpty) {
_seleccionarPadreAutomatico();
} else {
rutaSeleccionada.refresh();
}
}

// =========================================================
// LIMPIAR DESDE UN NIVEL
// =========================================================

void limpiarDesdeNivel(int nivel) {
/*
     * Nunca borramos el nivel 0 porque es el padre automático.
     */
if (nivel <= 0) {
limpiarTipoOperativo();
return;
}

showContinuar.value = false;

if (rutaSeleccionada.length > nivel) {
rutaSeleccionada.removeRange(nivel, rutaSeleccionada.length);
}

/*
     * Después de limpiar un combo del nivel 2 o superior,
     * el último elemento será su padre.
     *
     * El padre no debe considerarse todavía como operativo final
     * si tiene hijos.
     */
if (rutaSeleccionada.isNotEmpty) {
selectTipoOperativo.value = rutaSeleccionada.last;

final ultimo = rutaSeleccionada.last;

showContinuar.value =
rutaSeleccionada.length > 1 &&
!tieneHijos(ultimo.idGenTipoTipificacion);
} else {
/*
       * Seguridad adicional.
       * No debería ocurrir, pero restauramos el padre.
       */
_seleccionarPadreAutomatico();
}

rutaSeleccionada.refresh();
}

// =========================================================
// IR SIGUIENTE
// =========================================================

void gotToNextPage() {
final DataTipoOperativo operativo = selectTipoOperativo.value;
final String nombreModulo = dataModuloResponse.descripcion.trim();
final String nombreOperativo = operativo.descripcion.trim();

Get.toNamed(
_rutaPorModulo(),
arguments: <String, dynamic>{
'tipoOperativo': operativo,
'idOperativo': operativo.idOperativo,
'nombreModulo': nombreModulo,
'nombreOperativo': nombreOperativo,
},
);
}
}


