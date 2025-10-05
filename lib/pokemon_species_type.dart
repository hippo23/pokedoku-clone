// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

PokemonSpecies speciesFromString(String str) =>
    PokemonSpecies.fromJson(json.decode(str));

String stringFromSpecies(PokemonSpecies data) => json.encode(data.toJson());

class PokemonSpecies {
  int? id;
  String? name;
  int? order;
  int? genderRate;
  int? captureRate;
  int? baseHappiness;
  bool? isBaby;
  bool? isLegendary;
  bool? isMythical;
  int? hatchCounter;
  bool? hasGenderDifferences;
  bool? formsSwitchable;
  Color? growthRate;
  List<PokedexNumber>? pokedexNumbers;
  List<Color>? eggGroups;
  Color? color;
  Color? shape;
  Color? evolvesFromSpecies;
  EvolutionChain? evolutionChain;
  dynamic habitat;
  Color? generation;
  List<Name>? names;
  List<FlavorTextEntry>? flavorTextEntries;
  List<FormDescription>? formDescriptions;
  List<Genus>? genera;
  List<Variety>? varieties;

  PokemonSpecies({
    this.id,
    this.name,
    this.order,
    this.genderRate,
    this.captureRate,
    this.baseHappiness,
    this.isBaby,
    this.isLegendary,
    this.isMythical,
    this.hatchCounter,
    this.hasGenderDifferences,
    this.formsSwitchable,
    this.growthRate,
    this.pokedexNumbers,
    this.eggGroups,
    this.color,
    this.shape,
    this.evolvesFromSpecies,
    this.evolutionChain,
    this.habitat,
    this.generation,
    this.names,
    this.flavorTextEntries,
    this.formDescriptions,
    this.genera,
    this.varieties,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) => PokemonSpecies(
    id: json["id"],
    name: json["name"],
    order: json["order"],
    genderRate: json["gender_rate"],
    captureRate: json["capture_rate"],
    baseHappiness: json["base_happiness"],
    isBaby: json["is_baby"],
    isLegendary: json["is_legendary"],
    isMythical: json["is_mythical"],
    hatchCounter: json["hatch_counter"],
    hasGenderDifferences: json["has_gender_differences"],
    formsSwitchable: json["forms_switchable"],
    growthRate: json["growth_rate"] == null
        ? null
        : Color.fromJson(json["growth_rate"]),
    pokedexNumbers: json["pokedex_numbers"] == null
        ? []
        : List<PokedexNumber>.from(
            json["pokedex_numbers"]!.map((x) => PokedexNumber.fromJson(x)),
          ),
    eggGroups: json["egg_groups"] == null
        ? []
        : List<Color>.from(json["egg_groups"]!.map((x) => Color.fromJson(x))),
    color: json["color"] == null ? null : Color.fromJson(json["color"]),
    shape: json["shape"] == null ? null : Color.fromJson(json["shape"]),
    evolvesFromSpecies: json["evolves_from_species"] == null
        ? null
        : Color.fromJson(json["evolves_from_species"]),
    evolutionChain: json["evolution_chain"] == null
        ? null
        : EvolutionChain.fromJson(json["evolution_chain"]),
    habitat: json["habitat"],
    generation: json["generation"] == null
        ? null
        : Color.fromJson(json["generation"]),
    names: json["names"] == null
        ? []
        : List<Name>.from(json["names"]!.map((x) => Name.fromJson(x))),
    flavorTextEntries: json["flavor_text_entries"] == null
        ? []
        : List<FlavorTextEntry>.from(
            json["flavor_text_entries"]!.map(
              (x) => FlavorTextEntry.fromJson(x),
            ),
          ),
    formDescriptions: json["form_descriptions"] == null
        ? []
        : List<FormDescription>.from(
            json["form_descriptions"]!.map((x) => FormDescription.fromJson(x)),
          ),
    genera: json["genera"] == null
        ? []
        : List<Genus>.from(json["genera"]!.map((x) => Genus.fromJson(x))),
    varieties: json["varieties"] == null
        ? []
        : List<Variety>.from(
            json["varieties"]!.map((x) => Variety.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "order": order,
    "gender_rate": genderRate,
    "capture_rate": captureRate,
    "base_happiness": baseHappiness,
    "is_baby": isBaby,
    "is_legendary": isLegendary,
    "is_mythical": isMythical,
    "hatch_counter": hatchCounter,
    "has_gender_differences": hasGenderDifferences,
    "forms_switchable": formsSwitchable,
    "growth_rate": growthRate?.toJson(),
    "pokedex_numbers": pokedexNumbers == null
        ? []
        : List<dynamic>.from(pokedexNumbers!.map((x) => x.toJson())),
    "egg_groups": eggGroups == null
        ? []
        : List<dynamic>.from(eggGroups!.map((x) => x.toJson())),
    "color": color?.toJson(),
    "shape": shape?.toJson(),
    "evolves_from_species": evolvesFromSpecies?.toJson(),
    "evolution_chain": evolutionChain?.toJson(),
    "habitat": habitat,
    "generation": generation?.toJson(),
    "names": names == null
        ? []
        : List<dynamic>.from(names!.map((x) => x.toJson())),
    "flavor_text_entries": flavorTextEntries == null
        ? []
        : List<dynamic>.from(flavorTextEntries!.map((x) => x.toJson())),
    "form_descriptions": formDescriptions == null
        ? []
        : List<dynamic>.from(formDescriptions!.map((x) => x.toJson())),
    "genera": genera == null
        ? []
        : List<dynamic>.from(genera!.map((x) => x.toJson())),
    "varieties": varieties == null
        ? []
        : List<dynamic>.from(varieties!.map((x) => x.toJson())),
  };
}

class Color {
  String? name;
  String? url;

  Color({this.name, this.url});

  factory Color.fromJson(Map<String, dynamic> json) =>
      Color(name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

class EvolutionChain {
  String? url;

  EvolutionChain({this.url});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) =>
      EvolutionChain(url: json["url"]);

  Map<String, dynamic> toJson() => {"url": url};
}

class FlavorTextEntry {
  String? flavorText;
  Color? language;
  Color? version;

  FlavorTextEntry({this.flavorText, this.language, this.version});

  factory FlavorTextEntry.fromJson(Map<String, dynamic> json) =>
      FlavorTextEntry(
        flavorText: json["flavor_text"],
        language: json["language"] == null
            ? null
            : Color.fromJson(json["language"]),
        version: json["version"] == null
            ? null
            : Color.fromJson(json["version"]),
      );

  Map<String, dynamic> toJson() => {
    "flavor_text": flavorText,
    "language": language?.toJson(),
    "version": version?.toJson(),
  };
}

class FormDescription {
  String? description;
  Color? language;

  FormDescription({this.description, this.language});

  factory FormDescription.fromJson(Map<String, dynamic> json) =>
      FormDescription(
        description: json["description"],
        language: json["language"] == null
            ? null
            : Color.fromJson(json["language"]),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "language": language?.toJson(),
  };
}

class Genus {
  String? genus;
  Color? language;

  Genus({this.genus, this.language});

  factory Genus.fromJson(Map<String, dynamic> json) => Genus(
    genus: json["genus"],
    language: json["language"] == null
        ? null
        : Color.fromJson(json["language"]),
  );

  Map<String, dynamic> toJson() => {
    "genus": genus,
    "language": language?.toJson(),
  };
}

class Name {
  String? name;
  Color? language;

  Name({this.name, this.language});

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    name: json["name"],
    language: json["language"] == null
        ? null
        : Color.fromJson(json["language"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "language": language?.toJson(),
  };
}

class PokedexNumber {
  int? entryNumber;
  Color? pokedex;

  PokedexNumber({this.entryNumber, this.pokedex});

  factory PokedexNumber.fromJson(Map<String, dynamic> json) => PokedexNumber(
    entryNumber: json["entry_number"],
    pokedex: json["pokedex"] == null ? null : Color.fromJson(json["pokedex"]),
  );

  Map<String, dynamic> toJson() => {
    "entry_number": entryNumber,
    "pokedex": pokedex?.toJson(),
  };
}

class Variety {
  bool? isDefault;
  Color? pokemon;

  Variety({this.isDefault, this.pokemon});

  factory Variety.fromJson(Map<String, dynamic> json) => Variety(
    isDefault: json["is_default"],
    pokemon: json["pokemon"] == null ? null : Color.fromJson(json["pokemon"]),
  );

  Map<String, dynamic> toJson() => {
    "is_default": isDefault,
    "pokemon": pokemon?.toJson(),
  };
}
