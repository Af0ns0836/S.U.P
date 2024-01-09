import 'dart:async';
import 'package:uni/controller/local_storage/sup_subjects_database.dart';
import 'package:uni/model/entities/course.dart';
import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

/// Manages the app's Courses database.
/// See the [Course] class to see what data is stored in this database.

class AppCoursesDatabase extends AppDatabase {
  static final createScript =
      '''CREATE TABLE courses(id INTEGER PRIMARY KEY AUTOINCREMENT, fest_id INTEGER, name TEXT,
          abbreviation TEXT, currYear TEXT, firstEnrollment INTEGER, state TEXT, grade REAL DEFAULT 10.0,
          view TEXT DEFAULT TRUE, gradeIsUserDefined INTEGER DEFAULT 1)''';

  AppCoursesDatabase()
      : super('courses.db', [createScript],  onUpgrade: migrate, version: 10);

  /// Replaces all of the data in this database with the data from [courses].
  saveNewCourses(List<Course> courses) async {

    //await deleteCourses();
    await _insertCourses(courses);
  }

  /// Returns a list containing all of the courses stored in this database.
  Future<List<Course>> courses() async {

    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Courses.
    List<Map<String, dynamic>> maps = await db.query('courses');

    // Convert the List<Map<String, dynamic> into a List<Course>.
    List<Course> courses = List.generate(maps.length, (i) {
      return Course(
          id: maps[i]['id'],
          festId: maps[i]['fest_id'],
          name: maps[i]['name'],
          abbreviation: maps[i]['abbreviation'],
          currYear: maps[i]['currYear'],
          firstEnrollment: maps[i]['firstEnrollment'],
          state: maps[i]['state'],
          grade: maps[i]['grade'],
          view: maps[i]['view'],
          gradeIsUserDefined: maps[i]['gradeIsUserDefined']);
    });

    for(final course in courses){
      this.updateGradedb(course.id);
    }

    // Query the table for All The Courses.
    maps = await db.query('courses');

    // Convert the List<Map<String, dynamic> into a List<Course>.
    courses = List.generate(maps.length, (i) {
      return Course(
          id: maps[i]['id'],
          festId: maps[i]['fest_id'],
          name: maps[i]['name'],
          abbreviation: maps[i]['abbreviation'],
          currYear: maps[i]['currYear'],
          firstEnrollment: maps[i]['firstEnrollment'],
          state: maps[i]['state'],
          grade: maps[i]['grade'],
          view: maps[i]['view'],
          gradeIsUserDefined: maps[i]['gradeIsUserDefined']);
    });

    return courses;
  }

  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertCourses(List<Course> courses) async {
    for (Course course in courses) {
      await insertInDatabase(
        'courses',
        course.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteCourses() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('courses');
  }

  /// Updates the state of all courses present in [states].
  ///
  /// *Note:*
  /// * a key in [states] is a [Course.id].
  /// * a value in [states] is the new state of the corresponding course.
  void saveCoursesStates(Map<String, String> states) async {
    final Database db = await this.getDatabase();

    // Retrieve stored courses
    final List<Course> courses = await this.courses();

    // For each course, save its state
    for (Course course in courses) {
      await db.update(
        'courses',
        {'state': states[course.name]},
        where: 'id = ?',
        whereArgs: [course.id],
      );
    }
  }

  ///Updates courses when they are edited
  void updateCourseData(Course updated_course, int updated_course_id) async{
    final Database db = await this.getDatabase();
    await db.update('courses', updated_course.toMap(),
      where: 'id = ?', whereArgs: [updated_course_id]);
  }


  static FutureOr<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS courses');
    batch.execute(createScript);
    await batch.commit();
  }

  saveNewCourse(Course course) async {
    await insertInDatabase(
      'courses',
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  updateGradedb(int courseId) async{
    final Database db = await this.getDatabase();

    // Query the table for All The Subjects.
    final List<Map<String, dynamic>> maps = await db.query('courses');

    // Convert the List<Map<String, dynamic> into a List<Subject>.
    final courses = List.generate(maps.length, (i) {
      return Course(
          id: maps[i]['id'],
          festId: maps[i]['fest_id'],
          name: maps[i]['name'],
          abbreviation: maps[i]['abbreviation'],
          currYear: maps[i]['currYear'],
          firstEnrollment: maps[i]['firstEnrollment'],
          state: maps[i]['state'],
          grade: maps[i]['grade'],
          view: maps[i]['view'],
          gradeIsUserDefined: maps[i]['gradeIsUserDefined']);
    });

    final course = courses.singleWhere((element) => element.id==courseId);

    // if grade was declared by the user then do nothing
    if(course.gradeIsUserDefined != 0){
      return;
    }

    // else update grade based on components
    final subjects = await SupSubjectsDatabase().subjects(courseId);

    double totalEcts = 0.0;
    double finalGrade = 0.0;
    for(final subject in subjects){
      if(subject.ects == null || subject.grade == null){
        continue;
      }
      totalEcts += subject.ects;
      finalGrade += subject.grade * subject.ects;

    }

    course.grade = finalGrade/totalEcts;

    await this.saveNewCourse(course);

  }
}
