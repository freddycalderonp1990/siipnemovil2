import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../app/core/app_config.dart';
import '../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../../app/core/values/app_colors.dart';
import '../../../../data/models/models_siipne_movil.dart';
import 'btnIconOperativoWidget.dart';
import 'colors_local.dart';
import 'operativo_polco_local_widgets.dart';

class DesingBusquedaPorCedulaWidget extends StatelessWidget {
  final List<DataConsultaPersona> dataPersona;
  final VoidCallback? onPressedAceptar;

  const DesingBusquedaPorCedulaWidget({Key? key, required this.dataPersona, this.onPressedAceptar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getMuestraDatosPersona();
  }



  getMuestraDatosPersona() {

    final responsive = ResponsiveUtil();

    bool tieneOrdenCaptura = false;
    if(dataPersona.length > 0){
      if (dataPersona[0].ordenCaptura != null) {
        if (dataPersona[0].ordenCaptura.success) {
          tieneOrdenCaptura=true;
        }
      }
    }

    Color colorTexto =
    tieneOrdenCaptura ? ColorsLocal.colorTextoOrdenCaptura : ColorsLocal.colorTextoNormal;
    Color colorTitulos =
    tieneOrdenCaptura ? ColorsLocal.colorTitulosOrdenCaptura: ColorsLocal.colorTitulosNormal;
    Color colorFondo=tieneOrdenCaptura
        ? ColorsLocal.colorFondoOrdenCaptura
        : ColorsLocal.colorFondoNormal;
    Widget wg = dataPersona.length > 0
        ? Container(
        padding: EdgeInsets.all(5),
        width: responsive.anchoP(95),
        height: responsive.altoP(55),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
          border:
          Border.all(color: AppColors.colorBordecajas, width: 0.5),
        ),
        child: ListView.builder(
          itemCount: dataPersona.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            DataConsultaPersona data =this. dataPersona[0];
            //********************** DATOS PERSON *****************************
            LocalPersonSuModel dataPersona = setDatosPersona(data);
            Widget wgDataPersona = DesingDatosPersonaWg(
              colorTitulos: colorTitulos,
              colorTexto: colorTexto,
              data: dataPersona,
            );
            //********************** ANT *****************************
            Widget wgAnt =  const SizedBox.shrink();
            if(data.datosAnt.success){
              //comentado por que faklta el servico web aun
               /*wgAnt =   DesingAntWg(
                colorTitulos: colorTitulos,
                colorTexto: colorTexto,
                data: data.datosAnt.data,
              );*/
            }


            //********************** PJ ORDEN DE CAPTURA *****************************
            LocalOrdenCapturaSuModel dataOrdenCaptura =
            setDatosOrdenCaptura(data);


            Widget wgOrdenCaptura = DesingOrdenCapturaWg(
              colorTitulos: colorTitulos,
              colorTexto: colorTexto,
              juzgado: dataOrdenCaptura.juzgado,
              documento: dataOrdenCaptura.documento,
              oficio: dataOrdenCaptura.oficio,
            );




            return Column(
              children: [

                wgDataPersona,
                wgOrdenCaptura,
                wgAnt,
                SizedBox(height: 10,),
                BtnIconOperativoWidget(
                  colorTxt: Colors.white,
                  select: true,
                  icon: Icons.check_circle,
                  colorIcon: Colors.white,
                  titulo: "Aceptar",
                  onPressed: onPressedAceptar,
                ),
              ],
            );
          },
        ))
        : const SizedBox.shrink();

    return wg;
  }


  LocalPersonSuModel setDatosPersona(DataConsultaPersona data) {
    //**********************  BD SIIPNE *****************************
    DataSiipne dataSiipne = data.dataSiipne;
    DataDinardap dataDinardap = data.dataDinardap;
    String nombres = "SIN DATOS", fechaNacimiento = "", edad = "", sexo = "";
    String? foto = data.dataSiipne.datosSiipne.foto64;
    String documento ="";
    String? pais;
    if (dataSiipne.success) {
      nombres = dataSiipne.datosSiipne.apenom;
      pais = dataSiipne.datosSiipne.pais;
      fechaNacimiento = dataSiipne.datosSiipne.fechaNacimiento;
      sexo = dataSiipne.datosSiipne.sexo;
      documento=dataSiipne.datosSiipne.documento;
      Edad? _dataEdad = dataSiipne.datosSiipne.edad;

      foto=dataSiipne.datosSiipne.foto64;

      if (edad != null) {
        edad =
            "${_dataEdad!.anos} AÑOS -${_dataEdad.meses} MESES -${_dataEdad.dias} DIAS";
      }
    } else if (dataDinardap.success) {
      nombres = dataDinardap.datosDinardap.nombre;
      sexo = dataDinardap.datosDinardap.genero;
      fechaNacimiento = dataDinardap.datosDinardap.fechaNacimiento;
      Edad? _dataEdad = dataDinardap.datosDinardap.edad;
      if (edad != null) {
        edad =
            "${_dataEdad!.anos} AÑOS -${_dataEdad.meses} MESES -${_dataEdad.dias} DIAS";
      }
    }

    String? domicilio, estadoCivil, madre, padre, conyuge;
    if (dataDinardap.datosDinardap!=null) {
      documento = dataDinardap.datosDinardap.cedula;
      domicilio = dataDinardap.datosDinardap.domicilio;
      estadoCivil = dataDinardap.datosDinardap.estadoCivil;
      madre = dataDinardap.datosDinardap.nombreMadre;
      padre = dataDinardap.datosDinardap.nombrePadre;
      String _conyugue = dataDinardap.datosDinardap.conyuge;
      if (_conyugue.length > 5) {
        conyuge = _conyugue;
      }
    }

    if (dataDinardap.success) {
      if (dataDinardap.datosDinardap != null) {
        if (dataDinardap.datosDinardap.fotografia != null) {
          foto = dataDinardap.datosDinardap.fotografia;
        }
      }
    }
    print("tengo foto en $foto");

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
      pais:pais
    );
  }

  LocalOrdenCapturaSuModel setDatosOrdenCaptura(DataConsultaPersona data) {
    String ordenCaptura_descripcion = "NO EXISTE";
    String ordenCaptura_documento = "";
    String ordenCaptura_oficio = "";
    if (data.ordenCaptura.success) {
      ordenCaptura_descripcion = data.ordenCaptura.datosCaptura.juzgado;
      ordenCaptura_documento = data.ordenCaptura.datosCaptura.documento;
      ordenCaptura_oficio = data.ordenCaptura.datosCaptura.numoficio;
    }

    return LocalOrdenCapturaSuModel(
        documento: ordenCaptura_documento,
        juzgado: ordenCaptura_descripcion,
        oficio: ordenCaptura_oficio);
  }





}
