import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  var model = DemoModel();
  var view = DemoView();
  var controller = DemoController(model, view);

  controller.start();
}

class FlutterApp extends StatelessWidget {
  const FlutterApp(this._view, this._viewState, {super.key});
  final ViewState _viewState;
  final DemoView _view;

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

class DemoModel {
  int _sum;
  bool _isInputShown;

  DemoModel() : _sum = 0, _isInputShown = true;

  int get sum => _sum;
  bool get isInputShown => _isInputShown;

  bool addInput(String input) {
    var x = int.tryParse(input);
    if (x == null) return false;

    _sum += x;

    return true;
  }

  void toggleVisibility() {
    _isInputShown = !_isInputShown;
  }
}

class DemoController implements ViewObserver {
  final DemoModel _model;
  final DemoView _view;

  DemoController(this._model, this._view);

  void start() {
    _view.addObserver(this);
    _view.start(_model.sum, _model.isInputShown);
  }

  @override
  Future<void> onConfirmInput(String input) async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void onToggleButtonPress() {
    _model.toggleVisibility();

    if (_model.isInputShown) {
      _view.setInputVisibility(true);
    } else {
      _view.setInputVisibility(false);
    }
  }
}

abstract interface class ViewObserver {
  void onToggleButtonPress();

  Future<void> onConfirmInput(String input);
}

class DemoView {
  final List<ViewObserver> _observers;
  ViewState? _viewState;

  DemoView() : _observers = [];

  void addObserver(ViewObserver observer) {
    _observers.add(observer);
  }

  void start(int sum, bool isInputShown) {
    var viewState = ViewState(sum, isInputShown);
    _viewState = viewState;

    runApp(
      MultiProvider(
        providers: [
          Provider.value(value: this), // makes DemoView available
        ],
        child: FlutterApp(this, viewState),
      ),
    );
  }

  void setInputVisibility(bool isShown) {
    _viewState?.isInputShown = isShown;

    _viewState?.updateView();
  }

  void updateSum(int sum) {
    _viewState?.sum = sum;
    _viewState?.controller.clear();

    _viewState?.updateView();
  }

  void onToggleButtonPress() {
    for (var observer in _observers) {
      observer.onToggleButtonPress();
    }
  }

  Future<void> onConfirmInput(String input) async {
    for (var observer in _observers) {
      await observer.onConfirmInput(input);
    }
  }
}

class ViewState extends ChangeNotifier {
  int sum;
  bool isInputShown;
  TextEditingController controller;

  ViewState(this.sum, this.isInputShown) : controller = TextEditingController();

  void updateView() {
    notifyListeners();
  }
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

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                SizedBox(height: 100),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: GameGridText(color: Colors.black12, text: 'Johto'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: GameGridText(color: Colors.purple, text: 'Ground'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: GameGridText(color: Colors.blue, text: 'Flying'),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  height: 140,
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: GameGridText(color: Colors.brown, text: 'Ground'),
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: GameGridPokemonCell(topLeftRadius: 16),
                ),
                SizedBox(height: 140, child: GameGridPokemonCell()),
                SizedBox(
                  height: 140,
                  child: GameGridPokemonCell(topRightRadius: 16),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  height: 140,
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: GameGridText(color: Colors.lightBlue, text: 'Ice'),
                  ),
                ),
                SizedBox(height: 140, child: GameGridPokemonCell()),
                SizedBox(height: 140, child: GameGridPokemonCell()),
                SizedBox(height: 140, child: GameGridPokemonCell()),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  height: 140,
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: GameGridText(color: Colors.red, text: 'Fire'),
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: GameGridPokemonCell(bottomLeftRadius: 16),
                ),
                SizedBox(height: 140, child: GameGridPokemonCell()),
                SizedBox(
                  height: 140,
                  child: GameGridPokemonCell(bottomRightRadius: 16),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class GameGridUsingView extends StatelessWidget {
  const GameGridUsingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      childAspectRatio: 1.5,
      children: [
        SizedBox(child: null),
        Container(
          padding: EdgeInsets.all(5),
          child: Center(
            child: GameGridText(color: Colors.black12, text: 'Johto'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Center(
            child: GameGridText(color: Colors.purple, text: 'Poison'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Center(
            child: GameGridText(color: Colors.blue, text: 'Flying'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Center(
            child: GameGridText(color: Colors.blue, text: 'Flying'),
          ),
        ),
        SizedBox(child: GameGridPokemonCell(topLeftRadius: 16)),
        SizedBox(child: GameGridPokemonCell()),
        SizedBox(child: GameGridPokemonCell(topRightRadius: 16)),
        Container(
          padding: EdgeInsets.all(15),
          child: Center(
            child: GameGridText(color: Colors.blue, text: 'Flying'),
          ),
        ),
        SizedBox(child: GameGridPokemonCell()),
        SizedBox(child: GameGridPokemonCell()),
        SizedBox(child: GameGridPokemonCell()),
        Container(
          padding: EdgeInsets.all(15),
          child: Center(
            child: GameGridText(color: Colors.blue, text: 'Flying'),
          ),
        ),
        SizedBox(child: GameGridPokemonCell(bottomLeftRadius: 16)),
        SizedBox(child: GameGridPokemonCell()),
        SizedBox(child: GameGridPokemonCell(bottomRightRadius: 16)),
      ],
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
  });

  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final Widget? child;

  @override
  State<GameGridPokemonCell> createState() => _GameGridPokemonCellState();
}

class _GameGridPokemonCellState extends State<GameGridPokemonCell> {
  bool _isFetching = false;

  void toggleFetch() {
    setState(() {
      _isFetching = !_isFetching;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final view = Provider.of<DemoView>(context, listen: false);
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
                child: !_isFetching
                    ? TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pokemon',
                          labelStyle: TextStyle(fontSize: 10),
                        ),
                        style: TextStyle(fontSize: 10),
                        onSubmitted: (textInput) async {
                          toggleFetch();
                          await view.onConfirmInput(
                            textInput,
                          ); // wait for async task
                          toggleFetch();
                        },
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SelectPokemonPopup extends StatelessWidget {
  const SelectPokemonPopup({super.key, required this.conditions});

  final Map<String, dynamic> conditions;

  @override
  Widget build(BuildContext context) {
    return SizedBox();
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
