import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/subject.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/back_button_exit_wrapper.dart';
import 'package:uni/view/Widgets/sup_course.dart';

import '../../controller/local_storage/app_courses_database.dart';

class SupMainCardsList extends StatelessWidget {
  Course newCourseData = Course(name:'', abbreviation: '', grade:0.0);
  List<Widget> coursesCards = [];
  List<Course> courses;
  final isTesting;

  SupMainCardsList(courses, {bool this.isTesting = false})
      : this.courses = courses;

  @override
  Widget build(BuildContext context) {
    createCoursesWidget(context);
    return Scaffold(
      body: BackButtonExitWrapper(
        context: context,
        child: createScrollableCardView(context),
      ),
      floatingActionButton:
          this.isEditing(context) ? createAddCourseButton(context) : null,
    );
  }

  Widget createAddCourseButton(BuildContext context) {
    return FloatingActionButton(
      key: Key('AddCourse'),
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    'Precisamos de alguns dados sobre o curso que pretendes adicionar:'),
                content: Container(
                  child: editCourseMenu(context, newCourseData),
                  height: 240.0,
                  width: 100.0,
                ),
                actions: [
                  TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.pop(context)),
                  TextButton(
                      key: Key("SaveButton"),
                      child: Text('Guardar'),
                      onPressed: () => {
                            if(validateData(newCourseData)){
                                newCourseData.view =
                                  'true,' + courses.length.toString(),
                                AppCoursesDatabase().saveNewCourse(newCourseData),
                                if(!isTesting){
                                  Navigator.pushNamed(context, '/' + Constants.navSUP),
                                }
                                else{
                                  Navigator.pop(context),
                                }
                            }else{invaliDataError(context)}
                          })
                ]);
          }), //Add FAB functionality here
      tooltip: 'Adicionar curso',
      child: Icon(Icons.add),
    );
  }

  Widget editCourseMenu(BuildContext context, Course course) {
    final List<Widget> ret = [];

    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          key: Key("CourseName"),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Course name',
            hintText: 'What we should refer to your course as',
          ),
          initialValue: course.name,
          onChanged: (String value) {
            course.name = value;
          },
        ),
      ),
    );

    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          key: Key("CourseAbrev"),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter your course's abbreviation",
            hintText: 'What we should use to quickly refer to your course',
          ),
          initialValue: course.abbreviation,
          onChanged: (String value) {
            course.abbreviation = value;
          },
        ),
      ),
    );

    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          key: Key("CourseGrade"),
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Enter your course's grade",
              hintText: 'What you grade on this course currently is'),
          initialValue: course.grade.toString(),
          onChanged: (String value) {
            final value_double = double.parse(value);
            course.grade = value_double;
            if (course.grade == null) {
              course.grade = 0.0;
            }
          },
        ),
      ),
    );
    return ListView(
      children: ret,
    );
  }

  Widget createScrollableCardView(BuildContext context) {
    if (isEditing(context)) {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: ReorderableListView(
          onReorder: ((oldIndex, newIndex) =>
              reorderCard(oldIndex, newIndex, context)),
          header: createTopBar(context),
          children: coursesCards,
        ),
        padding: EdgeInsets.only(bottom: 50.0),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ReorderableListView(
        onReorder: ((oldIndex, newIndex) => null),
        header: createTopBar(context),
        children: coursesCards,
      ),
    );
  }

  Widget createTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          Constants.SUPfull,
          style:
              Theme.of(context).textTheme.headline6.apply(fontSizeFactor: 1.3),
        ),
        GestureDetector(
            key: Key("EditMode"),
            onTap: () => StoreProvider.of<AppState>(context)
                .dispatch(SetSUPHomePageEditingMode(!this.isEditing(context))),
            child: Text(this.isEditing(context) ? 'Concluir Edição' : 'Editar',
                style: Theme.of(context).textTheme.caption))
      ]),
    );
  }

  List<Widget> createCoursesWidget(BuildContext context) {
    orderCourses();
    for(var course in courses){
      bool canEdit = true;
      course.view.contains('fromJson') ? canEdit = false: canEdit = true;
      final bool shouldView = course.view.contains('true');
      if(isEditing(context)) {
        final Function editFunc =  course.view.contains('fromJson') ?
            () {
                //canEdit = false;
                print(course.view);
                this.notAbleToEditMessage(context);
            } :
            (){
                print(course.view);
                this.editCourseFunc(context, course);
          };
        coursesCards.add(
            SupCourseCard(
                course,
                canEdit,
                this.isEditing(context),
                () => switchCourseDisplay(course, context),
                shouldView,
                editFunc,
                key: Key(course.id.toString())
            )
        );
      }
      else{
        if(shouldView){
          coursesCards.add(
              SupCourseCard(
                  course,
                  canEdit,
                  this.isEditing(context),
                  null,
                  shouldView,
                  null,
                  key: Key(course.id.toString())
              )
          );
        }
      }
    }
  }

  void orderCourses(){
    courses.sort((a, b) => this.compareCourses(a, b));
  }

  int compareCourses(Course c1, Course c2){
    if(c1.view.split(',').first == 'false'){
      return 1;
    } else {
      return c1.view.compareTo(c2.view);
    }
  }

  void reorderCard(int oldIndex, int newIndex, BuildContext context) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = courses.removeAt(oldIndex);
    courses.insert(newIndex, item);

    for (int i = 0; i < courses.length; i++) {
      if (!courses[i].view.contains('false')) {
        if (courses[i].view.contains('fromJson')) {
          courses[i].view = 'true,' + i.toString() + ',fromJson';
        } else {
          courses[i].view = 'true,' + i.toString();
        }
      }
    }
    AppCoursesDatabase().saveNewCourses(courses);
    createCoursesWidget(context);
    StoreProvider.of<AppState>(context).dispatch(null);
  }

  void switchCourseDisplay(Course course, BuildContext context) {
    course.switchView();

    AppCoursesDatabase().saveNewCourse(course);
    createCoursesWidget(context);
    StoreProvider.of<AppState>(context).dispatch(null);
  }

  bool isEditing(context) {
    if(isTesting) return true;
    final bool result = StoreProvider.of<AppState>(context)
        .state
        .content['SUPhomePageEditingMode'];
    if (result == null) return false;
    return result;
  }

  void editCourseFunc(BuildContext context, Course course) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Que informações sobre o curso pretendes mudar?'),
              content: Container(
                child: editCourseMenu(context, course),
                height: 240.0,
                width: 100.0,
              ),
              actions: [
                TextButton(
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.pop(context)),
                TextButton(
                    child: Text('Guardar'),
                    onPressed: () => {
                      if(validateData(course) == true){
                        debugPrint(
                            'GuardarPrint: ' + course.grade.toString()),
                        AppCoursesDatabase().saveNewCourse(course),
                        Navigator.pop(context)
                      }else{
                        invaliDataError(context)
                      }
                    })
              ]);
        });
  }

  void notAbleToEditMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Não podes alterar as informações deste curso'),
              actions: [
                TextButton(
                    child: Text('Fechar'),
                    onPressed: () => Navigator.pop(context)),
              ]);
        });
  }

  bool hasNumbers(String s){
    List<String> integers = ["0","1","2","3","4","5","6","7","8","9"];
    for(int i = 0; i < s.length; i++){
      if(integers.contains(s[i])){
        return true;
      }
    }
    return false;
  }


  bool validateData(Course course){
    if(course.name == null||
        course.abbreviation == null||
        course.grade == null||
        course.grade < 0.00||
        course.grade >20.00||
        hasNumbers(course.name)==true||
        hasNumbers(course.abbreviation)==true){
        return false;
    }
    return true;
  }



  void invaliDataError(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'Por favor, certifica-te que: \n\n    -nem o nome do curso nem a '
                      'abreviação do mesmo têm números'
                      '\n\n   -a média inserida é um número entre 0.00 e 20.00'),
              actions: [
                TextButton(
                    child: Text('Fechar'),
                    onPressed: () => Navigator.pop(context)),
              ]);
        }
    );
  }




}
