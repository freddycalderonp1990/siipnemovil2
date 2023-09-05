part of '../pages.dart';

class VerificarOpertaivoRecintoAbiertoPage extends GetView<VerificarOpertaivoRecintoAbiertoController> {
  const VerificarOpertaivoRecintoAbiertoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificarOpertaivoRecintoAbiertoController>(
        builder: (_) => WorkAreaPageAppWidget(
          btnAtras: true,
          contenido: Text("hola"),
          peticionServer: false.obs,
        ));
  }
}
