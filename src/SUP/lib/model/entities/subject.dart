/// Stores information about a subject.
///
/// The information stored is:
/// - subject `id`
/// - The `name` of the subject
/// - Abbreviation of the `subject`
/// - The subject current `year`
/// - The date of the `firstEnrollment`
/// - The subject `state`
/// - The subject 'ects'
/// - The subject 'code'
class Subject {
  int id;
  String name;
  String abbreviation;
  double grade;
  double ects;
  String code;
  String view;
  int course_id;
  int gradeIsUserDefined;

  Subject(
      {int this.id,
        int this.course_id,
        String this.name,
        String this.abbreviation,
        double this.grade,
        String this.code,
        double this.ects = 6.0,
        String this.view = 'true',
        int this.gradeIsUserDefined = 0,
      });


  /// Converts this subject to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id' : course_id,
      'name': name,
      'abbreviation': abbreviation,
      'grade': grade,
      'view': view,
      'code': code,
      'ects': ects,
      'gradeIsUserDefined': gradeIsUserDefined,
    };
  }


  void switchView(){
    final viewTemp = this.view.split(',');
    if(viewTemp.first == 'true'){
      viewTemp.first = 'false';
    }
    else{
      viewTemp.first = 'true';
    }
    this.view = viewTemp.join(',');
  }

  @override
  bool operator ==(Object other) {
    if (other is Subject) {
      if (other.id == this.id) {
        return true;
      }
      if (other.name == this.name) {
        return true;
      }
    }
    return false;
  }
}