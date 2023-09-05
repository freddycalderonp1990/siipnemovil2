import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../../../app/core/values/app_colors.dart';
import '../../../../../core/siipne_config.dart';
import '../../../../../core/values/siipne_colors.dart';
import '../../../../../data/models/models.dart';
import 'operativo_polco_local_widgets.dart';

class DesingBusquedaPorCedulaWidget extends StatelessWidget {
  final List<PersonaModelData> dataPersona;

  const DesingBusquedaPorCedulaWidget({Key? key, required this.dataPersona})
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
    tieneOrdenCaptura ? Colors.white : Colors.black;
    Color colorTitulos =
    tieneOrdenCaptura ? Colors.yellow : Colors.blueAccent;
    Color colorFondo=tieneOrdenCaptura
        ? SiipneColors.colorOrdenCaptura
        : Colors.white.withOpacity(0.8);



    Widget wg = dataPersona.length > 0
        ? Container(
        padding: EdgeInsets.all(5),
        width: responsive.anchoP(95),
        height: responsive.altoP(55),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
          border:
          Border.all(color: AppColors.colorBordecajas, width: 0.5),
        ),
        child: ListView.builder(
          itemCount: dataPersona.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            PersonaModelData data =this. dataPersona[0];

            //********************** DATOS PERSON *****************************
            LocalPersonModel dataPersona = setDatosPersona(data);
            Widget wgDataPersona = DesingDatosPersonaWg(
              colorTitulos: colorTitulos,
              colorTexto: colorTexto,
              data: dataPersona,
            );
            //********************** ANT *****************************
            Widget wgAnt =  Container();
            if(data.datosAnt!=null){
              if(data.datosAnt.success){
                 wgAnt =   DesingAntWg(
                  colorTitulos: colorTitulos,
                  colorTexto: colorTexto,
                  data: data.datosAnt.data,
                );
              }
            }


            //********************** PJ ORDEN DE CAPTURA *****************************
            LocalOrdenCapturaModel dataOrdenCaptura =
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
            ):Container();

            //**********************ALERTAS DNA*****************************
            AlertaDnaData? dataAlertaDNA =
            setDatosAlertaDna(data);
            Widget wgAlertaDna = dataAlertaDNA!=null? DesingAlertaDnaWg(
              colorTitulos: colorTitulos,
              colorTexto: colorTexto,
              data:dataAlertaDNA ,
            ):Container();

            //**********************PJ*****************************
            AlertaInmediataPjData? dataAlertaInmediata =
            setDatosAlertaPj(data);
            Widget wgAlertaInmediata = dataAlertaInmediata!=null?DesingAlertaPjWg(
                colorTitulos: colorTitulos,
                colorTexto: colorTexto,
                data: dataAlertaInmediata):Container();

            return Column(
              children: [
                wgDesaparecido,
                wgAlertaDna,
                wgAlertaInmediata,
                wgDataPersona,
                wgOrdenCaptura,
                wgAnt,
              ],
            );
          },
        ))
        : Container();

    return wg;
  }
  
  
  

  LocalPersonModel setDatosPersona(PersonaModelData data) {
    //**********************  BD SIIPNE *****************************
    DataSiipne dataSiipne = data.dataSiipne;
    DataDinardap dataDinardap = data.dataDinardap;
    String nombres = "SIN DATOS", fechaNacimiento = "", edad = "", sexo = "";
    String? foto = data.foto.success ? data.foto.fotoBase64 : null;

    if (dataSiipne.success) {
      nombres = dataSiipne.data.apenom;
      fechaNacimiento = dataSiipne.data.fechaNacimiento;
      sexo = dataSiipne.data.sexo;
      Edad? _dataEdad = dataSiipne.data.edad;

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

    return LocalPersonModel(
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
    );
  }

  LocalOrdenCapturaModel setDatosOrdenCaptura(PersonaModelData data) {
    String ordenCaptura_descripcion = "NO EXISTE";
    String ordenCaptura_documento = "";
    String ordenCaptura_oficio = "";
    if (data.ordenCaptura.success) {
      ordenCaptura_descripcion = data.ordenCaptura.data.juzgado;
      ordenCaptura_documento = data.ordenCaptura.data.documento;
      ordenCaptura_oficio = data.ordenCaptura.data.numoficio;
    }

    return LocalOrdenCapturaModel(
        documento: ordenCaptura_documento,
        juzgado: ordenCaptura_descripcion,
        oficio: ordenCaptura_oficio);
  }

  DesaparecidoDinasedData? setDatosDesaparecidoDinased(PersonaModelData data) {
    if (data.desaparecidoDinased.success) {
      DesaparecidoDinasedData dataDesaparecidos =
          data.desaparecidoDinased.data;
      return dataDesaparecidos;
    } else {
      return null;
    }
  }

  AlertaDnaData? setDatosAlertaDna(PersonaModelData data) {
    if (data.alertaDna.success) {
      return data.alertaDna.data;
    } else {
      return null;
    }
  }

  AlertaInmediataPjData? setDatosAlertaPj(PersonaModelData data) {
    if (data.alertaInmediataPj.success) {
      return data.alertaInmediataPj.data;
    } else {
      return null;
    }
  }
}
