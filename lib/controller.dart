import 'package:pokedoku/view.dart';
import 'package:pokedoku/model.dart';
import 'package:pokedoku/pokeapi.dart';

class PokedokuController implements ViewObserver {
  final PokedokuModel _model;
  final PokedokuView _view;

  PokedokuController(this._model, this._view);

  void start() {
    _view.attachObserver(this);
    _view.setRowCategories(_model.getRowCategoryNames);
    _view.setColCategories(_model.getColCategoryNames);
    _view.start();
  }

  @override
  Future<bool?> onConfirmInput(String input, int row, int col) async {
    // we can fetch the pokemon here
    return await _model.inputAnswer(input, row, col);
  }

  @override
  PokemonApiFetchReturn? getCellData(int row, int col) {
    return _model.getFullAnswer(row, col);
  }
}

abstract interface class ViewObserver {
  Future<bool?> onConfirmInput(String input, int row, int col);
  PokemonApiFetchReturn? getCellData(int row, int col);
}
