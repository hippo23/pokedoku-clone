import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedoku/pokeapi.dart';
import 'package:pokedoku/controller.dart';

class PokedokuView {
  late ViewObserver _observer;
  final ViewState _viewState = ViewState();

  void attachObserver(ViewObserver observer) {
    _observer = observer;
  }

  void start() {
    runApp(
      MultiProvider(
        providers: [
          Provider<ViewObserver>.value(
            value: _observer,
          ), // makes DemoView available
          ChangeNotifierProvider<ViewState>.value(value: _viewState!),
        ],
        child: FlutterApp(),
      ),
    );
  }

  void setGameDone(bool state) {
    _viewState.setGameDone(state);
    _viewState.updateView();
  }

  void setColCategories(List<String> categories) {
    _viewState.setColCategories(categories);
    _viewState.updateView();
  }

  void setRowCategories(List<String> categories) {
    _viewState.setRowCategories(categories);
    _viewState.updateView();
  }
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        fontFamily: 'PressStart2P',
      ),
      home: const HomePage(),
    );
  }
}

class ViewState extends ChangeNotifier {
  // the only state we need is to know if the game is done playing
  bool _isGameDone = false;
  late List<String> _rowCategories;
  late List<String> _colCategories;

  void setGameDone(bool state) {
    _isGameDone = state;
  }

  void setRowCategories(List<String> categories) {
    print("SETTING COL CATEGORIES: $categories");
    _rowCategories = [...categories];
  }

  void setColCategories(List<String> categories) {
    print("SETTING COL CATEGORIES: $categories");
    _colCategories = [...categories];
  }

  void updateView() {
    notifyListeners();
  }

  String getRowCategory(int idx) {
    return _rowCategories[idx];
  }

  String getColCategory(int idx) {
    return _colCategories[idx];
  }

  bool get isGameDone => _isGameDone;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        color: colorScheme.onPrimaryContainer,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Pokedoku',
                  style: TextStyle(color: colorScheme.onPrimary, fontSize: 30),
                ),
              ],
            ),
            SizedBox(width: 700, height: 700, child: const GameGridUsingView()),
          ],
        ),
      ),
    );
  }
}

class GameGridUsingView extends StatelessWidget {
  const GameGridUsingView({super.key});

  // use view state for grid done
  @override
  Widget build(BuildContext context) {
    return Consumer<ViewState>(
      builder: (context, viewState, child) {
        return GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 1.5,
          children: [
            SizedBox(child: null),
            Container(
              padding: EdgeInsets.all(5),
              child: Center(
                child: GameGridText(
                  color: Colors.black12,
                  text: viewState.getColCategory(0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Center(
                child: GameGridText(
                  color: Colors.purple,
                  text: viewState.getColCategory(1),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Center(
                child: GameGridText(
                  color: Colors.blue,
                  text: viewState.getColCategory(2),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Center(
                child: GameGridText(
                  color: Colors.blue,
                  text: viewState.getRowCategory(0),
                ),
              ),
            ),
            SizedBox(
              child: GameGridPokemonCell(topLeftRadius: 16, row: 0, col: 0),
            ),
            SizedBox(child: GameGridPokemonCell(row: 0, col: 1)),
            SizedBox(child: GameGridPokemonCell(row: 0, col: 2)),
            Container(
              padding: EdgeInsets.all(15),
              child: Center(
                child: GameGridText(
                  color: Colors.blue,
                  text: viewState.getRowCategory(1),
                ),
              ),
            ),
            SizedBox(child: GameGridPokemonCell(row: 1, col: 0)),
            SizedBox(child: GameGridPokemonCell(row: 1, col: 1)),
            SizedBox(child: GameGridPokemonCell(row: 1, col: 2)),
            Container(
              padding: EdgeInsets.all(15),
              child: Center(
                child: GameGridText(
                  color: Colors.blue,
                  text: viewState.getRowCategory(2),
                ),
              ),
            ),
            SizedBox(
              child: GameGridPokemonCell(bottomLeftRadius: 16, row: 2, col: 0),
            ),
            SizedBox(child: GameGridPokemonCell(row: 2, col: 1)),
            SizedBox(
              child: GameGridPokemonCell(bottomRightRadius: 16, row: 2, col: 2),
            ),
          ],
        );
      },
    );
  }
}

class GameGridPokemonCell extends StatefulWidget {
  const GameGridPokemonCell({
    super.key,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.child,
    required this.row,
    required this.col,
  });

  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final Widget? child;
  final int row;
  final int col;

  @override
  State<GameGridPokemonCell> createState() => _GameGridPokemonCellState();
}

class _GameGridPokemonCellState extends State<GameGridPokemonCell> {
  bool _isFetching = false;
  bool _isFinal = false;
  String? _imgUrl;
  final TextEditingController _controller = TextEditingController();

  void toggleFetch() {
    setState(() {
      _isFetching = !_isFetching;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final view = Provider.of<ViewObserver>(context, listen: false);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.all(1),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: colorScheme.inversePrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(widget.bottomLeftRadius),
                  bottomRight: Radius.circular(widget.bottomRightRadius),
                  topLeft: Radius.circular(widget.topLeftRadius),
                  topRight: Radius.circular(widget.topRightRadius),
                ),
              ),
              child: Center(
                child: !_isFinal
                    ? (!_isFetching
                          ? TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Pokemon',
                                labelStyle: TextStyle(fontSize: 10),
                              ),
                              style: TextStyle(fontSize: 10),
                              onSubmitted: (textInput) async {
                                toggleFetch();
                                bool? res = await view.onConfirmInput(
                                  textInput,
                                  widget.row,
                                  widget.col,
                                ); // wait for async task

                                if (res == true) {
                                  PokemonApiFetchReturn? pokemonDetails = view
                                      .getCellData(widget.row, widget.col);
                                  _isFinal = true;
                                  _imgUrl = pokemonDetails!.imgUrl;
                                } else if (res == false) {
                                  // if it was a wrong answer, then we have to clear the text field
                                  _controller.text = '';
                                }
                                toggleFetch();
                              },
                            )
                          : CircularProgressIndicator())
                    : Image(image: NetworkImage(_imgUrl!)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GameGridText extends StatelessWidget {
  const GameGridText({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
