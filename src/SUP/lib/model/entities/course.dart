/// Stores information about a course.
///
/// The information stored is:
/// - Course `id`
/// - The `name` of the course
/// - Abbreviation of the `course`
/// - The course current `year`
/// - The date of the `firstEnrollment`
/// - The course `state`
class Course {
  int id;
  int festId;
  String name;
  String abbreviation;
  String currYear;
  int firstEnrollment;
  String state;
  double grade;
  String view;
  int gradeIsUserDefined;

  Course(
      {int this.id,
      int this.festId,
      String this.name,
      String this.abbreviation,
      String this.currYear,
      int this.firstEnrollment,
      String this.state = '',
      double this.grade,
      String this.view = 'true',
      int this.gradeIsUserDefined = 0,});

  /// Creates a new instance from a JSON object.
  static Course fromJson(dynamic data) {
    return Course(
        id: data['cur_id'],
        festId: data['fest_id'],
        abbreviation: data['cur_sigla'],
        name: data['cur_nome'],
        currYear: data['ano_curricular'],
        firstEnrollment: data['fest_a_lect_1_insc'],
        view: 'true,0,fromJson');
  }

  /// Converts this course to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fest_id': festId,
      'name': name,
      'abbreviation': abbreviation,
      'currYear': currYear,
      'firstEnrollment': firstEnrollment,
      'state': state,
      'grade': grade,
      'view': view,
      'gradeIsUserDefined': gradeIsUserDefined,
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is Course) {
      if (other.id == this.id) {
        return true;
      }
      if (other.name == this.name) {
        return true;
      }
    }
    return false;
  }

  void switchView() {
    final viewTemp = this.view.split(',');
    if (viewTemp.first == 'true') {
      viewTemp.first = 'false';
    } else {
      viewTemp.first = 'true';
    }
    this.view = viewTemp.join(',');
  }
}
