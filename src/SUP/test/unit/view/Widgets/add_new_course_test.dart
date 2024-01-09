import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/sup_course.dart';
import 'package:uni/view/Widgets/sup_main_cards_list.dart';
import '../../../testable_widget.dart';
import 'package:uni/model/entities/course.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/view/Widgets/sup_main_cards_list.dart';

void main() {
  testWidgets('Add a course', (WidgetTester tester) async {
    final List<Course> courses = [
      Course(name: 'Engenharia', abbreviation: 'ESOF', grade: 20)
    ];
    final widget =
        makeTestableWidget(child: SupMainCardsList(courses, isTesting: true));
    await tester.pumpWidget(widget);

    final button = find.byKey(ValueKey('AddCourse'));

    //act
    await tester.tap(button);
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byKey(ValueKey('SaveButton')));
    await tester.pump(Duration(seconds: 2));

    //assert
    final text1 = find.text('Engenharia');
    final text2 = find.text('ESOF');
    expect(text1, findsWidgets);
    expect(text2, findsWidgets);
  });
}
