import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/local_storage/sup_subjects_database.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/subject.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../model/entities/course.dart';
import '../../utils/constants.dart' as Constants;
import 'sup_subject_card.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/home_page_model.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/view/Widgets/back_button_exit_wrapper.dart';
import '../../controller/local_storage/sup_subjects_database.dart';

class SupSubject extends StatelessWidget {
  Subject newSubjectData = Subject(name: '', abbreviation: '', grade: 0.0,
      ects: 6.0);
  List<Subject> subjects;
  List<Widget> subjectsCards = [];
  final isTesting;

  final Course course;

  SupSubject(this.course, subjects, {bool this.isTesting = false}) : this.subjects=subjects;

  @override
  Widget build(BuildContext context) {
    createSubjectsWidget(context);
    return Scaffold(
      body: BackButtonExitWrapper(
        context: context,
        child: mainWidgetView(context),
      ),
      floatingActionButton:
        this.isEditing(context) ? createAddSubjectButton(context) : null,
    );
  }

  Widget createAddSubjectButton(BuildContext context) {
    return FloatingActionButton(
      key: Key('AddSubject'),
      onPressed: () =>
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                        'Precisamos de alguns dados sobre a cadeira que pretendes adicionar:'),
                    content: Container(
                      child: editSubjectMenu(context, newSubjectData),
                      height: 300.0,
                      width: 100.0,
                    ),
                    actions: [
                      TextButton(
                          child: Text('Cancelar'),
                          onPressed: () =>
                              Navigator.pop(context)),
                      TextButton(
                          key: Key('SaveSubjectButton'),
                          child: Text('Guardar'),
                          onPressed: () =>

                          {if(validateDataSubject(newSubjectData)){
                            newSubjectData.view =
                                'true,' + subjects.length.toString(),
                            newSubjectData.course_id = course.id,
                            SupSubjectsDatabase().saveNewSubject(newSubjectData),
                            if(!isTesting){
                              Navigator.pushNamed(context, '/' + Constants.navSUPSubjects),
                            }
                            else{
                              Navigator.pop(context),
                            }
                          }
                          else{
                            invaliDataError(context)
                          }
                          })
                    ]);
              }), //Add FAB functionality here
      tooltip: 'Adicionar cadeira',
      child: Icon(Icons.add),
    );
  }

  Widget editSubjectMenu(BuildContext context, Subject subject) {
    List<Widget> ret = [];

    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter your subject's name",
            hintText: 'What we should refer to your subject as',
          ),
          initialValue: subject.name,
          onChanged: (String value) {
            subject.name = value;
          },
        ),
      ),
    );

    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter your subject's abbreviation",
          ),
          initialValue: subject.abbreviation,
          onChanged: (String value) {
            subject.abbreviation = value;
          },
        ),
      ),
    );

    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter your subject's grade",
            hintText: '10.0',
          ),
          initialValue: subject.grade.toStringAsFixed(1),
          onChanged: (String value) {
            subject.gradeIsUserDefined = 1;
            final value_double = double.parse(value);
            subject.grade = value_double;
            if (subject.grade == null) {
              subject.grade = 0.0;
            }
          },
        ),
      ),
    );

    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter your subject's ects",
          ),
          initialValue: subject.ects.toString(),
          onChanged: (String value) {
            final value_double = double.parse(value);
            subject.ects = value_double;
            if (subject.ects == null) {
              subject.ects = 1.5;
            }
          },
        ),
      ),
    );

    return ListView(
      children: ret,
    );
  }

  Widget mainWidgetView(BuildContext context){
    return Column(children: [
      this.createScrollableCardView(context),
      this.averageWidget(context)],

    );
  }

  Widget averageWidget(BuildContext context){
    return Container(
      child: Text(
        'Média do curso: ' + course.grade.toStringAsFixed(1),
        style: Theme.of(context).textTheme.caption.apply(fontSizeFactor: 1.5),
      ),
    );
  }

  Widget createScrollableCardView(BuildContext context) {
    final factor = 0.75;
    if(isEditing(context)){
      return Container(
        height: MediaQuery.of(context).size.height * factor,
        child: ReorderableListView(

          onReorder: ((oldIndex, newIndex) => reorderCard(oldIndex, newIndex, context)),
          header: createTopBar(context),
          children: subjectsCards,

        ),
        padding: EdgeInsets.only(bottom: 30.0),

      );
    }
    return Container(
      height: MediaQuery.of(context).size.height * factor,
      child: ReorderableListView(
        onReorder: ((oldIndex, newIndex) => null),
        header: createTopBar(context),
        children: subjectsCards,
      ),

    );
  }

  Widget createTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          course.abbreviation.substring(0, course.abbreviation.length > 10 ?
            10 :
          course.abbreviation.length).toUpperCase(),
          style: Theme.of(context).textTheme.headline6.apply(
              fontSizeFactor: 1.3,
          )
        ),
        GestureDetector(
            onTap: () =>
                StoreProvider.of<AppState>(context)
                    .dispatch(
                    SetSUPsubjectsPageEditingMode(!this.isEditing(context))),
            child: Text(this.isEditing(context) ? 'Concluir Edição' : 'Editar',
                style: Theme
                    .of(context)
                    .textTheme
                    .caption))
      ]),
    );
  }


  List<Widget> createSubjectsWidget(BuildContext context) {
    if(subjects == null || subjects == []){
      return [];//TODO display message
    }
    bool canEdit = true;
    orderSubjects();
    for(var subject in subjects) {
      final bool shouldView = subject.view.contains('true');
      if(this.isEditing(context)) {
        final Function editFunc = () => this.editSubjectFunc(context, subject);
        subjectsCards.add(
            SupSubjectCard(
                subject,
                canEdit,
                this.isEditing(context),
                () => switchSubjectDisplay(subject, context),
                shouldView,
                editFunc,
                key: Key(subject.id.toString())
            )
        );
      }
      else{
        if(shouldView){
          subjectsCards.add(
              SupSubjectCard(
                  subject,
                  canEdit,
                  this.isEditing(context),
                  null,
                  shouldView,
                  null,
                  key: Key(subject.id.toString())
              )
          );
        }
      }
    }

  }

  void orderSubjects(){
    subjects.sort((a, b) => this.compareSubjects(a, b));
  }

  int compareSubjects(Subject s1, Subject s2){
    if(s1.view.split(',').first == 'false'){
      return 1;
    }
    else{
      return s1.view.compareTo(s2.view);
    }
  }

  void switchSubjectDisplay(Subject subject, BuildContext context) {

    subject.switchView();

    SupSubjectsDatabase().saveNewSubject(subject);
    createSubjectsWidget(context);
    StoreProvider.of<AppState>(context).dispatch(null);
  }

  void reorderCard(int oldIndex, int newIndex, BuildContext context) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = subjects.removeAt(oldIndex);
    subjects.insert(newIndex, item);

    for (int i = 0; i < subjects.length; i++) {
      if (!subjects[i].view.split(',').first.contains('false')) {
        subjects[i].view = 'true,' + i.toString();
      }
    }
    SupSubjectsDatabase().saveNewSubjects(subjects);
    createSubjectsWidget(context);
    StoreProvider.of<AppState>(context).dispatch(null);
  }

  List<Subject> reorderSubject(List<Subject> subjects) {
    final List<Subject> newSubjects = [];
    for (var subject in subjects) {
      final viewStatus = subject.view.split(',');

      // check view status
      if (!viewStatus.first.toLowerCase().contains('true')) {
        continue;
      }

      if (viewStatus.length > 1) {
        if (int.parse(viewStatus[1]) > newSubjects.length) {
          newSubjects.add(subject);
        }
        else {
          newSubjects.insert(int.parse(viewStatus[1]), subject);
        }
      }
      else {
        newSubjects.add(subject);
      }
    }
    return newSubjects;
  }

  void editSubjectFunc(BuildContext context, Subject subject){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'Que informações sobre a cadeira pretendes mudar?'),
              content: Container(
                child: editSubjectMenu(context, subject),
                height: 300.0,
                width: 100.0,
              ),
              actions: [
                TextButton(
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.pop(context)),
                TextButton(
                    child: Text('Guardar'),
                    onPressed: () => {
                      if(validateDataSubject(subject)){
                        SupSubjectsDatabase().saveNewSubject(subject),
                        if(!isTesting){
                          Navigator.pushNamed(context, '/' + Constants.navSUPSubjects),
                        }
                        else{
                          Navigator.pop(context),
                        }}
                      else{
                        invaliDataError(context)
                      }
                    })
              ]);
        }
    );
  }

  bool validateDataSubject(Subject subject){
    if(subject.name == null||
        subject.abbreviation == null||
        subject.grade == null||
        subject.ects == null||
        subject.grade < 0.00||
        subject.grade >20.00||
        subject.ects < 0.5||
        subject.ects > 60||
        hasNumbers(subject.name)==true||
        hasNumbers(subject.abbreviation)==true){
      return false;
    }
    return true;
  }

  bool isEditing(context) {
    if (isTesting) return true;
    final bool result = StoreProvider
        .of<AppState>(context)
        .state
        .content['SUPsubjectsPageEditingMode'];
    if (result == null) return false;
    return result;
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

  void invaliDataError(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'Por favor, certifica-te que: \n\n    -nem o nome do curso nem a '
                      'abreviação do mesmo têm números'
                      '\n\n   -a média inserida é um número entre 0.00 e 20.00'
                      '\n\n   -os ects estão entre 0.5 e 60'),
              actions: [
                TextButton(
                    child: Text('Fechar'),
                    onPressed: () => Navigator.pop(context)),
              ]);
        }
    );
  }
}
