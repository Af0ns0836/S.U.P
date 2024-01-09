import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/entities/course.dart';
import 'package:flutter/material.dart';
import '../../model/app_state.dart';
import '../../redux/actions.dart';
import '../../utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/SupGenericCard.dart';
import '../../utils/constants.dart' as Constants;

class SupCourseCard extends SupGenericCard {
  final Course course;

  Course courseData = Course();
  final bool canEdit;
  final bool isEditing;
  final bool viewStatus;
  final Function onDelete;
  final Function editCourseInfo;

  SupCourseCard(this.course,this.canEdit, this.isEditing, this.onDelete,
      this.viewStatus, this.editCourseInfo, {Key key})
      : super.fromEditingInformation(key,isEditing, onDelete, editCourseInfo,
        viewStatus, canEdit);

  String getCourseAbbreviation(){
    final List<String> words = course.name.split(' ');
    String firstLetter = '';

    if (words[0] == course.name) {
      return course.name.toUpperCase();
    }

    for (String word in words) {
      firstLetter += word[0].toUpperCase();
    }
    return firstLetter;
  }

  @override
  Widget buildCardContent(BuildContext context) {
    Key("caixa");
    final List<Widget> result = [];
    result.add(Container(
        alignment: Alignment.centerLeft, child: Text(course.name.toString())));
    if (course.grade == null) {
      course.grade = 0.0;
      result.add(Text(
        course.grade.toString(),
        textScaleFactor: 1.5,
      ));
    } else {
      result.add(Text(
        course.grade.toStringAsFixed(1),
        textScaleFactor: 1.5,
      )
      );
    }

    //result.add(Text(course.view));

    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        //decoration: BoxDecoration(color: Colors.yellow),
        child: Column(children: result),
      ),
    );
  }

  @override
  String getTitle() {
    return this.course.abbreviation != '' && this.course.abbreviation != null ?
    this.course.abbreviation.toUpperCase() : getCourseAbbreviation();
  }

  @override
  onClick(BuildContext context) => {
    Navigator.pushNamed(context, '/' + Constants.navSUPSubjects),
    StoreProvider.of<AppState>(context).dispatch(SetCourseToView(this.course))
  };
}
