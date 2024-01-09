import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/component.dart';

class SupComponent extends StatefulWidget{
  final Component component;
  final Function onDelete;
  final bool isRed;

  const SupComponent({Key key, this.component, this.onDelete, this.isRed = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SupComponentState();
  }

}

class SupComponentState extends State<SupComponent>{
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Text(
            widget.component.name != null ? widget.component.name : 'Sem nome',
            style: widget.isRed ? Theme.of(context).textTheme.headline4.apply(color: Colors.red) : null,
          ),
          Text(
            widget.component.grade != null ? widget.component.grade.toString() : 'XX.X',
            style: widget.isRed ? Theme.of(context).textTheme.headline4.apply(color: Colors.red) : null,
          ),
          Text(
            widget.component.weight != null ? widget.component.weight.toString() + '%' : '0.0\%',
            style: widget.isRed ? Theme.of(context).textTheme.headline4.apply(color: Colors.red) : null,
          ),
          widget.onDelete != null ? IconButton(
            iconSize: 22,
            icon: Icon(Icons.delete),
            tooltip: 'Remover',
            onPressed: widget.onDelete,
          ) : Container()
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      /*Text('name: ' + widget.component.name +
          ', grade: ' + widget.component.grade.toString() +
          ', weight: ' + widget.component.weight.toString()),*/
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),

    );
  }

}