import 'package:get/get.dart';
import '../../../app/presentation/routes/app_pages.dart';
import '../../../app_elecciones/presentation/modules/bindings.dart';
import '../../../app_elecciones/presentation/modules/pages.dart';
import '../../../app_elecciones/presentation/routes/elecciones_routes.dart';

class EleccionesPages {
  static final List<GetPage> pages = [
    AppPages.getPageConfig(
        name: EleccionesRoutes.HOME,
        page: () => HomeEleccionesPage(),
        binding: HomeEleccionesBinding()),
    AppPages.getPageConfig(
        name: EleccionesRoutes.PROCESOS_OPERATIVOS,
        page: () => ProcesosOperativosEleccionesPage(),
        binding: ProcesosOperativosEleccionesBinding()),
    AppPages.getPageConfig(
        name: EleccionesRoutes.VERIFICAR_OPERATIVO_RECINTO_ABIERTO,
        page: () => VerificarOpertaivoRecintoAbiertoPage(),
        binding: VerificarOpertaivoRecintoAbiertoBinding()),
    AppPages.getPageConfig(
        name: EleccionesRoutes.TIPO_SERVICIOS_ELECCIONES,
        page: () => TipoServiciosPage(),
        binding: TipoServiciosBinding()),

    AppPages.getPageConfig(
        name: EleccionesRoutes.EJES_UNIDADES_POLICIALES,
        page: () => EjesUnidadesPolicialesPage(),
        binding: EjesUnidadesPolicialesBinding()),

    AppPages.getPageConfig(
        name: EleccionesRoutes.EJES_HIJOS,
        page: () => EjesHijosPage(),
        binding: EjesHijosBinding()),

    AppPages.getPageConfig(
        name: EleccionesRoutes.INSTALACIONES_RECINTOS_CERCANOS,
        page: () => InstalacionesPage(),
        binding: InstalacionesBinding()),

    AppPages.getPageConfig(
        name: EleccionesRoutes.MENU_JEFE,
        page: () => MenuJefePage(),
        binding: MenuJefeBinding()),

    AppPages.getPageConfig(
        name: EleccionesRoutes.NOVEDADES,
        page: () => NovedadesPage(),
        binding: NovedadesBinding()),
    AppPages.getPageConfig(
        name: EleccionesRoutes.ADD_PERSONAL,
        page: () => AddPersonalPage(),
        binding: AddPersonalBinding()),
    AppPages.getPageConfig(
        name: EleccionesRoutes.CONUSLTAR_PERSONAL_ASIGNADO,
        page: () => PersonalAsignadoPage(),
        binding: PersonalAsignadoBinding()),
  ];
}
