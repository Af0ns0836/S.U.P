import 'package:uni/view/Widgets/sup_course.dart';
import 'package:uni/view/Widgets/sup_main_cards_list.dart';
import 'package:uni/model/entities/course.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/subject.dart';
import '../../../testable_widget.dart';
import 'package:uni/view/Widgets/sup_subject.dart';

void main() {
  testWidgets('Add a subject', (WidgetTester tester) async {
    final Course course = Course(abbreviation: 'L.EIC', grade: 20.0);
    final List<Subject> subjects = [
      Subject(name: 'Compiladores', abbreviation: 'C', grade: 15)
    ];

    final widget = makeTestableWidget(
        child: SupSubject(course, subjects, isTesting: true
    ));

    await tester.pumpWidget(widget);
    final button = find.byKey(ValueKey('AddSubject'));

    await tester.tap(button);
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byKey(ValueKey('SaveSubjectButton')));
    await tester.pump(Duration(seconds: 2));

    final text1 = find.text('Compiladores');
    final text2 = find.text('C');
    expect(text1, findsWidgets);
    expect(text2, findsWidgets);
  });
}
