class Definition {
  final String? type;
  final String? definition;
  final String? example;
  final String? imageUrl;
  final String? emoji;

  Definition({this.type, this.definition,
    this.example, this.imageUrl, this.emoji});

  factory Definition.fromJson(Map<String,dynamic> json) {
    print(json);
    return Definition(
      type: json['type'],
      definition: json['definition'],
      example: json['example'],
      imageUrl: json['image_url'],
      emoji: json['emoji']
    );
  }
}

class Definitions {
  List<Definition> definitions;

  Definitions({required this.definitions});

  factory Definitions.fromList(List<dynamic> lists) {
    return Definitions(
      definitions: lists.map((e) => Definition.fromJson(e)).toList(),
    );
  }
}

class Dictionary {
  Definitions? definitions;
  String? word;
  String? pronunciation;

  Dictionary({this.definitions,this.word,this.pronunciation});
  
  factory Dictionary.fromJson(Map<String,dynamic> json) {
    return Dictionary(
      definitions: Definitions.fromList(json['definitions']),
      word: json['word'],
      pronunciation: json['pronunciation'],
    );
  }
}