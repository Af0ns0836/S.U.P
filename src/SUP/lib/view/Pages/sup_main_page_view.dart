import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

import '../../controller/local_storage/app_courses_database.dart';
import '../Widgets/bug_report_form.dart';
import '../Widgets/sup_main_cards_list.dart';

class SupMainPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SupMainPageViewState();
}

class SupMainPageViewState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return FutureBuilder(
        future: AppCoursesDatabase().courses(),
        builder: (context, value) {
          if (value.hasData) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: SupMainCardsList(value.data),
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
