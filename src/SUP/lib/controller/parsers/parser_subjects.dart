import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:uni/model/entities/subject.dart';

Future<Map<String, String>> parseSubjects(http.Response response) async {
  final document = parse(response.body);

  final Map<String, String> subjectsStates = HashMap();

  final subjects =
  document.querySelectorAll('.estudantes-caixa-lista-cadeiras > div');

  for (int i = 0; i < subjects.length; i++) {
    final div = subjects[i];
    final subject = div.querySelector('.estudante-lista-cadeira-nome > a').text;
    final state = div.querySelectorAll('.formulario td')[3].text;

    subjectsStates.putIfAbsent(subject, () => state);
  }

  return subjectsStates;
}
