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
  final List<OpePersonaModelData> dataPersona;
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
            OpePersonaModelData data =this. dataPersona[0];
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
               wgAnt =   DesingAntWg(
                colorTitulos: colorTitulos,
                colorTexto: colorTexto,
                data: data.datosAnt.data,
              );
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

            //********************** desaparecidoDinased *****************************
            DesaparecidoDinasedData? dataDesaparecido =
            setDatosDesaparecidoDinased(data);


            Widget wgDesaparecido =dataDesaparecido!=null? DesingDesaparecidoDinasedWg(
              colorTitulos: colorTitulos,
              colorTexto: colorTexto,
              desaparecidoDinasedData: dataDesaparecido,
            ):const SizedBox.shrink();

            //**********************ALERTAS DNA*****************************
            AlertaDnaData? dataAlertaDNA =
            setDatosAlertaDna(data);
            Widget wgAlertaDna = dataAlertaDNA!=null? DesingAlertaDnaWg(
              colorTitulos: colorTitulos,
              colorTexto: colorTexto,
              data:dataAlertaDNA ,
            ):const SizedBox.shrink();

            //**********************PJ*****************************
            AlertaInmediataPjData? dataAlertaInmediata =
            setDatosAlertaPj(data);
            Widget wgAlertaInmediata = dataAlertaInmediata!=null?DesingAlertaPjWg(
                colorTitulos: colorTitulos,
                colorTexto: colorTexto,
                data: dataAlertaInmediata):const SizedBox.shrink();

            return Column(
              children: [
                wgDesaparecido,
                wgAlertaDna,
                wgAlertaInmediata,
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


  LocalPersonSuModel setDatosPersona(OpePersonaModelData data) {
    //**********************  BD SIIPNE *****************************
    DataSiipne dataSiipne = data.dataSiipne;
    DataDinardap dataDinardap = data.dataDinardap;
    String nombres = "SIN DATOS", fechaNacimiento = "", edad = "", sexo = "";
    String? foto = data.foto.success ? data.foto.fotoBase64 : null;
    String documento ="";
    String? pais;
    if (dataSiipne.success) {
      nombres = dataSiipne.data.apenom;
      pais = dataSiipne.data.pais;
      fechaNacimiento = dataSiipne.data.fechaNacimiento;
      sexo = dataSiipne.data.sexo;
      documento=dataSiipne.data.documento;
      Edad? _dataEdad = dataSiipne.data.edad;

      foto=dataSiipne.data.foto64;

      if (edad != null) {
        edad =
            "${_dataEdad!.anos} AÑOS -${_dataEdad.meses} MESES -${_dataEdad.dias} DIAS";
      }
    } else if (dataDinardap.success) {
      nombres = dataDinardap.data.nombre;
      sexo = dataDinardap.data.genero;
      fechaNacimiento = dataDinardap.data.fechaNacimiento;
      Edad? _dataEdad = dataDinardap.data.edad;
      if (edad != null) {
        edad =
            "${_dataEdad!.anos} AÑOS -${_dataEdad.meses} MESES -${_dataEdad.dias} DIAS";
      }
    }

    String? domicilio, estadoCivil, madre, padre, conyuge;
    if (dataDinardap.success) {
      documento = dataDinardap.data.cedula;
      domicilio = dataDinardap.data.domicilio;
      estadoCivil = dataDinardap.data.estadoCivil;
      madre = dataDinardap.data.nombreMadre;
      padre = dataDinardap.data.nombrePadre;
      String _conyugue = dataDinardap.data.conyuge;
      if (_conyugue.length > 5) {
        conyuge = _conyugue;
      }
    }

    if (dataDinardap.success) {
      if (dataDinardap.data != null) {
        if (dataDinardap.data.fotografia != null) {
          foto = dataDinardap.data.fotografia;
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

  LocalOrdenCapturaSuModel setDatosOrdenCaptura(OpePersonaModelData data) {
    String ordenCaptura_descripcion = "NO EXISTE";
    String ordenCaptura_documento = "";
    String ordenCaptura_oficio = "";
    if (data.ordenCaptura.success) {
      ordenCaptura_descripcion = data.ordenCaptura.data.juzgado;
      ordenCaptura_documento = data.ordenCaptura.data.documento;
      ordenCaptura_oficio = data.ordenCaptura.data.numoficio;
    }

    return LocalOrdenCapturaSuModel(
        documento: ordenCaptura_documento,
        juzgado: ordenCaptura_descripcion,
        oficio: ordenCaptura_oficio);
  }

  DesaparecidoDinasedData? setDatosDesaparecidoDinased(OpePersonaModelData data) {
    if (data.desaparecidoDinased.success) {
      DesaparecidoDinasedData dataDesaparecidos =
          data.desaparecidoDinased.data;
      return dataDesaparecidos;
    } else {
      return null;
    }
  }

  AlertaDnaData? setDatosAlertaDna(OpePersonaModelData data) {
    if (data.alertaDna.success) {
      return data.alertaDna.data;
    } else {
      return null;
    }
  }

  AlertaInmediataPjData? setDatosAlertaPj(OpePersonaModelData data) {
    if (data.alertaInmediataPj.success) {
      return data.alertaInmediataPj.data;
    } else {
      return null;
    }
  }


}
