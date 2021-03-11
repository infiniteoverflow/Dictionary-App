import 'dart:convert';

import 'package:dictionary/dictionaryModel.dart';
import 'package:http/http.dart' as http;

Future<Dictionary> getDictionary(String word) async {
  print(word);
  String baseUrl = "https://owlbot.info/api/v4/dictionary/$word";
  var response = await http.get(Uri.parse(baseUrl),headers: {
    "Authorization": "Token d22d0fdd30e41b66f7d4c6d8bbde4ca021c0abdd"
  });

  if(response.body.contains('No definition :(')) {
    return Dictionary();
  }
  Map<String,dynamic> dictionaryResponse = json.decode(response.body);

  if(response.statusCode == 200) {
    return Dictionary.fromJson(dictionaryResponse);
  }
  return Dictionary();
}