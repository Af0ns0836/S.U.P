import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/local_storage/sup_subjects_database.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

import '../../model/app_state.dart';
import '../../model/entities/course.dart';
import '../../model/entities/subject.dart';
import '../Widgets/sup_main_cards_list.dart';
import '../Widgets/sup_subject.dart';
import 'general_page_view.dart';


class SupSubjectPageView extends StatefulWidget {

 SupSubjectPageView(
      {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SupSubjectPageViewState();

}


class SupSubjectPageViewState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    final Course course = StoreProvider.of<AppState>(context)
        .state
        .content['CourseToView'];
    return FutureBuilder(
        future: SupSubjectsDatabase().subjects(course.id),
        builder: (context, value) {
          if (value.hasData) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: SupSubject(course, value.data),
            );
          }
          else {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),

                child: CircularProgressIndicator());
          }
        }
    );
  }
}