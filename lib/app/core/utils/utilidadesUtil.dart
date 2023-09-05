import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../../../app_siipne_movil/presentation/widgets/customWidgets.dart';

class UtilidadesUtil {
  static bool plataformaIsAndroid() {
    return GetPlatform.isAndroid;
  }

  //utilizada en el parseModel
  static double redondearDouble(double value, {int decimales = 4}) {
    String r = value.toStringAsFixed(decimales);

    return double.parse(r);
  }

  static compartirPdf(String archivo) async {
    try {
      await Share.shareFiles([archivo], text: 'Your PDF!');
      ;
    } catch (e) {
      DialogosAwesome.getWarning(descripcion: "No se pudo cargar la página");
    }
  }

  static Future<String> getVersionCodeNameApp() async {
    String versionName = await getVersionName();
    String versionCode = await getVersionCode();

    String result = versionName + ' - ' + versionCode;

    return result;
  }

  static void ocultarTeclado(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static void playAudio({required String nameAudio}) async {
    // or as a local variable
    // final player = AudioCache();
    final player = AudioPlayer();
    // call this method when desired
    print("play audio");

    Vibration.vibrate(
      pattern: [500, 1000, 500, 900, 500, 800, 500, 500],
      intensities: [0, 128, 0, 255, 0, 64, 0, 255],
    );

    // await player.play(UrlSource('https://example.com/my-audio.wav'));

    await player.play(AssetSource(nameAudio));
  }

  static Future<void> lanzarLlamada(String num) async {
    try {
      launch(
          'tel://$num'); //donde $phoneNumber es el numero de teléfono que queremos marcar
    } catch (e) {
      DialogosAwesome.getWarning(
          descripcion: "No se pudo realizar la llamada al número:" + num);
    }
  }

  static Future<String> getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String versionName = packageInfo.version;

    String result = versionName;

    return result;
  }

  static Future<String> getVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String versionCode = packageInfo.buildNumber;

    String result = versionCode;

    return result;
  }

  static abrirUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
