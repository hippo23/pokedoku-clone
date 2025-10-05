import 'package:http/http.dart' as http;
import 'package:pokedoku/pokemon_species_type.dart';
import 'package:pokedoku/pokemon_type.dart';
import 'dart:convert';

String prettyJson(dynamic json) {
  var spaces = ' ' * 4;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

Future<Pokemon?> getPokemon(String key, bool isUrl) async {
  http.Response response;

  if (isUrl) {
    response = await http.get(Uri.parse(key));
  } else {
    response = await http.get(
      Uri.parse("https://pokeapi.co/api/v2/pokemon/$key/"),
    );
  }

  if (response.statusCode == 200) {
    // get the types and generation
    Pokemon pokemon = stringToPokemon(response.body);

    return pokemon;
  }

  return null;
}

Future<PokemonSpecies?> getPokemonSpecies(String key, bool isUrl) async {
  http.Response response;

  if (isUrl) {
    response = await http.get(Uri.parse(key));
  } else {
    response = await http.get(
      Uri.parse("https://pokeapi.co/api/v2/pokemon-species/$key/"),
    );
  }

  if (response.statusCode == 200) {
    // get the types and generation
    PokemonSpecies pokemon = speciesFromString(response.body);

    return pokemon;
  }

  return null;
}

// local type for the return value of the API
class PokemonApiFetchReturn {
  List<String> types;
  String generation;
  String imgUrl;
  String name;

  PokemonApiFetchReturn({
    required this.types,
    required this.generation,
    required this.imgUrl,
    required this.name,
  });
}

class PokemonApi {
  Future<PokemonApiFetchReturn?> getPokemonDetails(String name) async {
    // get the pokemon first, then the generation
    final Pokemon? pokemon = await getPokemon(name, false);
    if (pokemon == null) {
      return null;
    }

    final PokemonSpecies? species = await getPokemonSpecies(
      pokemon.species!.url!,
      true,
    );

    if (species == null) {
      return null;
    }

    List<String> types = [];
    for (var type in pokemon.types!) {
      types.add(type.type!.name!);
    }
    String generation = species.generation!.name!;
    String imgUrl = pokemon.sprites!.frontDefault!;

    final PokemonApiFetchReturn res = PokemonApiFetchReturn(
      types: types,
      generation: generation,
      imgUrl: imgUrl,
      name: name,
    );

    return res;
  }
}
