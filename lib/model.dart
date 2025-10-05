import 'dart:math';
import 'package:pokedoku/pokeapi.dart';

class PokedokuModel {
  final int _row = 3;
  final int _col = 3;
  int _attempts = 0;
  final List<PokemonApiFetchReturn?> _gameGrid = [];
  List<String> _rowCategories = [];
  List<String> _colCategories = [];

  PokedokuModel(Random seed) {
    for (int i = 0; i < _row * _col; i++) {
      _gameGrid.add(null);
    }

    List<String> categories = [
      "normal",
      "fighting",
      "flying",
      "poison",
      "ground",
      "rock",
      "bug",
      "ghost",
      "steel",
      "fire",
      "water",
      "grass",
      "electric",
      "psychic",
      "dragon",
      "dark",
      "fairy",
      "generation-i",
      "generation-ii",
      "generation-iii",
      "generation-iv",
      "generation-v",
      "generation-vi",
      "generation-vii",
      "generation-viii",
      "generation-ix",
    ];

    for (int i = 0; i < categories.length - 1; i++) {
      int randomInt = seed.nextInt(categories.length);
      String temp = categories[randomInt];
      categories[randomInt] = categories[i];
      categories[i] = temp;
    }

    _rowCategories = categories.sublist(0, 3);
    _colCategories = categories.sublist(3, 6);
  }

  String? getAnswer(int row, int col) {
    if (row * col >= _row * _col) return null;

    var cell = _gameGrid[(_col * row) + col];
    if (cell == null) {
      return null;
    } else {
      return cell.name;
    }
  }

  PokemonApiFetchReturn? getFullAnswer(int row, int col) {
    if (row * col >= _row * _col) return null;

    return _gameGrid[(_col * row) + col];
  }

  Future<bool?> inputAnswer(String pokemon, int row, int col) async {
    if (row * col >= _row * _col) return Future.value(null);

    _attempts++;

    // get the data of the pokemon
    PokemonApi api = PokemonApi();

    PokemonApiFetchReturn? fetchedPokemon = await api.getPokemonDetails(
      pokemon,
    );

    // if it wasn't a valid pokemon, just return null
    if (fetchedPokemon == null) {
      return Future.value(null);
    }

    // otherwise, we check its data
    String rowCategory = _rowCategories[row];
    String colCategory = _colCategories[col];

    // to adhere to the open-closed principle, we just check all the types
    // and the generation of the pokemon

    if ((rowCategory == fetchedPokemon.generation ||
            fetchedPokemon.types.contains(rowCategory)) &&
        (colCategory == fetchedPokemon.generation ||
            fetchedPokemon.types.contains(colCategory))) {
      _gameGrid[(row * _col) + (col)] = fetchedPokemon;
      return true;
    }

    return false;
  }

  int get rowCount => _row;
  int get colCount => _col;
  int get attempts => _attempts;
  bool get isGameDone => !(_gameGrid.contains(null));
  List<String> get getRowCategoryNames => _rowCategories;
  List<String> get getColCategoryNames => _colCategories;
}
