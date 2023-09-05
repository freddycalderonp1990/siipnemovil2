part of 'customWidgets.dart';

class DialogosAwesome {
  static getConTextImput(
      {String title = 'ERROR', required String descripcion}) {
    late AwesomeDialog dialog;
    dialog = AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: Get.context!,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      keyboardAware: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Form Data',
              style: Theme.of(Get.context!).textTheme.headline6,
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              elevation: 0,
              color: Colors.blueGrey.withAlpha(40),
              child: TextFormField(
                autofocus: true,
                minLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.text_fields),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              elevation: 0,
              color: Colors.blueGrey.withAlpha(40),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.multiline,

                minLines: 2,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.text_fields),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            AnimatedButton(
                isFixedHeight: false,
                text: 'Close',
                pressEvent: () {
                  dialog.dismiss();
                })
          ],
        ),
      ),
    )..show();
  }

  static getError(
      {String title = 'ERROR',
        required String descripcion,
        Function()? btnOkOnPress}) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: Get.context!,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        title: title,
        desc: descripcion,
        btnOkText: "Ok",
        btnOkOnPress: btnOkOnPress == null ? () {} : btnOkOnPress,
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }

  static getSucess(
      {String title = 'ÉXITO',
        required String descripcion,
        Function()? btnOkOnPress}) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: Get.context!,
      animType: AnimType.TOPSLIDE,
      dialogType: DialogType.SUCCES,
      title: title,
      headerAnimationLoop: false,
      desc: descripcion,
      btnOkText: "Ok",
      btnOkIcon: Icons.check_circle,
      btnOkOnPress: btnOkOnPress == null
          ? () {
        Get.back();
      }
          : btnOkOnPress,
    ).show();
  }

  static getWarning(
      {String title = 'Advertencia',
        required String descripcion,
        Function()? btnOkOnPress}) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: Get.context!,
        dialogType: DialogType.WARNING,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        title: title,
        desc: descripcion,
        btnCancelIcon: Icons.cancel_rounded,
        btnOkIcon: Icons.check_circle,
        btnCancelText: "No",
        btnOkColor: Colors.deepOrangeAccent,
        btnOkText: "Ok",
        btnOkOnPress: btnOkOnPress == null
            ? () {
          Get.back();
        }
            : btnOkOnPress)
        .show();
  }

  static getWarningSiNo(
      {String title = 'ADVERTENCIA',
        required String descripcion,
        Function()? btnOkOnPress,Function()? btnCancelOnPress}) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: Get.context!,
        dialogType: DialogType.WARNING,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        title: title,
        desc: descripcion,
        btnCancelText: "No",
        btnCancelIcon: Icons.cancel_rounded,
        btnOkIcon: Icons.check_circle,
        btnOkColor: Colors.blue,
        btnOkText: "Si",
        btnCancelOnPress:btnCancelOnPress!=null?btnCancelOnPress: () {
          Get.back();
        },
        btnOkOnPress: btnOkOnPress)
        .show();
  }

  static getInformation(
      {String title = 'Información', required String descripcion}) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: Get.context!,
        dialogType: DialogType.INFO,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        title: title,
        desc: descripcion,
        btnCancelText: "Aceptar",
        btnCancelIcon: Icons.cancel_rounded,
        btnOkIcon: Icons.check_circle,
        btnOkOnPress: () {
          Get.back();
        }).show();
  }

  static getInformationAceptar({
    String title = 'Información',
    required String descripcion,
    required Function() btnOkOnPress,
  }) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: Get.context!,
        dialogType: DialogType.INFO,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        title: title,
        desc: descripcion,
        btnCancelText: "Aceptar",
        btnCancelIcon: Icons.cancel_rounded,
        btnOkIcon: Icons.check_circle,
        btnOkOnPress: btnOkOnPress)
        .show();
  }

  static getInformationSiNo(
      {String title = 'INFORMACIÓN',
        required String descripcion,
        Function()? btnOkOnPress,
        Function()? btnCancelOnPress}) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: Get.context!,
        dialogType: DialogType.INFO,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        title: title,
        btnCancelIcon: Icons.cancel_rounded,
        btnOkIcon: Icons.check_circle,
        desc: descripcion,
        btnCancelText: "No",
        btnOkText: "Si",
        btnCancelOnPress: btnCancelOnPress == null
            ? () {
          Get.back();
        }
            : btnCancelOnPress,
        btnOkOnPress: btnOkOnPress)
        .show();
  }

  static getInformationSi({
    String title = 'INFORMACIÓN',
    required String descripcion,
    Function()? btnOkOnPress,
  }) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: Get.context!,
        dialogType: DialogType.INFO,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        title: title,
        btnCancelIcon: Icons.cancel_rounded,
        btnOkIcon: Icons.check_circle,
        desc: descripcion,
        btnCancelText: "No",
        btnOkText: "Ok",
        btnOkOnPress: btnOkOnPress)
        .show();
  }

  static getPersonalizado(
      {String title = 'Información', required String descripcion}) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: Get.context!,
      animType: AnimType.SCALE,
      customHeader: Icon(
        Icons.face,
        size: 50,
        color: Colors.black,
      ),
      title: 'This is Custom Dialod',
      desc: 'Confirm or cancel the deletion process',
      btnOk: TextButton(
        child: Text('Cancel Button'),
        onPressed: () {
          Get.back();
        },
      ),
      //this is ignored
      btnOkOnPress: () {},
    ).show();
  }
}
