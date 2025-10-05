import 'package:pokedoku/controller.dart';
import 'package:pokedoku/model.dart';
import 'package:pokedoku/view.dart';
import 'dart:math';

void main(List<String> args) {
  Random seed = Random(150);
  PokedokuView view = PokedokuView();
  PokedokuModel model = PokedokuModel(seed);
  PokedokuController controller = PokedokuController(model, view);
  controller.start();
}
