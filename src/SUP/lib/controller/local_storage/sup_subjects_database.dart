import 'dart:async';
import 'package:uni/controller/local_storage/sup_components_database.dart';
import 'package:uni/model/entities/subject.dart';
import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

/// Manages the app's Subjects database.
/// See the [Subject] class to see what data is stored in this database.

class SupSubjectsDatabase extends AppDatabase {

  //one of the attributes is course_id cause its important to connect the
  // subjects with the course
  static final createScript =
      '''CREATE TABLE subjects(id INTEGER PRIMARY KEY AUTOINCREMENT, course_id INTEGER, name TEXT,
          abbreviation TEXT, code TEXT, state TEXT, grade REAL DEFAULT 0.0, ects REAL DEFAULT 6.0, view TEXT,
          gradeIsUserDefined INTEGER DEFAULT 1)''';


  SupSubjectsDatabase()
      : super('subjects.db', [createScript], onUpgrade: migrate, version: 5);

  /// Replaces all of the data in this database with the data from [subjects].


  saveNewSubjects(List<Subject> subjects) async {
    await _insertSubjects(subjects);
  }

  /// Returns a list containing all of the subjects stored in this database.
  Future<List<Subject>> subjects(int courseId) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Subjects.
    List<Map<String, dynamic>> maps = await db.query('subjects');

    // Convert the List<Map<String, dynamic> into a List<Subject>.
    List<Subject> subjects = List.generate(maps.length, (i) {
      return Subject(
          id: maps[i]['id'],
          course_id: maps[i]['course_id'], //we may need help to this!!
          name: maps[i]['name'],
          abbreviation: maps[i]['abbreviation'],
          grade: maps[i]['grade'],
          ects: maps[i]['ects'],
          code: maps[i]['code'],
          view: maps[i]['view'],
          gradeIsUserDefined: maps[i]['gradeIsUserDefined']);
    });

    for(final subject in subjects){
      this.updateGrade(subject.id);
    }

    maps = await db.query('subjects');

    // Convert the List<Map<String, dynamic> into a List<Subject>.
    subjects = List.generate(maps.length, (i) {
    return Subject(
    id: maps[i]['id'],
    course_id: maps[i]['course_id'], //we may need help to this!!
    name: maps[i]['name'],
    abbreviation: maps[i]['abbreviation'],
    grade: maps[i]['grade'],
    ects: maps[i]['ects'],
    code: maps[i]['code'],
    view: maps[i]['view'],
    gradeIsUserDefined: maps[i]['gradeIsUserDefined']);
    });

    subjects.removeWhere((element) => element.course_id!=courseId);
    return subjects;
  }

  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertSubjects(List<Subject> subjects) async {
    for (Subject subject in subjects) {
      await insertInDatabase(
        'subjects',
        subject.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static FutureOr<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS subjects');
    batch.execute(createScript);
    await batch.commit();
  }

  saveNewSubject(Subject subject) async {
    await insertInDatabase(
      'subjects',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  updateGrade(int subjectId) async{
    final Database db = await this.getDatabase();

    // Query the table for All The Subjects.
    final List<Map<String, dynamic>> maps = await db.query('subjects');

    // Convert the List<Map<String, dynamic> into a List<Subject>.
    final subjects = List.generate(maps.length, (i) {
      return Subject(
          id: maps[i]['id'],
          course_id: maps[i]['course_id'], //we may need help to this!!
          name: maps[i]['name'],
          abbreviation: maps[i]['abbreviation'],
          grade: maps[i]['grade'],
          ects: maps[i]['ects'],
          code: maps[i]['code'],
          view: maps[i]['view'],
          gradeIsUserDefined: maps[i]['gradeIsUserDefined']);
    });

    final subject = subjects.singleWhere((element) => element.id==subjectId);

    // if grade was declared by the user then do nothing
    if(subject.gradeIsUserDefined != 0){
      return;
    }

    // else update grade based on components
    final components = await SupComponentsDatabase().components(subjectId);

    double totalWeight = 0.0;
    double finalGrade = 0.0;
    for(final component in components){
      if(component.weight == null || component.grade == null){
        continue;
      }
      totalWeight += component.weight;
      finalGrade += component.weight * component.grade / 100;
    }

    subject.grade = finalGrade;

    if(totalWeight == 100.0){
      subject.grade = finalGrade;
    }


    await this.saveNewSubject(subject);

  }
}