part of 'models.dart';

TestAntModel testAntModelFromJson(String str) => TestAntModel.fromJson(json.decode(str));

String testAntModelToJson(TestAntModel data) => json.encode(data.toJson());

class TestAntModel {
  TestAntModel({
     this.activoVig,
     this.anio,
     this.anioMatriculado,
     this.apellido1,
     this.apellido2,
     this.avaluoComercial,
     this.canvcp,
     this.carroceria,
     this.casaComercial,
     this.cedulaPropAnterior,
     this.chasis,
     this.cilindraje,
     this.claseServicio,
     this.claseTran,
     this.claseVehiculo,
     this.codMarca,
     this.codModelo,
     this.codTipoVehiculo,
     this.codError,
     this.color,
     this.color2,
     this.combustible,
     this.comprobante,
     this.contrato,
     this.correo,
     this.desdePcir,
     this.direccion,
     this.docPropietario,
     this.estado,
     this.estadoCon,
     this.estadoInf,
     this.estadoPcir,
     this.estadoSer,
     this.fechaCaducidad,
     this.fechaMatricula,
     this.fechaIniCon,
     this.hastaPcir,
     this.idAlterno,
     this.infraestructura,
     this.inicioPcir,
     this.inicioVig,
     this.marca,
     this.mensaje,
     this.modelo,
     this.motor,
     this.nombrePropAnterior,
     this.numEjes,
     this.numRuedas,
     this.numeroRevisado,
     this.numeroTraspaso,
     this.pais,
     this.pasajeros,
     this.placa,
     this.propietario,
     this.registroPcir,
     this.remarcadoChasis,
     this.remarcadoMotor,
     this.residencia,
     this.rucCooperativa,
     this.telefono,
     this.tipoIdent,
     this.tipoPeso,
     this.tipoVehiculo,
     this.tipoServicio,
     this.tonelaje,
  });

  String? activoVig;
  String? anio;
  String? anioMatriculado;
  String? apellido1;
  String? apellido2;
  String? avaluoComercial;
  String? canvcp;
  String? carroceria;
  String? casaComercial;
  String? cedulaPropAnterior;
  String? chasis;
  String? cilindraje;
  String? claseServicio;
  String? claseTran;
  String? claseVehiculo;
  String? codMarca;
  String? codModelo;
  String? codTipoVehiculo;
  String? codError;
  String? color;
  String? color2;
  String? combustible;
  String? comprobante;
  String? contrato;
  String? correo;
  String? desdePcir;
  String? direccion;
  String? docPropietario;
  String? estado;
  String? estadoCon;
  String? estadoInf;
  String? estadoPcir;
  String? estadoSer;
  String? fechaCaducidad;
  String? fechaMatricula;
  String? fechaIniCon;
  String? hastaPcir;
  String? idAlterno;
  String? infraestructura;
  String? inicioPcir;
  String? inicioVig;
  String? marca;
  String? mensaje;
  String? modelo;
  String? motor;
  String? nombrePropAnterior;
  String? numEjes;
  String? numRuedas;
  String? numeroRevisado;
  String? numeroTraspaso;
  String? pais;
  String? pasajeros;
  String? placa;
  String? propietario;
  String? registroPcir;
  String? remarcadoChasis;
  String? remarcadoMotor;
  String? residencia;
  String? rucCooperativa;
  String? telefono;
  String? tipoIdent;
  String? tipoPeso;
  String? tipoVehiculo;
  String? tipoServicio;
  String? tonelaje;

