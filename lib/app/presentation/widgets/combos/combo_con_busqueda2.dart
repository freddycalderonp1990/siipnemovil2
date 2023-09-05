part of '../custom_app_widgets.dart';


class ComboConBusqueda2 extends StatefulWidget {
  final List<ModelDataCombo> data;
  final ModelDataCombo? selectValue;
  final ValueChanged<ModelDataCombo>? complete;
  final String title;
  final String titleSelecioneEl;

  const ComboConBusqueda2(
      {Key? key,
        required this.data,
        this.selectValue,
        this.complete,
        this.titleSelecioneEl="Seleccione un valor...",
        this.title = ''})
      : super(key: key);


  @override
  State<ComboConBusqueda2> createState() => _ComboConBusqueda2State();
}

class _ComboConBusqueda2State extends State<ComboConBusqueda2> {


  List<ModelDataCombo> data_ = <ModelDataCombo>[];
  List<ModelDataCombo> dataFind = [];



  ModelDataCombo dataSelectCombo=ModelDataCombo(id: 0, titulo: "",imgUrl: null,imgString: null);
  ModelDataCombo dataSelect=ModelDataCombo(id: 0, titulo: "",imgUrl: null,imgString: null);


  RxString completeText ="Seleccione un valor..." .obs;

  @override
  Widget build(BuildContext context) {

    print("busca");

    completeText =widget.titleSelecioneEl .obs;

    if(widget.data==null){
      return Container();
    }

    data_ = widget.data.obs;
    dataFind = widget.data.obs;

    return getMenu();
  }

  List<ModelDataCombo>  filter(String value) {
    if (value.length > 0) {
      data_ = dataFind
          .where((element) =>
          element.titulo.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      data_ = dataFind;
    }
    setState(() {

    });
    return data_;

  }

  Widget desindContenido() {
    final responsive = ResponsiveUtil();





    Widget dataWg = Container(
      height: responsive.altoP(40),
      child: Column(
        children: [
          ImputTextWidget(
            hitText: 'Buscar...',
            onChanged: (value) {
              filter(value);
            },
          ),
          Expanded(
              child:  ListView.builder(
                  itemCount: data_.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    ModelDataCombo myData=data_[i];





                    dataSelectCombo=myData;


                    return Material(
                        borderRadius:
                        BorderRadius.circular(AppConfig.radioBotones),
                        child: InkWell(
                            onTap: () {
                              print(" print en el combo al seleccionar, ${data_[i].id}");
                              print(data_[i]);


                              completeText.value = data_[i].titulo;

                              dataSelect=myData;


                              if (widget.complete != null) {
                                print(" print en el combo al seleccionar - ddddddddddddddddddd");
                                widget.complete!(data_[i]);
                              }



                              setState(() {

                              });
                              Get.back();
                            },
                            borderRadius:
                            BorderRadius.circular(AppConfig.radioBotones),
                            child: Container(
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color:widget.selectValue==null?Colors.white: widget.selectValue! == data_[i]
                                        ? Colors.blueAccent
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.colorBordecajas,
                                          blurRadius: 1)
                                    ]),
                                child:getIcon(iconString: dataSelectCombo.imgString,iconUrl:dataSelectCombo.imgUrl,detalle: myData.titulo)  )));
                  }))
        ],
      ),
    );

    Widget contenido = new Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 5.0 + 16.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: EdgeInsets.only(top: 0),
          width: double.infinity,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16.0,
                offset: const Offset(0.0, 16.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: responsive.diagonalP(2.5),
                  fontWeight: FontWeight.w700,
                  color: AppColors.colorBordecajas,
                ),
              ),
              SizedBox(height: responsive.altoP(1)),
              dataWg != null ? dataWg : Container(),
              SizedBox(height: responsive.altoP(1)),
            ],
          ),
        ),
        Positioned(
          right: -20,
          top: -10,
          child: TextButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              label: Container()),
        ),
      ],
    );

    return contenido;
  }



  Widget getIcon({ String? iconUrl, String? iconString, required String detalle} ){

    Widget wgIconUrl=  iconUrl!=null? Container(
      height: 32,
      width: 32,
      child: CachedNetworkImage(
        imageUrl: iconUrl,
        imageBuilder: (context, imageProvider) =>
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        placeholder: (context, url) =>
            CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset(
              AppImages.iconMenu,
            ),
      ),
    ):Container();


    wgIconUrl=  Row(

        children: [
          wgIconUrl,
          detalle.length>0?  Flexible(
            child: DetalleTextWidget(
              detalle: detalle,
            ),
          ):Container()
        ]);


    String imgMostrar=iconString==null?AppImages.iconMenu:iconString;

    Widget wgIconString= detalle.length>0? IconDetalleWidget(
        nameStringImg:
        imgMostrar,
        detalle:detalle):OnlyIconWidget(nameStringImg: imgMostrar);


    return iconUrl!=null?wgIconUrl:wgIconString;


  }

  getDialogo() {
    filter('');
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) => new Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: desindContenido(),
      ),
    );
  }

  getMenu() {
    return Material(
        borderRadius: BorderRadius.circular(AppConfig.radioBotones),
        child: InkWell(
            onTap: () {
              getDialogo();
            },
            borderRadius: BorderRadius.circular(AppConfig.radioBotones),
            child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: AppColors.colorBordecajas,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.colorBordecajas, blurRadius: 1)
                    ]),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(10),
                    child:




                    Row(children: [
                    getIcon(iconString:dataSelect.imgString,iconUrl: dataSelect.imgUrl,detalle: "")  ,


                      Expanded(
                        child: Obx(() => DetalleTextWidget(
                          detalle: completeText.value,
                        )),
                      ),
                      Icon(Icons.expand_more_sharp)
                    ])))));
  }
}


