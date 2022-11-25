import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/model/note.dart'; // name of your project

class NotesDatabase {
  static final NotesDatabase instance =
      NotesDatabase._init(); // global instance

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    //opening the database
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //decribe the field types of table here below which can be added in quereis
    final idType =
        'INTEGER PRIMARY KEY AUTOINCREMENT'; // for column "id" and its type of tables inside queries
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    // db.execute function will be used to execute database queries
    await db.execute(''' 
CREATE TABLE $tableNotes (
  ${NoteFields.id} $idType,
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType

)
''');
  }

  //CRUD operations starts now
  // creating a method called create

  Future<Note> create(Note note) async {
    final db = await instance.database; // creating reference to database

    // if you want to insert your own sql statement you can use rawInsert below
    //final json = note.toJson();
    //final columns = '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    //final values = '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';

    //final id = await db.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

// above all works of queries insertion is sames as statament below
    final id = await db.insert(tableNotes,
        note.toJson()); //insertion see note.dart file to see mapping code

    return note.copy(id: id); // to pass unique id to note object again
  }

// Reading the note to create it
  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFields
          .values, //add values inside note.dart in NoteFields class using list
      // defining whch note object we want to read
      where:
          '${NoteFields.id} = ?', // we can put ?id but to prevent SQL injection we use ?
      whereArgs: [id],
    );
    // covering maps to note objects
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    }
    //implementing other cases
    else {
      throw Exception('ID $id not Found');
    }
  }

// for reading multiple notes
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    // to order notes time wise
    final orderBy = '${NoteFields.time} ASC';

    //creating your own query
    //final result = await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
// above is same as below
    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    //getting the database reference
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toJson(),

      // defining which note update
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,

      //defining which object to delete
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    //method to close database
    final db = await instance.database;
    _database = null;
    db.close();
  }
}
