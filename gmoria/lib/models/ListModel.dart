import 'PersonModel.dart';

class ListApp {
  String name;
  List<Person> persons;
  double score;
  int id;

  ListApp({this.name, this.persons, this.score, this.id});

  ListApp.fromJson(Map<String, dynamic> parsedJSON)
      : name = parsedJSON['name'],
        persons = parsedJSON['persons'],
        score = parsedJSON['score'];
}
