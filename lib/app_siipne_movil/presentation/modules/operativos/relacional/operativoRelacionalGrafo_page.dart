part of '../../pages.dart';


class OperativoRelacionalGrafoPage extends StatefulWidget {
  @override
  _OperativoRelacionalGrafoPageState createState() => _OperativoRelacionalGrafoPageState();
}

class _OperativoRelacionalGrafoPageState extends State<OperativoRelacionalGrafoPage> {
  final _graph = grafo.Graph()..isTree = true;




  final _configuration = grafo.SugiyamaConfiguration()
    ..orientation = 1
    ..nodeSeparation = 40
    ..levelSeparation = 50;

  @override
  void initState() {
    super.initState();



    _graph.addEdge(grafo.Node.Id(1), grafo.Node.Id(2));
    _graph.addEdge(grafo.Node.Id(2), grafo.Node.Id(3));
    _graph.addEdge(grafo.Node.Id(2),grafo. Node.Id(11));
    _graph.addEdge(grafo.Node.Id(3), grafo.Node.Id(4));
    _graph.addEdge(grafo.Node.Id(4), grafo.Node.Id(5));


    _graph.addEdge(grafo.Node.Id(1), grafo.Node.Id(6));
    _graph.addEdge(grafo.Node.Id(6), grafo.Node.Id(7));
    _graph.addEdge(grafo.Node.Id(7), grafo.Node.Id(3));

    _graph.addEdge(grafo.Node.Id(1), grafo.Node.Id(10));
    _graph.addEdge(grafo.Node.Id(10), grafo.Node.Id(11));
    _graph.addEdge(grafo.Node.Id(11), grafo.Node.Id(7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        minScale: 0.1,
        constrained: false,
        boundaryMargin: const EdgeInsets.all(64),
        child: grafo.GraphView(
          animated: true,
          graph: _graph,
          algorithm: grafo.SugiyamaAlgorithm(_configuration),
          builder: (node) {
            final id = node.key!.value as int;


            final text = "Dibujando nodos"+id.toString();

            return Container(

              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 11,color: Colors.red),
              ),
              padding: const EdgeInsets.all(16),
              child: Text('$id $text'),
            );
          },
        ),
      ),
    );
  }
}
