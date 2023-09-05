part of '../pages.dart';

class HomeAppPage extends GetView<HomeAppController> {
  HomeAppPage({Key? key}) : super(key: key);

  RxList<ModelDataCombo> data = <ModelDataCombo>[
    ModelDataCombo(id: 1, titulo: 'titulo'),
    ModelDataCombo(id: 2, titulo: 'titulo2'),
    ModelDataCombo(id: 3, titulo: 'titulo3')
  ].obs;

  Rx<ModelDataCombo> selectvalue = ModelDataCombo(id: 1, titulo: 'titulo').obs;

  @override
  Widget build(BuildContext context) {

    List<Widget> a=[];



    return WorkAreaPageAppWidget(

        name: controller.loginController.getName(),
        imgPerfil: controller.loginController.user.value.foto.fotoBase64,
        title: "MODULOS",
        peticionServer: controller.peticionServer,
        contenido: Container(
          padding: EdgeInsets.all(5),
          child:
        ListView.builder(
              itemCount: modulosHome().length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                Widget data = modulosHome()[i];

                return Column(
                  children: [
                    data,
                    SizedBox(
                      height: 5,
                    )
                  ],
                );
              })



        ));
  }


  List<Widget> modulosHome(){
    return [
      BtnMenuImgWidget(
        title: "Elecciones",
        onTap: () {
          controller.getPageElecciones();
        },
        img: AppEleccionesImages.iconElecciones,
      ),
      SizedBox(
        height: 10,
      ),
      BtnMenuImgWidget(
        title: "SIIPNE",
        onTap: () {
          controller.getPageSiipne();
        },
        img: SiipneImages.iconSiipneMovil,
      ),
      SizedBox(
        height: 10,
      ),
    ];

  }


}
