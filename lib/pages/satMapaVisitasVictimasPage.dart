part of 'pages.dart';

class SatMapaVisitasVictimasPage extends StatefulWidget {
  @override
  _SatMapaVisitasVictimasPageState createState() =>
      _SatMapaVisitasVictimasPageState();
}

class _SatMapaVisitasVictimasPageState
    extends State<SatMapaVisitasVictimasPage> {
  MapController _mapController = new MapController();
  UserProvider _UserProvider;

  //capas para el mapa
  List<LayerOptions> layers;

  //con esta variable si esta en true es por que obtiene desde el GPS del dsipostivo
  //se desactivaba cuando el usuario selecciona en el mapa una ubicacion distinta al del GPS
  // se activa cuando preciosa sobre el boton mi ubicacion
  //por defecto siempre esta activa
  bool ubicacionGps = true;

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
      body: Stack(
        children: [
          Center(
            child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
                builder: (context, state) => crearMapa(state)),
          ),
          BtnUbicacion(),
          BtnZoomMapWidget(),
          BtnAtrasWidget()
        ],
      ),
    );

    return WorkAreaPageWidget(
      btnAtras: true,
      contenido: [
        Container(
          height: responsive.altoP(87),
          child: Center(
            child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
                builder: (context, state) => crearMapa(state)),
          ),
        ),
      ],
    );
  }

  static LayerOptions getMapa() {
    return new TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c']);
  }

  addMarkerMiUbicacion(LatLng punto) {
    Key key = new Key("miUbicacion");
    Marker marcador = CustomMap.getMarkerMiUbicacion(key, punto);
    List<Marker> _markers = new List();
    _markers.add(marcador);

    // si ya existe el marcador el layer debe tener 2
    if (layers.length >= 2) {
      //si existe lo reemplazamos
      layers[1] = MarkerLayerOptions(
        markers: _markers,
      );
    } else {
      //si no existe lo agregamos
      layers.add(MarkerLayerOptions(
        markers: _markers,
      ));
    }
  }

  addMarkersVictimasSinVisitar() {
    List<Marker> _markers = new List();

    List<LatLng> puntos = new List();
    puntos.add(new LatLng(-0.196242, -78.511482));
    puntos.add(new LatLng(-0.196569, -78.511785));
    puntos.add(new LatLng(-0.197093, -78.511671));
    puntos.add(new LatLng(-0.197304, -78.510895));
    puntos.add(new LatLng(-0.197288, -78.510475));
    puntos.add(new LatLng(-0.195238, -78.509845));
    puntos.add(new LatLng(-0.197845, -78.509223));
    puntos.add(new LatLng(-0.196815, -78.511216));

    for (int i = 0; i < puntos.length; i++) {
      Key key = new Key("sinVisitar" + i.toString());
      Marker marcador = CustomMap.getMarkerVictimasSinVisitar(
          key: key,
          punto: puntos[i],
          onTap: () {
            print(i.toString());
            DialogosWidget.dialogoDatosVictimaVisitar(context,
                nombres: i.toString(),
                apellidos: "Calderon",
                direccion: "Direccion",
                medidasProteccion: ["UNO", "DOS", "TRES"], onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, AppConfig.pantallaSatRegistroVisitasVictimas);
            });
          });
      _markers.add(marcador);
    }

    // si ya existe el marcador el layer debe tener 2
    if (layers.length >= 3) {
      //si existe lo reemplazamos
      layers[2] = MarkerLayerOptions(
        markers: _markers,
      );
    } else {
      //si no existe lo agregamos
      layers.add(MarkerLayerOptions(
        markers: _markers,
      ));
    }
  }

  addMarkersVictimasVisitadas() {
    List<Marker> _markers = new List();

    List<LatLng> puntos = new List();
    puntos.add(new LatLng(-0.196272, -78.509217));
    puntos.add(new LatLng(-0.195640, -78.508041));

    for (int i = 0; i < puntos.length; i++) {
      Key key = new Key("Visitadas" + i.toString());
      Marker marcador = CustomMap.getMarkerVictimasVisitadas(
          key: key,
          punto: puntos[i],
          onTap: () {
            print(i.toString());
          });
      _markers.add(marcador);
    }

    // si ya existe el marcador el layer debe tener 2
    if (layers.length >= 4) {
      //si existe lo reemplazamos
      layers[3] = MarkerLayerOptions(
        markers: _markers,
      );
    } else {
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

    mapaBloc.initMapa(mapController: _mapController, layers: layers);
    //Agregamos el evento
    mapaBloc.add(OnNuevaUbicacion(state.ubicacion));

    //siempre existe una capa que es la capa del mapa
    //ahora agregaremos la capa del marcador de ubicacion en la posicion [1]

    if (ubicacionGps) {
      addMarkerMiUbicacion(state.ubicacion);
    }

    addMarkersVictimasSinVisitar();
    addMarkersVictimasVisitadas();

    return FlutterMap(
      mapController: _mapController,
      options: new MapOptions(
          center: state.ubicacion,
          zoom: zoomMap,
          minZoom: minZoom,
          maxZoom: maxZoom,
          onLongPress: (latlong) async {}),
      layers: layers,
    );


  }
}
