import 'package:gmoria/models/ListModel.dart';

import '../datas/data.dart' as dataPersons;

List<ListApp> list = [
  ListApp(
    id: 1,
    name: 'Silicon Valais',
    persons: dataPersons.personsList,
    score: 0,
  ),
  ListApp(
    id: 2,
    name: 'Club de ping-pong',
    persons: dataPersons.personsList,
    score: 0,
  ),
  ListApp(
    id: 3,
    name: 'Famille',
    persons: dataPersons.personsList,
    score: 0,
  ),
  ListApp(
    id: 4,
    name: 'Club water-polo',
    persons: dataPersons.personsList,
    score: 0,
  ),
];
