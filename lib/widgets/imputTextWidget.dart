part of 'customWidgets.dart';

class ImputTextWidget extends StatefulWidget {
  final String label;
  final String hitText;
  final Function(String) validar;
  final bool isSegura;
  final double fonSize;
  final double elevation;
  final bool activar;
  final Icon icono;
  final int maxLength;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final String imgString;


  const ImputTextWidget({
    Key key,
    this.label,
    this.validar,
    this.isSegura = false,
    this.fonSize = 17,
    this.elevation = 0.0,
    this.icono,
    this.activar = true,
    this.controller,
    this.maxLength = 0,
    this.hitText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.imgString = "",
  }) : super(key: key);

  @override
  _ImputTextWidgetState createState() =>
      _ImputTextWidgetState(isSegura: this.isSegura);
}

class _ImputTextWidgetState extends State<ImputTextWidget> {
  bool isSegura;

  _ImputTextWidgetState({this.isSegura});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final responsive = ResponsiveUtil(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.imgString == ""
              ? Container(
                  child: widget.icono,
                )
              : Container(
            width:responsive.isVertical()? responsive.altoP(4.3): responsive.altoP(8),
                  child: Image.asset(widget.imgString),
                ),
          SizedBox(
            width: responsive.anchoP(2),
          ),
          Expanded(
            child: widget.isSegura
                ? getTxtPass()
                : widget.maxLength > 0
                    ? getTxtConLeng()
                    : getTxtNormal(),
          ),
          SizedBox(
            width: 14,
          )
        ],
      ),
    );
  }

  InputDecoration getDecorationTxt() {
    return InputDecoration(
        labelStyle: TextStyle(fontSize: widget.fonSize,),
        labelText: widget.label,
        hintText: widget.hitText,
        contentPadding: EdgeInsets.symmetric(vertical: 10));
  }

  InputDecoration getDecorationTxtPass() {
    return InputDecoration(
        labelStyle: TextStyle(fontSize: widget.fonSize),
        labelText: widget.label,
        hintText: widget.hitText,
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            isSegura ? Icons.visibility : Icons.visibility_off,
            color: AppConfig.colorBotonesWidget,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              isSegura = !isSegura;
            });
          },
        ));
  }

  Widget getTxtNormal() {
    return TextFormField(

      keyboardType: widget.keyboardType,
      controller: widget.controller,
      enabled: widget.activar,
      obscureText: widget.isSegura,
      validator: widget.validar,
      onChanged: widget.onChanged,
      cursorColor: AppConfig.colorBordecajas,
      decoration: getDecorationTxt(),
    );
  }

  Widget getTxtConLeng() {
    return TextFormField(
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      enabled: widget.activar,
      obscureText: widget.isSegura,
      validator: widget.validar,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      cursorColor: AppConfig.colorBordecajas,
      decoration: getDecorationTxt(),
    );
  }

  Widget getTxtPass() {
    return TextFormField(
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      enabled: widget.activar,
      obscureText: isSegura,
      onChanged: widget.onChanged,
      validator: widget.validar,
      cursorColor: AppConfig.colorBordecajas,
      decoration: getDecorationTxtPass(),
    );
  }
}
