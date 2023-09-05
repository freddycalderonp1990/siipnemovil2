part of '../pages.dart';

class NovedadesPage extends GetView<NovedadesController> {
  const NovedadesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
          btnAtras: true,
          imgPerfil: controller.loginController.user.value.foto.fotoBase64,
          name: controller.loginController.getName(),
          title: "NOVEDADES",
          peticionServer: controller.peticionServer,
          contenido: getContenido(),
        ));
  }

  Widget getContenido() {
    return SingleChildScrollView(
      child: Column(
        children: [
          getComboPadre(),
          SizedBox(
            height: 10,
          ),
          getComboNovedadesHijas(),
          SizedBox(
            height: 10,
          ),
          contenidoNovedadesBtn()
        ],
      ),
    );
  }

  Widget contenidoNovedadesBtn() {
    return Obx(() => controller.dataSelectNovedadesHijas.value.titulo.length > 0
        ? Column(
            children: [
              Obx(
                () => novedadesWidgets(
                    controller.dataSelectNovedades.value.titulo,
                    idNovedadesHijas:
                        controller.dataSelectNovedadesHijas.value.id),
              ),
              SizedBox(
                height: 10,
              ),
              BtnIconWidget(
                select: true,
                stringImg: AppImages.iconGuardar,
                titulo: "GUARDAR",
                onPressed: () {
                  controller.registrarNovedades();
                },
              )
            ],
          )
        : Container());
  }

  Widget getComboPadre() {
    return Obx(
      () => ComboConBusqueda(
          selectValue: controller.dataSelectNovedades,
          data: controller.dataComboNovedades.value,
          complete: (data) {
            controller.dataSelectNovedades.value = data;

            controller.consultarNovedadesHijas(idNovedadesPadre: data.id);
          }),
    );
  }

  Widget getComboNovedadesHijas() {
    return Obx(
      () => ComboConBusqueda(
          selectValue: controller.dataSelectNovedadesHijas,
          data: controller.dataComboNovedadesHijas.value,
          complete: (data) {
            controller.dataSelectNovedadesHijas.value = data;
          }),
    );
  }

  Widget novedadesWidgets(String novedadesPadres, {int idNovedadesHijas = 0}) {
    double sizeIcons = 20;
    controller.validarForm = false;
    controller.mostrarFoto = false;

    Widget wg = Container();

    switch (novedadesPadres.trim().toUpperCase()) {
      case "NOVEDADES":
        wg = wgCajasTextoNovedades(idNovedadesHijas);
        break;
      case "DELITOS":
        controller.validarForm = true;
        wg = FormDelitosWidget(
          sizeIcons: sizeIcons,
          formKey: controller.formKey,
          controllerCedula: controller.controllerCedula,
        );
        break;
      case "DETENIDOS":
        controller.validarForm = true;
        wg = FormDetenidosWidget(
            formKey: controller.formKey,
            controllerNumBoleta: controller.controllerNumBoleta,
            sizeIcons: sizeIcons,
            controllerCedula: controller.controllerCedula);
        break;
      case "CITACIONES":
        controller.validarForm = true;
        wg = FormCitacionesWidget(
            controllerNumCitacion: controller.controllerNumCitacion,
            controllerCedula: controller.controllerCedula,
            sizeIcons: sizeIcons,
            formKey: controller.formKey);
        break;

      case "UMO":
        //mostrarFoto = true;

        //wg = wgTxtCedulaCitacion(responsive);
        break;

      default:
        wg = Container();
    }

    wg = ContenedorDesingWidget(paddin: EdgeInsets.all(5), child: wg);

    if (controller.mostrarFoto) {
      wg = Column(
        children: [
          wg,
          wgFoto(),
        ],
      );
    }

    return wg;
  }

  Widget wgCajasTextoNovedades(int idDgoNovedadesElect) {
    final responsive=ResponsiveUtil();

    Widget wg = Container();
    controller.validarForm = false;
    controller.mostrarFoto = false;
    double sizeIcons = 20;

    print("idDgoNovedadesElectHija = ${idDgoNovedadesElect}");

    Widget separacion = SizedBox(
      height: 10,
    );

    switch (idDgoNovedadesElect) {

      case 17:
        //1. RECINTOS ELECTORALES INSTALADOS        wg = Container();

        break;
      case 18:
        //2. RECINTOS ELECTORALES NO INSTALADOS
        wg = Container();

        break;
      case 19:
        //3. RECINTO ELECTORAL INSTALADO CON RETARDO POR DIFERENTES CAUSAS

        wg =txtFormHora(sizeIcons);
        controller.validarForm = true;

        break;
      case 20:
        //4. RECINTOS ELECTORALES SUSPENDIDO POR DIFERENTES CAUSAS
        wg = FormMotivoWidget(
            formKey: controller.formKey,
            controllerMotivo: controller.controllerMotivo,
            sizeIcons: sizeIcons);
        controller.validarForm = true;
        controller.mostrarFoto = true;
        break;
      case 21:
        //5. AGRESIONES A SERVIDORES POLICIALES
        wg = FormCedulaWidget(
            formKey: controller.formKey,
            controllerCedula: controller.controllerCedula,
            sizeIcons: sizeIcons);
        controller.validarForm = true;
        controller.mostrarFoto = true;
        break;
      case 22:
        //6. PRESENCIA DE MANIFESTANTES / CONCENTRACIONES / MARCHAS
        wg = Column(
          children: [
            FormNumManifestantesWidget(
                formKey: controller.formKey,
                controllerOrganizacion: controller.controllerOrganizacion,
                controllerDirigente: controller.controllerDirigente,
                controllerCantidad: controller.controllerCantidad,
                sizeIcons: sizeIcons),
            separacion,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BtnColoresNovedadesWidget(
                      color: Colors.green.withOpacity(0.8), title: "1-50"),
                  BtnColoresNovedadesWidget(
                      color: Colors.yellow.withOpacity(0.8), title: "51-200"),
                  BtnColoresNovedadesWidget(
                      color: Colors.orange.withOpacity(0.8), title: "201-500"),
                  BtnColoresNovedadesWidget(
                      color: Colors.red.withOpacity(0.8), title: "501-Más"),
                ],
              ),
            )
          ],
        );
        controller.validarForm = true;
        controller.mostrarFoto = true;
        break;
      case 23:
        //7. QUEMA DE URNAS / PAPELETAS
        controller.validarForm = true;
        controller.mostrarFoto = true;
        wg = Column(
          children: [
            FormQuemaUrnasWidget(
                formKey: controller.formKey,
                controllerOrganizacion: controller.controllerOrganizacion,
                controllerDirigente: controller.controllerDirigente,
                controllerCantidad: controller.controllerCantidad,
                sizeIcons: sizeIcons),
            separacion,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BtnColoresNovedadesWidget(
                      color: Colors.green.withOpacity(0.8), title: "1-50"),
                  BtnColoresNovedadesWidget(
                      color: Colors.yellow.withOpacity(0.8), title: "51-200"),
                  BtnColoresNovedadesWidget(
                      color: Colors.orange.withOpacity(0.8), title: "201-500"),
                  BtnColoresNovedadesWidget(
                      color: Colors.red.withOpacity(0.8), title: "501-Más"),
                ],
              ),
            )
          ],
        );
        break;
      case 28:
        //8. TOMA DE RECINTOS / DELEGACIONES / BODEGAS / INSTALACIONES DEL CNE
        controller.validarForm = true;
        controller.mostrarFoto = true;
        wg = Column(
          children: [
            FormTomaRecintosWidget(
                formKey: controller.formKey,
                controllerOrganizacion: controller.controllerOrganizacion,
                controllerDirigente: controller.controllerDirigente,
                controllerCantidad: controller.controllerCantidad,
                sizeIcons: sizeIcons),
            separacion,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BtnColoresNovedadesWidget(
                      color: Colors.green.withOpacity(0.8), title: "1-50"),
                  BtnColoresNovedadesWidget(
                      color: Colors.yellow.withOpacity(0.8), title: "51-200"),
                  BtnColoresNovedadesWidget(
                      color: Colors.orange.withOpacity(0.8), title: "201-500"),
                  BtnColoresNovedadesWidget(
                      color: Colors.red.withOpacity(0.8), title: "501-Más"),
                ],
              ),
            )
          ],
        );
        break;
      case 29:
        //9. PRESENCIA DE VENTAS AMBULANTES
        wg = Container();
        controller.mostrarFoto = true;

        break;
      case 30:
        //10. ATENCIÓN MÉDICA POR DIFERENTES CAUSAS
        controller.validarForm = true;
        controller.mostrarFoto = true;
        wg = txtFormCedulaTelefono(sizeIcons);
        break;
      case 31:
        //11. SERVIDORES POLICIALES INFECTADOS (SOSPECHA/POSITIVO)

        controller.validarForm = true;

        wg = txtFormCedulaTelefono(sizeIcons);

        break;

      case 32:
        //NUMÉRICO DE ACÉMILAS
        wg = wgTxtNumerico(sizeIcons);
        controller.validarForm = true;
        break;

      /*********************** UMO ***************************************/
      case 33:
        //1. NUMERICO DE PERSONAL
        wg = FormNumericoPersonalWidget(
            formKey: controller.formKey,
            controllerNumericoPersonal: controller.controllerNumericoPersonal,
            sizeIcons: sizeIcons);
        controller.validarForm = true;
        controller.validarForm = true;
        break;
      case 34:
        //2. PLANTONES
        wg = wgorganizacionDirigenteCantidad(sizeIcons);

        controller.validarForm = true;
        controller.validarForm = true;
        break;
      case 35:
        //3. MARCHAS
        wg = wgorganizacionDirigenteCantidad(sizeIcons);

        controller.validarForm = true;
        controller.validarForm = true;
        break;

      case 36:
        //4. CIERRE DE VIAS
        wg = wgorganizacionDirigenteCantidad(sizeIcons);

        controller.validarForm = true;
        controller.validarForm = true;
        break;

      case 37:
        //5. TOMA DE ENTIDADES

        wg = wgorganizacionDirigenteCantidad(sizeIcons);

        controller.validarForm = true;
        controller.validarForm = true;
        break;

      /************************AEREOPOLCIAL*************************************/
      case 45:
        //1. DESPLAZAMIENTO DE AUTORIDADES
         wg = wgTxtDesplazamientosAutoridades(sizeIcons);
        controller.validarForm = true;

        break;
      case 46:
        //2. DESPLAZAMIENTO DE SERVIDORES PÚBLICOS
        wg = wgTxtDesplazamientosAutoridades(sizeIcons);
        controller.validarForm = true;

        break;

      case 47:
        //3. APOYO AÉREO A MEDIOS DE COMUNICACIÓN
        wg = wgTxtApoyoMediosComunicacion(responsive,sizeIcons);
        controller.validarForm = true;

        break;

      /************************GOE - GIR*************************************/
      case 41:
        //1. SEGURIDAD DE PERSONAS IMPORTANTES
         wg = wgTxtSeguridadPersonasImportantes(responsive,sizeIcons);
        controller.validarForm = true;

        break;
      case 42:
        //2. SEGURIDAD DE INSTALACIONES
        //  wg = wgTxtSeguridadInstalaciones(responsive);
        controller.validarForm = true;
        controller.mostrarFoto = true;

        break;

      case 43:
        //3. REGISTRO DE EXPLOSIVOS
        //wg = wgTxtExplosivos(responsive);
        controller.validarForm = true;
        controller.mostrarFoto = true;

        break;

      case 44:
        //4. APOYO A UNIDADES POLICIALES
        //  wg = wgTxtApoyoUnidadesPoliciales(responsive);
        controller.validarForm = true;

        break;

      /************************CARCK - UMO - UER*************************************/
      case 49:
        //AGLOMERACIONES
        wg = wgTxtNumerico(sizeIcons);
        controller.validarForm = true;

        break;
      case 50:
        //NUMÉRICO DE ACÉMILAS
        wg = wgTxtNumerico(sizeIcons);
        controller.validarForm = true;

        break;

      case 51:
        //NUMÉRICO DE CANES
        wg = wgTxtNumerico(sizeIcons);
        controller.validarForm = true;

        break;

      case 52:
        //PERSONAL ESTÁTICO
        wg = wgTxtNumerico(sizeIcons);
        controller.validarForm = true;
        break;
      case 53:
        //PERSONAL MÓVIL
        wg = wgTxtNumerico(sizeIcons);
        controller.validarForm = true;

        break;

      case 54:
        //INICIA SERVICIO

        wg =txtFormHora(sizeIcons);
        controller.validarForm = true;
        break;
      case 55:
        //FINALIZA SERVICIO

        wg =txtFormHora(sizeIcons);
        controller.validarForm = true;

        break;

      default:
        print('idDgoNovedadesElect');

        controller.validarForm = false;
        controller.mostrarFoto = false;
        wg = Container();
    }

    return wg;
  }

  Widget wgFoto() {
    final responsive = ResponsiveUtil();
    Widget wgSolicitarFoto = Column(
      children: [
        controller.mGaleryCameraModel == null
            ? TituloTextWidget(
                title: "Selecciona una Imagen",
              )
            : TituloTextWidget(
                title: "Cambiar la Imagen",
              ),
        SizedBox(
          height: responsive.altoP(1),
        ),
        Material(
            child: InkWell(
          onTap: () {
            DialogosDesingWidget.selectPicture(Get.context!, onTapCamara: () {
              controller.getImageCamera();
              Navigator.of(Get.context!).pop();
            }, onTapGalery: () {
              controller.getImageGallery();
              Navigator.of(Get.context!).pop();
            });
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(AppImages.icon_camara,
                  width: responsive.altoP(6.0)),
            ),
          ),
        )),
        controller.imageFile.length == 0
            ? Container()
            : ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.file(
                  controller.imageFile.value[0]!,
                  fit: BoxFit.fill,
                  height: responsive.altoP(30.0),
                  width: responsive.altoP(34.0),
                )),
        SizedBox(
          height: responsive.altoP(1),
        ),
      ],
    );

    Widget wg = wgSolicitarFoto;

    return ContenedorDesingWidget(margin: EdgeInsets.only(top: 10), child: wg);
  }

  Widget wgTxtDesplazamientosAutoridades(double sizeIcons) {
    return FormDesplazamientoAutoridadesWidget(
        formKey:controller. formKey,
        controllerNombre:controller. controllerNombre,
        controllerCargo: controller.controllerCargo,
        controllerGrado: controller. controllerGrado,
        sizeIcons: sizeIcons);
  }

  Widget wgorganizacionDirigenteCantidad(double sizeIcons){
    return   FormOrganisacionesDirigentesCantidadWidget(
        formKey: controller.formKey,
        controllerOrganizacion: controller.controllerOrganizacion,
        controllerDirigente: controller.controllerDirigente,
        controllerCantidad: controller.controllerCantidad,
        sizeIcons: sizeIcons);;
  }

  Widget wgTxtNumerico(double sizeIcons){
   return FormNumericoWidget(
        formKey: controller.formKey,
        controllerNumerico: controller.controllerNumerico,
        sizeIcons: sizeIcons);
  }

  Widget txtFormHora(double sizeIcons){
    return FormHora(
        formKey: controller.formKey,
        controllerHora: controller.controllerHora,
        completeMinuto: (minuto) {
          controller.controllerHora.text = minuto;
        },
        completeHora: (hora) {
          controller.controllerHora.text = hora;
        },
        controllerMinuto: controller.controllerMinuto);
  }

  Widget txtFormCedulaTelefono(double sizeIcons){
    return FormCedulaTelefonoWidget(
        formKey: controller.formKey,
        controllerCedula: controller.controllerCedula,
        sizeIcons: sizeIcons,
        titleCedula: AppEleccionesStrings.cedulaSP,
        controllerTelefono: controller.controllerTelefono);

  }

  Widget wgTxtApoyoMediosComunicacion(responsive,sizeIcons) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controller.controllerNombre,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Nombre",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateNombre,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller:controller. controllerMedioComunicacion,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Medio de Comunicación",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateMedioComunicacion,
          ),
        ],
      ),
    );
  }

  Widget wgTxtSeguridadPersonasImportantes(responsive,sizeIcons) {
    return Form(
      key: controller. formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller:controller. controllerFuncion,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Función",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateFuncion,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controller.controllerNombre,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Nombres",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar: ValidateNovedades.validateNombre,
          ),
        ],
      ),
    );
  }
}
