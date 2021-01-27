
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';


//===================================================

// This class uses awesome dialog Package
// Link to it :  https://pub.dev/packages/awesome_dialog

//===================================================

class AwesomeDialogScreen extends StatefulWidget {
  static const routeName = '/AwesomeDialogScreen';
  @override
  _AwesomeDialogScreenState createState() => _AwesomeDialogScreenState();
}

class _AwesomeDialogScreenState extends State<AwesomeDialogScreen> {
  void showAlertDialogOnOkCallback(String title, String msg,
      DialogType dialogType, BuildContext context, VoidCallback onOkPress) {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      dialogType: dialogType,
      title: title,
      desc: msg,
      btnOkIcon: Icons.check_circle,
      btnOkColor: Colors.green.shade900,
      btnOkOnPress: onOkPress,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: <Widget>[
            SizedBox(height: 60),

            //===========================
            //         Dialog 1
            //===========================
            AnimatedButton(
              text: 'Dialog 1',
              color: Colors.yellowAccent,
              pressEvent: () {
                showAlertDialogOnOkCallback(
                    'Success !',
                    'The operation was successfully completed.',
                    DialogType.SUCCES,
                    context,
                        () => {});
              },
            ),


            //===========================
            //         Dialog 2
            //===========================
            AnimatedButton(
              text: 'Dialog 2',
              color: Colors.teal,
              pressEvent: () {
                AwesomeDialog(
                    context: context,
                    headerAnimationLoop: false,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Information',
                    desc:
                    'The operation was successfully completed.',
                    btnCancelOnPress: () {})
                    .show();
              },
            ),


            //===========================
            //         Dialog 3
            //===========================
            AnimatedButton(
              text: 'Dialog 3',
              color: Colors.deepPurpleAccent,
              pressEvent: () {
                AwesomeDialog(
                  context: context,
                  headerAnimationLoop: false,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  
                  title: 'Information',
                  desc: 'The operation was successfully completed.',
                ).show();
              },
            ),


            //===========================
            //         Dialog 4
            //===========================
            AnimatedButton(
              text: 'Dialog 4',
              color: Colors.orange,
              pressEvent: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    headerAnimationLoop: false,
                    animType: AnimType.TOPSLIDE,
                    title: 'Warning',
                    desc:
                    'Are you sure you want to delete the item',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {})
                    .show();
              },
            ),



            //===========================
            //         Dialog 5
            //===========================
            AnimatedButton(
              text: 'Dialog 5',
              color: Colors.red,
              pressEvent: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: 'Error',
                    desc:
                    'Are you sure you want to delete the item',
                    btnOkOnPress: () {},
                    btnOkColor: Colors.red)
                    .show();
              },
            ),


            //===========================
            //         Dialog 6
            //===========================
            AnimatedButton(
              text: 'Dialog 6',
              color: Colors.green,
              pressEvent: () {
                AwesomeDialog(
                    context: context,
                    animType: AnimType.LEFTSLIDE,
                    headerAnimationLoop: false,
                    dialogType: DialogType.SUCCES,
                    title: 'Succes',
                    desc:
                    'The operation was successfully completed..................................',
                    btnOkIcon: Icons.check_circle,
                    onDissmissCallback: () {
                      debugPrint('Dialog Dissmiss from callback');
                    }).show();
              },
            ),


            //===========================
            //         Dialog 7
            //===========================
            AnimatedButton(
              text: 'Dialog 7',
              color: Colors.blueGrey,
              pressEvent: () {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.INFO,
                  body: Center(
                    child: Text(
                      'The operation was successfully completed.\n Confirm or cancel the deletion process',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  title: 'Agree',
                  desc: 'Confirm Agree',
                ).show();
              },
            ),


            //===========================
            //         Dialog 8
            //===========================
            AnimatedButton(
              text: 'Dialog 8',
              color: Colors.brown,
              pressEvent: () {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  customHeader: Icon(
                    Icons.face,
                    size: 50,
                  ),

                  title: 'This is Custom Dialod',
                  desc: 'Confirm or cancel the deletion process',
                  btnOk: FlatButton(
                    child: Text('Cancel Button'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  //this is ignored
                  btnOkOnPress: () {},
                ).show();
              },
            ),



            SizedBox(height: 60),
          ])),
    );
  }
}