// creating the database model
final String tableNotes = 'notes';

class NoteFields {
  // List for readNote part in notes_database.dart file
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time
  ];

  static final String id =
      '_id'; //in sql database we have by default underscore _ before id
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {
  final int? id; // fields that we need in database
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

// making a copy of current Note object and pasting values in whcih we want of fields
  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );
  // converting objects to json from readNote of note.dart
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        isImportant: json[NoteFields.isImportant] == 1,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
      );
  //converting field data to Json
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.isImportant:
            isImportant ? 1 : 0, // sql databse only understand this

        NoteFields.number: number,
        NoteFields.description: description,
        NoteFields.time:
            createdTime.toIso8601String(), //covert date time to string object
      };
}
