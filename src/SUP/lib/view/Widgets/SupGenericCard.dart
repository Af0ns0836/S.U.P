import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/time_utilities.dart';

abstract class SupGenericCard extends StatefulWidget {
  SupGenericCard({Key key})
      : editingMode = false,
        switchView = null,
        editCardInfo = null,
        viewStatus = true,
        canEdit = true,
        super(key: key);

  SupGenericCard.fromEditingInformation(
      Key key, bool editingMode, Function switchView, Function editCardInfo,
        bool viewStatus, bool canEdit)
      : editingMode = editingMode,
        switchView = switchView,
        editCardInfo = editCardInfo,
        viewStatus = viewStatus,
        canEdit = canEdit,
        super(key: key);

  final bool editingMode;
  final Function switchView;
  final Function editCardInfo;
  final bool viewStatus;
  final bool canEdit;
  @override
  State<StatefulWidget> createState() {
    return SupGenericCardState();
  }

  Widget buildCardContent(BuildContext context);
  String getTitle();
  onClick(BuildContext context);
}

class SupGenericCardState extends State<SupGenericCard> {
  //not sure where to put this
  static const _kFontFam = 'MyFlutterApp';
  static const String _kFontPkg = null;
  static const IconData eye = IconData(0xf06e, fontFamily: _kFontFam,
      fontPackage: _kFontPkg);
  static const IconData eyeSlash = IconData(0xf070, fontFamily: _kFontFam,
      fontPackage: _kFontPkg);


  final double borderRadius = 10.0;
  final double padding = 12.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onClick(context),
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(this.borderRadius)),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(0x1c, 0, 0, 0),
                        blurRadius: 7.0,
                        offset: Offset(0.0, 1.0))
                  ],
                  color: Theme.of(context).dividerColor,
                  borderRadius:
                  BorderRadius.all(Radius.circular(this.borderRadius))),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 60.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                      BorderRadius.all(Radius.circular(this.borderRadius))),
                  width: (double.infinity),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                                child: Text(widget.getTitle(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .apply(
                                        fontSizeDelta: -53,
                                        fontWeightDelta: -3)),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(top: 15, bottom: 10),
                              )),
                          Flexible(
                              child: Container(
                                child: this.getMoveIcon(context),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 8),
                            )
                          ),
                        ].where((e) => e != null).toList(),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: this.padding * 2,
                          right: this.padding,
                          //bottom: this.padding,
                        ),
                        child: widget.buildCardContent(context),
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                                child: this.createEditCardButton(context),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(bottom: 8, right:8),
                              )
                          ),
                          Flexible(
                              child: Container(
                                child: this.getSwitchViewIcon(context),
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(bottom: 8, right:8),
                              )
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget getSwitchViewIcon(context) {
    Icon icon = widget.viewStatus ? Icon(eye) : Icon(eyeSlash);
    return (widget.editingMode != null && widget.editingMode)
        ? IconButton(
          iconSize: 22,
          icon: icon,
          tooltip: 'Remover',
          onPressed: widget.switchView,
    )
        : null;
  }

  Widget getMoveIcon(context) {
    return (widget.editingMode != null && widget.editingMode)
        ? Icon(Icons.drag_handle_rounded,
        color: Colors.grey.shade500, size: 22.0)
        : null;
  }

  Widget createEditCardButton(context) {
    return (widget.editingMode != null && widget.editingMode)
        ? IconButton(
            iconSize: 22,
            icon: Icon(widget.canEdit == false ? Icons.warning : Icons.settings, color: Colors.grey.shade700,),
            tooltip: 'Remover',
            onPressed: widget.editCardInfo,
          )
        : null;
  }
}