  factory TestAntModel.fromJson(Map<String, dynamic> json) => TestAntModel(
    activoVig: json["activo_vig"],
    anio: json["anio"],
    anioMatriculado: json["anio_Matriculado"],
    apellido1: json["apellido1"],
    apellido2: json["apellido2"],
    avaluoComercial: json["avaluoComercial"],
    canvcp: json["canvcp"],
    carroceria: json["carroceria"],
    casaComercial: json["casaComercial"],
    cedulaPropAnterior: json["cedulaPropAnterior"],
    chasis: json["chasis"],
    cilindraje: json["cilindraje"],
    claseServicio: json["claseServicio"],
    claseTran: json["claseTran"],
    claseVehiculo: json["claseVehiculo"],
    codMarca: json["codMarca"],
    codModelo: json["codModelo"],
    codTipoVehiculo: json["codTipoVehiculo"],
    codError: json["cod_error"],
    color: json["color"],
    color2: json["color2"],
    combustible: json["combustible"],
    comprobante: json["comprobante"],
    contrato: json["contrato"],
    correo: json["correo"],
    desdePcir: json["desde_pcir"],
    direccion: json["direccion"],
    docPropietario: json["doc_Propietario"],
    estado: json["estado"],
    estadoCon: json["estado_con"],
    estadoInf: json["estado_inf"],
    estadoPcir: json["estado_pcir"],
    estadoSer: json["estado_ser"],
    fechaCaducidad: json["fechaCaducidad"],
    fechaMatricula: json["fechaMatricula"],
    fechaIniCon: json["fecha_ini_con"],
    hastaPcir: json["hasta_pcir"],
    idAlterno: json["idAlterno"],
    infraestructura: json["infraestructura"],
    inicioPcir: json["inicio_pcir"],
    inicioVig: json["inicio_vig"],
    marca: json["marca"],
    mensaje: json["mensaje"],
    modelo: json["modelo"],
    motor: json["motor"],
    nombrePropAnterior: json["nombrePropAnterior"],
    numEjes: json["numEjes"],
    numRuedas: json["numRuedas"],
    numeroRevisado: json["numeroRevisado"],
    numeroTraspaso: json["numeroTraspaso"],
    pais: json["pais"],
    pasajeros: json["pasajeros"],
    placa: json["placa"],
    propietario: json["propietario"],
    registroPcir: json["registro_pcir"],
    remarcadoChasis: json["remarcadoChasis"],
    remarcadoMotor: json["remarcadoMotor"],
    residencia: json["residencia"],
    rucCooperativa: json["ruc_Cooperativa"],
    telefono: json["telefono"],
    tipoIdent: json["tipoIdent"],
    tipoPeso: json["tipoPeso"],
    tipoVehiculo: json["tipoVehiculo"],
    tipoServicio: json["tipo_Servicio"],
    tonelaje: json["tonelaje"],
  );

  Map<String, dynamic> toJson() => {
    "activo_vig": activoVig,
    "anio": anio,
    "anio_Matriculado": anioMatriculado,
    "apellido1": apellido1,
    "apellido2": apellido2,
    "avaluoComercial": avaluoComercial,
    "canvcp": canvcp,
    "carroceria": carroceria,
    "casaComercial": casaComercial,
    "cedulaPropAnterior": cedulaPropAnterior,
    "chasis": chasis,
    "cilindraje": cilindraje,
    "claseServicio": claseServicio,
    "claseTran": claseTran,
    "claseVehiculo": claseVehiculo,
    "codMarca": codMarca,
    "codModelo": codModelo,
    "codTipoVehiculo": codTipoVehiculo,
    "cod_error": codError,
    "color": color,
    "color2": color2,
    "combustible": combustible,
    "comprobante": comprobante,
    "contrato": contrato,
    "correo": correo,
    "desde_pcir": desdePcir,
    "direccion": direccion,
    "doc_Propietario": docPropietario,
    "estado": estado,
    "estado_con": estadoCon,
    "estado_inf": estadoInf,
    "estado_pcir": estadoPcir,
    "estado_ser": estadoSer,
    "fechaCaducidad": fechaCaducidad,
    "fechaMatricula": fechaMatricula,
    "fecha_ini_con": fechaIniCon,
    "hasta_pcir": hastaPcir,
    "idAlterno": idAlterno,
    "infraestructura": infraestructura,
    "inicio_pcir": inicioPcir,
    "inicio_vig": inicioVig,
    "marca": marca,
    "mensaje": mensaje,
    "modelo": modelo,
    "motor": motor,
    "nombrePropAnterior": nombrePropAnterior,
    "numEjes": numEjes,
    "numRuedas": numRuedas,
    "numeroRevisado": numeroRevisado,
    "numeroTraspaso": numeroTraspaso,
    "pais": pais,
    "pasajeros": pasajeros,
    "placa": placa,
    "propietario": propietario,
    "registro_pcir": registroPcir,
    "remarcadoChasis": remarcadoChasis,
    "remarcadoMotor": remarcadoMotor,
    "residencia": residencia,
    "ruc_Cooperativa": rucCooperativa,
    "telefono": telefono,
    "tipoIdent": tipoIdent,
    "tipoPeso": tipoPeso,
    "tipoVehiculo": tipoVehiculo,
    "tipo_Servicio": tipoServicio,
    "tonelaje": tonelaje,
  };
}
