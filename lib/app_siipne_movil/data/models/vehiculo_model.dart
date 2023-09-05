part of 'models.dart';

class VehiculoModel {
  VehiculoModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataVehiculo,
  });

  bool success;
  int statusCode;
  String message;
  DataVehiculo dataVehiculo;

  factory VehiculoModel.fromJson(String str) =>
      VehiculoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VehiculoModel.fromMap(Map<String, dynamic> json) =>
      VehiculoModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataVehiculo: DataVehiculo.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success == null ? null : success,
        "status_code": statusCode == null ? null : statusCode,
        "message": message == null ? null : message,
        "data": dataVehiculo == null ? null : dataVehiculo.toMap(),
      };
}

class DataVehiculo {
  DataVehiculo({
    required this.idHdrEventoResum,
    required this.datosVehiculoSiipne,
    required this.datosVehiculoAnt,
    required this.restriccionPj,
  });

  int idHdrEventoResum;
  DatosVehiculoSiipne datosVehiculoSiipne;
  DatosVehiculoAnt datosVehiculoAnt;
  RestriccionPj restriccionPj;

  factory DataVehiculo.fromJson(String str) =>
      DataVehiculo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataVehiculo.fromMap(Map<String, dynamic> json) =>
      DataVehiculo(
        idHdrEventoResum: ParseModel.parseToInt(json["idHdrEventoResum"]),
        datosVehiculoSiipne: json["datosVehiculoSiipne"] == null
            ? DatosVehiculoSiipne.empty()
            : DatosVehiculoSiipne.fromMap(json["datosVehiculoSiipne"]),
        datosVehiculoAnt: json["datosVehiculoANT"] == null
            ? DatosVehiculoAnt.empty()
            : DatosVehiculoAnt.fromMap(json["datosVehiculoANT"]),
        restriccionPj: json["restriccionPJ"] == null
            ? RestriccionPj.empty()
            : RestriccionPj.fromMap(json["restriccionPJ"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "idHdrEventoResum":  idHdrEventoResum,
        "datosVehiculoSiipne":
        datosVehiculoSiipne ,
        "restriccionPJ": restriccionPj ,
      };
}

class DatosVehiculoAnt {
  DatosVehiculoAnt({required this.success,
    required this.dataVehiculoAnt,
    required this.mensaje});

  bool success;
  String mensaje;
  DataVehiculoAnt dataVehiculoAnt;

  factory DatosVehiculoAnt.empty() =>
      DatosVehiculoAnt(
          success: false,
          dataVehiculoAnt: DataVehiculoAnt.empty(),
          mensaje: "");

  factory DatosVehiculoAnt.fromJson(String str) =>
      DatosVehiculoAnt.fromMap(json.decode(str));

  factory DatosVehiculoAnt.fromMap(Map<String, dynamic> json) =>
      DatosVehiculoAnt(
        success: ParseModel.parseToBool(json["success"]),
        mensaje: ParseModel.parseToString(json["mensaje"]),
        dataVehiculoAnt: json["data"] == null
            ? DataVehiculoAnt.empty()
            : ParseModel.parseToBool(json["success"]) == false
            ? DataVehiculoAnt.empty()
            : DataVehiculoAnt.fromMap(json["data"]),
      );
}

class DataVehiculoAnt {
  DataVehiculoAnt({
    required this.activoVig,
    required this.anio,
    required this.anioMatriculado,
    required this.cambioPropietario,
    required this.canvcp,
    required this.capacidad,
    required this.carroceria,
    required this.casaComercial,
    required this.cedulaPropAnterior,
    required this.celular,
    required this.chasis,
    required this.cilindraje,
    required this.claseServicio,
    required this.claseVehiculo,
    required this.color,
    required this.color2,
    required this.combustible,
    required this.correo,
    required this.direccion,
    required this.docPropietario,
    required this.fechaCaducidad,
    required this.fechaCompraVenta,
    required this.fechaMatricula,
    required this.marcaDesc,
    required this.modeloDesc,
    required this.motor,
    required this.nombrePropAnterior,
    required this.placaActual,
    required this.placaAnterior,
    required this.propietario,
    required this.remarcadoChasis,
    required this.remarcadoMotor,
    required this.reservaDominio,
    required this.robado,
    required this.telefono,
    required this.tipoServicio,
    required this.tonelaje,
  });

  final bool activoVig;
  final int anio;
  final int anioMatriculado;
  final bool cambioPropietario;
  final String canvcp;
  final int capacidad;
  final String carroceria;
  final String casaComercial;
  final String cedulaPropAnterior;
  final String celular;
  final String chasis;
  final String cilindraje;
  final String claseServicio;
  final String claseVehiculo;
  final String color;
  final String color2;
  final String combustible;
  final String correo;
  final String direccion;
  final String docPropietario;
  final String fechaCaducidad;
  final String fechaCompraVenta;
  final String fechaMatricula;
  final String marcaDesc;
  final String modeloDesc;
  final String motor;
  final String nombrePropAnterior;
  final String placaActual;
  final String placaAnterior;
  final String propietario;
  final bool remarcadoChasis;
  final bool remarcadoMotor;
  final bool reservaDominio;
  final bool robado;
  final String telefono;
  final String tipoServicio;
  final double tonelaje;

  factory DataVehiculoAnt.empty() =>
      DataVehiculoAnt(
          activoVig: false,
          anio: 0,
          anioMatriculado: 0,
          cambioPropietario: false,
          canvcp: "",
          capacidad: 0,
          carroceria: "",
          casaComercial: "",
          cedulaPropAnterior: "",
          celular: "",
          chasis: "",
          cilindraje: "",
          claseServicio: "",
          claseVehiculo: "",
          color: "",
          color2: "",
          combustible: "",
          correo: "",
          direccion: "",
          docPropietario: "",
          fechaCaducidad: "",
          fechaCompraVenta: "",
          fechaMatricula: "",
          marcaDesc: "",
          modeloDesc: "",
          motor: "",
          nombrePropAnterior: "",
          placaActual: "",
          placaAnterior: "",
          propietario: "",
          remarcadoChasis: false,
          remarcadoMotor: false,
          reservaDominio: false,
          robado: false,
          telefono: "",
          tipoServicio: "",
          tonelaje: 0);

  factory DataVehiculoAnt.fromJson(String str) =>
      DataVehiculoAnt.fromMap(json.decode(str));

  factory DataVehiculoAnt.fromMap(Map<String, dynamic> json) =>
      DataVehiculoAnt(
        activoVig:
        ParseModel.parseToBool(json["activoVig"], valueCompareTrue: 'S'),
        anio: ParseModel.parseToInt(json["anio"]),
        anioMatriculado: ParseModel.parseToInt(json["anioMatriculado"]),
        cambioPropietario: ParseModel.parseToBool(["cambioPropietario"],
            valueCompareTrue: 'S'),
        canvcp: ParseModel.parseToString(json["canvcp"]),
        capacidad: ParseModel.parseToInt(json["capacidad"]),
        carroceria: ParseModel.parseToString(json["carroceria"]),
        casaComercial: ParseModel.parseToString(json["casaComercial"]),
        cedulaPropAnterior:
        ParseModel.parseToString(json["cedulaPropAnterior"]),
        celular: ParseModel.parseToString(json["celular"]),
        chasis: ParseModel.parseToString(json["chasis"]),
        cilindraje: ParseModel.parseToString(json["cilindraje"]),
        claseServicio: ParseModel.parseToString(json["claseServicio"]),
        claseVehiculo: ParseModel.parseToString(json["claseVehiculo"]),
        color: ParseModel.parseToString(json["color"]),
        color2: ParseModel.parseToString(json["color2"]),
        combustible: ParseModel.parseToString(json["combustible"]),
        correo: ParseModel.parseToString(json["correo"]),
        direccion: ParseModel.parseToString(json["direccion"]),
        docPropietario: ParseModel.parseToString(json["docPropietario"]),
        fechaCaducidad: ParseModel.parseToString(json["fechaCaducidad"]),
        fechaCompraVenta: ParseModel.parseToString(json["fechaCompraVenta"]),
        fechaMatricula: ParseModel.parseToString(json["fechaMatricula"]),
        marcaDesc: ParseModel.parseToString(json["marcaDesc"]),
        modeloDesc: ParseModel.parseToString(json["modeloDesc"]),
        motor: ParseModel.parseToString(json["motor"]),
        nombrePropAnterior:
        ParseModel.parseToString(json["nombrePropAnterior"]),
        placaActual: ParseModel.parseToString(json["placaActual"]),
        placaAnterior: ParseModel.parseToString(json["placaAnterior"]),
        propietario: ParseModel.parseToString(json["propietario"]),
        remarcadoChasis: ParseModel.parseToBool(json["remarcadoChasis"],
            valueCompareTrue: 'S'),
        remarcadoMotor: ParseModel.parseToBool(json["remarcadoMotor"],
            valueCompareTrue: 'S'),
        reservaDominio: ParseModel.parseToBool(json["reservaDominio"],
            valueCompareTrue: 'S'),
        robado: ParseModel.parseToBool(json["robado"], valueCompareTrue: 'S'),
        telefono: ParseModel.parseToString(json["telefono"]),
        tipoServicio: ParseModel.parseToString(json["tipoServicio"]),
        tonelaje: ParseModel.parseToDouble(json["tonelaje"]),
      );
}

class DatosVehiculoSiipne {
  DatosVehiculoSiipne({
    required this.success,
    required this.dataVehiculoSiipne,
  });

  bool success;
  DataVehiculoSiipne dataVehiculoSiipne;

  factory DatosVehiculoSiipne.empty()=>
      DatosVehiculoSiipne(
          success: false, dataVehiculoSiipne: DataVehiculoSiipne.empty());

  factory DatosVehiculoSiipne.fromJson(String str) =>
      DatosVehiculoSiipne.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DatosVehiculoSiipne.fromMap(Map<String, dynamic> json) =>
      DatosVehiculoSiipne(
        success: ParseModel.parseToBool(json["success"]),
        dataVehiculoSiipne: json["data"] == null
            ? DataVehiculoSiipne.empty()
            : ParseModel.parseToBool(json["success"]) == false
            ? DataVehiculoSiipne.empty()
            : DataVehiculoSiipne.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success,
        "data": dataVehiculoSiipne.toMap(),
      };
}

class DataVehiculoSiipne {
  DataVehiculoSiipne({
    required this.idGenVehiculo,
    required this.idGenMarca,
    required this.marca,
    required this.idGenModelo,
    required this.modelo,
    required this.idGenColor,
    required this.color,
    required this.idGenCombus,
    required this.combustible,
    required this.motor,
    required this.chasis,
    required this.placa,
    required this.cilindraje,
    required this.anoFabricacion,
    required this.idGenClase,
    required this.clase,
    required this.idGenTipVehi,
    required this.tipoVehiculo,
    required this.idGenServicio,
    required this.descServicio,
  });

  int idGenVehiculo;
  int idGenMarca;
  String marca;
  int idGenModelo;
  String modelo;
  int idGenColor;
  String color;
  int idGenCombus;
  String combustible;
  String motor;
  String chasis;
  String placa;
  String cilindraje;
  String anoFabricacion;
  int idGenClase;
  String clase;
  int idGenTipVehi;
  String tipoVehiculo;
  int idGenServicio;
  String descServicio;


  factory DataVehiculoSiipne.empty()=>
      DataVehiculoSiipne(idGenVehiculo: 0,
          idGenMarca: 0,
          marca: "",
          idGenModelo: 0,
          modelo: "",
          idGenColor: 0,
          color: "",
          idGenCombus: 0,
          combustible: "",
          motor: "",
          chasis: "",
          placa: "",
          cilindraje: "",
          anoFabricacion: "",
          idGenClase: 0,
          clase: "",
          idGenTipVehi: 0,
          tipoVehiculo: "",
          idGenServicio: 0,
          descServicio: "");

  factory DataVehiculoSiipne.fromJson(String str) =>
      DataVehiculoSiipne.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataVehiculoSiipne.fromMap(Map<String, dynamic> json) =>
      DataVehiculoSiipne(
        idGenVehiculo: ParseModel.parseToInt(json["idGenVehiculo"]),
        idGenMarca: ParseModel.parseToInt(json["idGenMarca"]),
        marca: ParseModel.parseToString(json["marca"]),
        idGenModelo: ParseModel.parseToInt(json["idGenModelo"]),
        modelo: ParseModel.parseToString(json["modelo"]),
        idGenColor: ParseModel.parseToInt(json["idGenColor"]),
        color: ParseModel.parseToString(json["color"]),
        idGenCombus: ParseModel.parseToInt(json["idGenCombus"]),
        combustible: ParseModel.parseToString(json["combustible"]),
        motor: ParseModel.parseToString(json["motor"]),
        chasis: ParseModel.parseToString(json["chasis"]),
        placa: ParseModel.parseToString(json["placa"]),
        cilindraje: ParseModel.parseToString(json["cilindraje"]),
        anoFabricacion: ParseModel.parseToString(json["anoFabricacion"]),
        idGenClase: ParseModel.parseToInt(json["idGenClase"]),
        clase: ParseModel.parseToString(json["clase"]),
        idGenTipVehi: ParseModel.parseToInt(json["idGenTipVehi"]),
        tipoVehiculo: ParseModel.parseToString(json["tipoVehiculo"]),
        idGenServicio: ParseModel.parseToInt(json["idGenServicio"]),
        descServicio: ParseModel.parseToString(json["descServicio"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "idGenVehiculo": idGenVehiculo == null ? null : idGenVehiculo,
        "idGenMarca": idGenMarca == null ? null : idGenMarca,
        "marca": marca == null ? null : marca,
        "idGenModelo": idGenModelo == null ? null : idGenModelo,
        "modelo": modelo == null ? null : modelo,
        "idGenColor": idGenColor == null ? null : idGenColor,
        "color": color == null ? null : color,
        "idGenCombus": idGenCombus == null ? null : idGenCombus,
        "combustible": combustible == null ? null : combustible,
        "motor": motor == null ? null : motor,
        "chasis": chasis == null ? null : chasis,
        "placa": placa == null ? null : placa,
        "cilindraje": cilindraje == null ? null : cilindraje,
        "anoFabricacion": anoFabricacion == null ? null : anoFabricacion,
        "idGenClase": idGenClase == null ? null : idGenClase,
        "clase": clase == null ? null : clase,
        "idGenTipVehi": idGenTipVehi == null ? null : idGenTipVehi,
        "tipoVehiculo": tipoVehiculo == null ? null : tipoVehiculo,
        "idGenServicio": idGenServicio == null ? null : idGenServicio,
        "descServicio": descServicio == null ? null : descServicio,
      };
}

class RestriccionPj {
  RestriccionPj({
    required this.robado,
  });

  bool robado;

  factory RestriccionPj.empty()=>RestriccionPj(robado: false);

  factory RestriccionPj.fromJson(String str) =>
      RestriccionPj.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RestriccionPj.fromMap(Map<String, dynamic> json) =>
      RestriccionPj(
        robado: ParseModel.parseToBool(json["robado"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "robado": robado == null ? null : robado,
      };
}
