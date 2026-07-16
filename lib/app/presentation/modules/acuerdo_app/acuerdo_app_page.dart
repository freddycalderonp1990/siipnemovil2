part of '../pages.dart';

class AcuerdoAppPage extends GetView<AcuerdoAppController> {
  const AcuerdoAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return WorkAreaPageWidget(



      title: "",
      contenido: getContenido(),
      peticionServer: controller.peticionServerState,
    );
  }




  Widget getContenido(){
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:SingleChildScrollView(child:  Column(
          children: [

            const Icon(
              Icons.gpp_good_rounded,
              color: AppColors.colorAzul,
              size: 60,
            ),

            const SizedBox(height: 12),

            const Text(
              "Aviso Legal, Conocimiento y Aceptación de Uso del Aplicativo SIIPNE MÓVIL",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Antes de continuar, lea atentamente las condiciones de uso del aplicativo SIIPNE Móvil.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
              ),
            ),



           // _warning(),

            const SizedBox(height: 20),

            _contenido(),

            const SizedBox(height: 20),

            _acepto(),

            const SizedBox(height: 25),

            _botonContinuar(),

            const SizedBox(height: 12),

            _botonSalir(),
          ],
        ),),
      ),
    );
  }



  Widget _warning() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.shade300,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              "La información contenida en este aplicativo es confidencial y de uso exclusivo para personal autorizado de la Policía Nacional del Ecuador.",
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido() {
    final responsive = ResponsiveUtil();
    return Container(
      height:responsive.altoP(20) ,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Scrollbar(
        controller: controller.scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(15),
          child: Text(
            controller.textoAcuerdo.value,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              height: 1.6,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _acepto() {
    return Obx(
          () => CheckboxListTile(
        value: controller.acepta.value,
        onChanged: controller.puedeAceptar.value
            ? (v) => controller.acepta.value = v!
            : null,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: AppColors.colorAzul,
        title: const Text(
          "He leído y acepto el Aviso Legal y las Condiciones de Uso.",
        ),
      ),
    );
  }



  Widget _botonContinuar() {




    return Obx(
          () => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_circle, color: Colors.white,),
          label: const Text("CONTINUAR",  style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: AppColors.colorAzul,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: controller.acepta.value
              ? controller.continuar
              : null,
        ),
      ),
    );
  }

  Widget _botonSalir() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(
          Icons.logout,
          color: AppColors.colorAzul,
        ),
        label: const Text(
          "SALIR",
          style: TextStyle(
            color: AppColors.colorAzul,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.colorAzul,
            width: 1.5,
          ),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: controller.cerrarSession,
      ),
    );
  }

}
