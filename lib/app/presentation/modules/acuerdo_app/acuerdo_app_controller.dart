part of '../controllers.dart';

class AcuerdoAppController extends GetxController {
  final loginController = Get.find<LoginController>();



  late UserEntities  user;




  RxBool peticionServerState = false.obs;



  /// Checkbox
  final RxBool acepta = false.obs;

  /// Se habilita cuando el usuario llega al final del texto
  final RxBool puedeAceptar = false.obs;

  /// Controlador del scroll
  final ScrollController scrollController = ScrollController();

  /// Texto del acuerdo
  final RxString textoAcuerdo = '''
Antes de ingresar al aplicativo SIIPNE Móvil, el usuario declara conocer y aceptar que el acceso, uso, consulta, registro, almacenamiento y tratamiento de la información contenida en este sistema se encuentra sujeto a la Constitución de la República del Ecuador, la Ley Orgánica de Protección de Datos Personales, su Reglamento General, la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos, el Código Orgánico Integral Penal, el Código Orgánico de las Entidades de Seguridad Ciudadana y Orden Público, y demás normativa legal e institucional vigente.

El aplicativo SIIPNE Móvil es de uso exclusivo para usuarios autorizados. La información consultada o registrada deberá utilizarse únicamente para fines institucionales, operativos, administrativos y legales relacionados con las competencias de la Policía Nacional del Ecuador.

El usuario declara conocer que toda información personal, institucional, operativa o reservada a la que acceda mediante este aplicativo debe ser tratada con estricta confidencialidad, responsabilidad, seguridad y reserva, quedando prohibida su divulgación, reproducción, alteración, captura, difusión, cesión o uso para fines particulares o no autorizados.

Asimismo, el usuario acepta que el sistema podrá registrar datos de acceso, fecha, hora, usuario, dispositivo, ubicación cuando corresponda, consultas realizadas y demás trazabilidad necesaria para fines de seguridad, control, auditoría, soporte técnico y cumplimiento normativo.

El uso indebido del aplicativo, la entrega de credenciales a terceros, el acceso no autorizado, la manipulación de información o la revelación ilegal de datos podrá generar responsabilidades administrativas, disciplinarias, civiles y penales, conforme a la normativa vigente.

Al seleccionar la opción "ACEPTO", declaro que he leído, comprendido y acepto las condiciones de uso del aplicativo SIIPNE Móvil, comprometiéndome a utilizarlo de manera legal, responsable, confidencial y exclusivamente para fines institucionales.
'''.obs;




  @override
  void onInit() async {
    user=loginController.user.value;

    _listenerScroll();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: Donde la vista ya se presento
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  cerrarSession() {
    Get.toNamed(AppRoutes.SPLASH_APP);
  }



  void _listenerScroll() {
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      if (puedeAceptar.value) return;

      final max = scrollController.position.maxScrollExtent;
      final actual = scrollController.position.pixels;

      if (actual >= max - 20) {
        puedeAceptar.value = true;
      }
    });
  }




  void continuar() {
    if (!acepta.value) {
      Get.snackbar(
        "Aviso",
        "Debe aceptar las condiciones para continuar.",
      );
      return;
    }

    Get.toNamed(SiipneMovilRoutes.MENU_APP);

    // Guardar aceptación
    // Navegar al menú principal
  }












}
