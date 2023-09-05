import 'package:intl/intl.dart';


import 'encriptar_util.dart';

class AlgoritmoTOTP {
  // ******************* CONFIGURACIONES *******************************

  static String _formatTime = "yyyy-MM-dd HH:mm:ss";
  static  int _change_key_every = 30; //seconds cada cuanto cambia la clave
  int _hash_len = 128; //longitud del hast 128 caracteres
  static int _pin_len = 6; //longitud del pin
  static int _default_rounds =
      2; //rondas por defecto, cuantas veces vamos a utilizar el hmac_
  static String _key_security =
      "094ed4134b73e2dPOLICIA_ECUATORIANA465af11b5abffe8a0"; // Codigo unico que se define para seguridad al generar el codigo
// ******************* END  CONFIGURACIONES *******************************

  static String getCode(String clave,
      {String? anio_,
      String? mes_,
      String? dia_,
      String? hora_,
      String? minutos,
      String? segundo_}) {

    clave=EncriptarUtil.generateSha512(clave);

//    String clave = "1234568";
    String fecha = getFechaActual();
    if (anio_ != null) {
      fecha = "${anio_}-${mes_}-${dia_} ${hora_}:${minutos}:${segundo_}";
    }
    //fecha = "2021-01-07 15:47:36";

    print("la fecha es = " + fecha);

    //Obtiene el time unix en segundos
    int unixtime = getUnixTime(fecha);

    int unixtimeFloor = setUnixtimeDuration(unixtime);

    String passwordHash = getHashKey(clave, unixtimeFloor);

    String codigo = getCodeKey(passwordHash);

    print("| Clave= ${clave} | sha512 = ${passwordHash} | code= ${codigo}");

    return codigo;
  }

  //se encarga de crear el hash , a partir del pass - clave , y el tiempo unixtime
  static  String getHashKey(String pass, int unixtimeFloor) {
    String password = pass + unixtimeFloor.toString() + _key_security;

    //Se define cuantas veces se encripta el codigo
    //para darle mayor seguridad

    for (int i = 0; i < _default_rounds; i++) {
      password = EncriptarUtil.generateSha512(password);
    }

    return password;
  }

  //Convierte en arreglo el hash
  static  List<String> _getArrayHash(String has) {
    List<String> res = [];
    for (int i = 0; i < has.length; i++) {
      res.add(has[i]);
    }
    return res;
  }

  //Obtiene el codigo
  static String getCodeKey(String hash) {
    List<String> res = _getArrayHash(hash);

    String codeReduce = res.reduce((b, letra) {
      // print("${letra} = ${b}");

      //Obtenemos el codigo ASCII
      int o_b = letra.codeUnitAt(0);
      //print(o_b);

      //Se captura el año
      //le agregamos variedad al codigo para que no coincidan con el pasar de los años

      DateTime now = new DateTime.now();
      var formatter = new DateFormat("yyyy");
      String formattedDate = formatter.format(now);

      int anio = int.parse(formattedDate);
      anio = anio + 457;

      double mult_divisor = anio / _pin_len;
      double multiplier = 1 + o_b / mult_divisor;
      double resultado = 0;
      try {
        int valorLetra = int.parse(letra);
        if (valorLetra > 1) {
          resultado = valorLetra * multiplier;

          return resultado.toString();
        }
      } catch (e) {
        //Obtenemos el codigo ASCII
        int o_a = letra.codeUnitAt(0);
        if (o_a > 10) {
          resultado = o_a * multiplier;

          return resultado.toString();
        }
      }

      resultado = letra.codeUnitAt(0) * multiplier;

      return resultado.toString();
    });

    codeReduce = codeReduce.substring(0, 11);

    //Ahora se revierte el codigo

    String reverseCode = _getReverseCode(codeReduce);

    //Le indicamos la longitud de digitos del codigo
    reverseCode = reverseCode.substring(0, _pin_len);

    return reverseCode;
  }

// Se encarga de revertir el codigo
//Ejemplo 12345  = 54312
//Pora obtener codigos mas variables ya que un valor que se encuantra a la derecha es mas probable que cambie
//obteneiendo de esta manera codigos variables para el usuario
static  String _getReverseCode(String code) {
    List<int> codigoResult = [];
    String result = "";
//Se reemplaza los . (Puntos) y , (Comas)
    code = code.replaceAll(",", "").replaceAll(".", "");

    for (int i = code.length - 1; i >= 0; i--) {
      int r = int.parse(code[i]);
      result = result + code[i];
      codigoResult.add(r);
    }

    return result;
  }

static String getFechaActual() {
    DateTime now = new DateTime.now();
    var formatter = new DateFormat(_formatTime);
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  String setNewSecon(String fecha) {
    DateTime dt = DateTime.parse(fecha);
    //Verificamos los segundos
    var formatter = new DateFormat('ss');
    int segundos = int.parse(formatter.format(dt));
    if (segundos >= 0 && segundos <= 29) {
      segundos = 0;
    } else if (segundos >= 30 && segundos <= 59) {
      segundos = 30;
    }
    //extraemos la fecha sin los segundos
    formatter = new DateFormat('yyyy-MM-dd HH:mm:');
    String fecha2 = formatter.format(dt);
    String fechaNew = "";
    if (segundos == 0) {
      fechaNew = fecha2 + segundos.toString() + "0";
    } else {
      fechaNew = fecha2 + segundos.toString();
    }
    //se agrena los nuevos segundos a la fehca

    //se crea el formato de fecha con los nuevos segundos
    formatter = new DateFormat(_formatTime);
    dt = DateTime.parse(fechaNew);
    fechaNew = formatter.format(dt);

    return fechaNew;
  }

  static int getUnixTime(String fecha) {
    DateTime dt = DateTime.parse(fecha);
    //como el valor nos da en milisegundos los transformamos a segundos
    double segundos = dt.millisecondsSinceEpoch / 1000;
    int n = int.parse(segundos.toStringAsFixed(0));
    return n;
  }

  static int setUnixtimeDuration(int unixtime) {
    double unixtimeDuration = unixtime / _change_key_every;

    //se redondea el valor
    int floor = int.parse(unixtimeDuration.toStringAsFixed(0));

    return floor;
  }
}
