import 'package:uni/controller/local_storage/sup_components_database.dart';
import 'package:uni/main.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/component.dart';
import 'package:uni/view/Widgets/sup_component_widget.dart';
import '../../controller/local_storage/sup_subjects_database.dart';
import '../../redux/actions.dart';
import 'SupGenericCard.dart';
import 'package:uni/model/entities/subject.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class SupSubjectCard extends SupGenericCard {
  final Subject subject;
  final bool canEdit;
  final bool isEditing;
  final Function onDelete;
  final bool viewStatus;
  final Function editSubjectInfo;

  SupSubjectCard(this.subject, this.canEdit, this.isEditing, this.onDelete, this.viewStatus,
      this.editSubjectInfo, {Key key}) :
        super.fromEditingInformation(key, isEditing, onDelete, editSubjectInfo,
            viewStatus, canEdit);

  @override
  String getTitle() {
    return this.subject.abbreviation != '' && this.subject.abbreviation != null ?
    this.subject.abbreviation.toUpperCase() : getSubjectAbbreviation();
  }

  String getSubjectAbbreviation(){
    if(subject.name == null){
      return ' ';
    }
    final List<String> words = subject.name.split(' ');
    String firstLetter = '';

    if (words[0] == subject.name) {
      return subject.name.toUpperCase();
    }

    for (String word in words) {
      firstLetter += word[0].toUpperCase();
    }
    return firstLetter;
  }




  @override
  Widget buildCardContent(BuildContext context) {
    List<Widget> result = [];

    result.add(Container(
        alignment: Alignment.centerLeft,
        child: Text(subject.name.toString())
    ));
    if (subject.grade == null) {
      subject.grade = 0.0;
      result.add(Text(
        subject.grade.toString(),
        textScaleFactor: 1.5,
      ));
    }
    else {
      result.add(Text(
        subject.grade.toStringAsFixed(1),
        textScaleFactor: 1.5,
      ));
    }

    result.add(Container(
      alignment: Alignment.centerRight,
      child: Text(
        "ects: " + subject.ects.toString(),
        style: Theme.of(context).textTheme.caption.apply(
            fontSizeFactor: 1.0,
        )
        )
      )
    );

    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        //decoration: BoxDecoration(color: Colors.yellow),
        child: Column(children: result),
      ),
    );
  }

  @override
  onClick(BuildContext context) {
    this.showComponents(context);
  }

  showComponents(BuildContext context){
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Column (
            children: [
              Container(
                  child: Text(
                    'Componentes de '+ this.subject.name +':',
                    style: Theme.of(context).textTheme.headline2.apply(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSizeFactor: 1.25,
                    ),
                  ),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.only(top: 15, bottom: 10),
              ),
              this.createComponentsWidgets(context),

              Container(
                child: createAddComponentButton(context),
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.only(top: 15, bottom: 10),
              ),

            ],
          );
        }
    );
  }

  createComponentsWidgets(BuildContext context){
    return FutureBuilder(
      future: SupComponentsDatabase().components(this.subject.id),
      builder: (context, value) {
        if (value.hasData) {
          final List<Widget> ret = [];
          double totalWeight = 0.0;
          double totalGrade = 0.0;
          for(final comp in value.data){
            totalWeight += comp.weight;
            totalGrade += comp.weight * comp.grade / 100;
            ret.add(SupComponent(component: comp, onDelete: () {
              SupComponentsDatabase().deleteComponent(comp.id);
              Navigator.pop(context);
              this.showComponents(context);
            }));
          }
          //if weight total < 100 -> calcula nota que falta
          if(totalWeight < 100){
            if(totalGrade < 9.5){
              final tempGrade = (9.5 - totalGrade) / (100 - totalWeight) * 100;
              ret.add(SupComponent(component:
              Component(name: 'SUP?', grade: tempGrade,
                  weight: (100-totalWeight)),
                isRed: true,));
            }
            else{
              ret.add(Text('Parabéns, já passaste à cadeira!', textAlign: TextAlign.center,),);
            }
          }
          else if(totalWeight > 100){
            ret.add(Text('O peso das componentes passa de 100!', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red)));
          }
          else{
            ret.add(Text('A tua nota nesta cadeira é:' + totalGrade.toStringAsFixed(2), textAlign: TextAlign.center,),);
          }
          return Container(
            child: ListView(
              children: ret,
            ),
            height: 250.0,
            padding: EdgeInsets.symmetric(horizontal: 15),
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

  Widget createAddComponentButton(BuildContext context) {
    final newComponent = Component(name: '', grade: 0.0, weight: 0.0,
        subject_id: this.subject.id);
    return FloatingActionButton(
      onPressed: () =>
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                        'Precisamos de alguns dados sobre a componente que '
                            'pretendes adicionar:'),
                    content: Container(
                      child: addComponentMenu(context, newComponent),
                      height: 230.0,
                      width: 100.0,
                    ),
                    actions: [
                      TextButton(
                          child: Text('Cancelar'),
                          onPressed: () => Navigator.pop(context)
                      ),
                      TextButton(
                          child: Text('Guardar'),
                          onPressed: () =>
                          {
                            if(validateComponent(newComponent)){
                              SupComponentsDatabase().saveNewComponent(
                                  newComponent),
                              SupSubjectsDatabase().updateGrade(this.subject.id),
                              Navigator.pop(context),
                              Navigator.pop(context),
                              this.showComponents(context) //Big brain time

                            }else(invalidComponentError(context))
                          }

                      )
                    ]);
              }), //Add FAB functionality here
      tooltip: 'Adicionar componente',
      child: Icon(Icons.add,),
      mini: true,
    );
  }

  Widget addComponentMenu(BuildContext context, Component newComponent){
    final List<Widget> ret = [];

    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter your component's name",
            hintText: 'What we should refer to your component as',
          ),
          initialValue: newComponent.name,
          onChanged: (String value) {
            newComponent.name = value;
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
            labelText: "Enter your component's grade",
            hintText: '10.0'
          ),
          onChanged: (String value) {
            final valueDouble = double.parse(value);
            newComponent.grade = valueDouble;
            if (newComponent.grade == null) {
              newComponent.grade = 0.0;
            }
          },
        ),
      ),
    );

    var maskFormatter = MaskTextInputFormatter(
        mask: '###.# ',
        filter: { '#': RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
    ret.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter your component's weight",
            hintText: '50.0%',
          ),
          //initialValue: newComponent.weight.toString() + '\%',
          onChanged: (String value) {
            final value_double = double.parse(value);
            newComponent.weight = value_double;
            if (newComponent.weight == null) {
              newComponent.weight = 0.0;
            }
          },
          inputFormatters: [maskFormatter],
        ),
      ),
    );

    return ListView(
      children: ret,
    );
  }

  bool validateComponent(Component component){
    if(component.grade < 0.0||
        component.grade > 20.0||
        component.weight < 0||
        component.weight > 100){
        return false;
    }else{return true;}

  }

  void invalidComponentError(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'Por favor, certifica-te que: \n\n    -a nota é um número entre 0 e 20'
                      '\n\n    -o peso de cada componente é um número de 0 a 100'),
              actions: [
                TextButton(
                    child: Text('Fechar'),
                    onPressed: () => Navigator.pop(context)),
              ]);
        }
    );
  }

}