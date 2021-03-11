part of 'pages.dart';

class SatMapaRegistroVictimasPage extends StatefulWidget {
  @override
  _SatMapaRegistroVictimasPageState createState() => _SatMapaRegistroVictimasPageState();
}

class _SatMapaRegistroVictimasPageState extends State<SatMapaRegistroVictimasPage> {
  MapController _mapController = new MapController();
  UserProvider _UserProvider;

  //capas para el mapa
  List<LayerOptions> layers;

  //con esta variable si esta en true es por que obtiene desde el GPS del dsipostivo
  //se desactivaba cuando el usuario selecciona en el mapa una ubicacion distinta al del GPS
  // se activa cuando preciosa sobre el boton mi ubicacion
  //por defecto siempre esta activa
  bool ubicacionGps=true;

  @override
  void initState() {
    context.bloc<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
    layers = new List();
    layers.add(getMapa());
  }

  @override
  void dispose() {
    //context.bloc<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _UserProvider = UserProvider.of(context);
    final responsive = ResponsiveUtil(context);
    return Scaffold(
      body: Stack(children: [
        Center(
          child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
              builder: (context, state) => crearMapa(state)),
        ),
        BtnUbicacion(),
        BtnZoomMapWidget(),
        BtnAtrasWidget()
      ],),

    );


  }

  static LayerOptions getMapa() {
    return new TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c']);
  }




  addMarkerMiUbicacion(LatLng punto){
    Key key = new Key("miUbicacion");
    Marker marcador = CustomMap.getMarkerMiUbicacion(key,punto);
    List<Marker> _markers = new List();
    _markers.add(marcador);

    // si ya existe el marcador el layer debe tener 2
    if(layers.length>=2){
      //si existe lo reemplazamos
      layers[1]=MarkerLayerOptions(
        markers: _markers,
      );
    }
    else{
      //si no existe lo agregamos
      layers.add(MarkerLayerOptions(
        markers: _markers,
      ));
    }
  }

  Widget crearMapa(MiUbicacionState state) {
    print("creando mapa");

    //Ingresa cuando cambia la ubicacion
    double zoomMap = 17;

    double minZoom = 5;
    double maxZoom = 18;

    if (!state.existeUbicacion) return Text('Espere obteniendo ubicacion....');
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.initMapa(mapController: _mapController,layers: layers);
    //Agregamos el evento
    mapaBloc.add(OnNuevaUbicacion(state.ubicacion));


    //siempre existe una capa que es la capa del mapa
    //ahora agregaremos la capa del marcador de ubicacion en la posicion [1]


    if(ubicacionGps) {
      print('ddddddiibbba');
      addMarkerMiUbicacion(state.ubicacion);
    }



    return FlutterMap(
      mapController: _mapController,
      options: new MapOptions(
          center: state.ubicacion,
          zoom: zoomMap,
          minZoom: minZoom,
          maxZoom: maxZoom,
          onLongPress: (latlong) async  {
            double distancia= await myGps.getDistancia(state.ubicacion, latlong);

            print("ditancia es {$distancia}");
            ubicacionGps=false;

            print('tap sobre el mapa');
            print(latlong);
            _UserProvider.getUser.ubicacionSeleccionada=latlong;
            _mapController.move(latlong, zoomMap);
            addMarkerMiUbicacion(latlong);
            setState(() {

            });


          }),
      layers: layers,
    );

    /*  return SafeArea(
      child: GoogleMap(
        initialCameraPosition: camaraposition,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller){
            mapaBloc.initMapa(controller);
        },
      ),
    );*/

    return Text('${state.ubicacion?.latitude},${state.ubicacion?.longitude}');
  }
}
