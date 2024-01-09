import 'dart:html';
import 'dart:io';

import 'package:redux/redux.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/view/Widgets/sup_main_cards_list.dart';

class MockStore extends Mock implements Store<AppState> {}

class ParserMock extends Mock implements ParserExams {}

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class MockScheduleFetcher extends Mock implements ScheduleFetcher {}

class MockState extends Mock implements SetSUPHomePageEditingMode {
  @override
  bool state = true;
  SetCardEditingMode(state);
}
