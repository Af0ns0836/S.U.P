import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';

import '../../model/entities/component.dart';

class SupComponentsDatabase extends AppDatabase{

  static final createScript =
  '''CREATE TABLE components(
                    id INTEGER PRIMARY KEY AUTOINCREMENT, 
                    name TEXT, 
                    grade REAL DEFAULT 0.0, 
                    weight REAL DEFAULT 0.0,
                    subject_id INTEGER
                    )''';


  SupComponentsDatabase()
      : super('components.db', [createScript], onUpgrade: migrate, version: 2);

  Future<void> saveNewComponents(List<Component> components) async {
    for (Component component in components) {
      await insertInDatabase('components', component.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
      }
  }

  Future<void> saveNewComponent(Component component) async {
    await insertInDatabase('components', component.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Component>> components(int subjectId) async {
    final Database db = await this.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('components');

    // Convert the List<Map<String, dynamic> into a List<Subject>.
    final components = List.generate(maps.length, (i) {
      return Component(
          id: maps[i]['id'],
          name: maps[i]['name'],
          grade: maps[i]['grade'],
          weight: maps[i]['weight'],
          subject_id: maps[i]['subject_id']
      );
    });

    components.removeWhere((element) => element.subject_id!=subjectId);
    return components;
  }


  deleteComponent(int componentId) async{
    final Database db = await this.getDatabase();
    await db.rawDelete('DELETE FROM components WHERE id = ' +
        componentId.toString());
  }


  static FutureOr<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS components');
    batch.execute(createScript);
    await batch.commit();
  }
}