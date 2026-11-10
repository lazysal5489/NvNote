import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'notes_database.g.dart';

// One row = one note/buffer. Content lives right in the DB as TEXT —
// simplest option for now; can migrate to file-based storage later
// without touching the rest of the app if you ever need that.
class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withDefault(const Constant('Untitled'))();
  TextColumn get content => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Notes])
class NotesDatabase extends _$NotesDatabase {
  NotesDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ── Reads ────────────────────────────────────────────────
  Future<List<Note>> getAllNotes() {
    return (select(
      notes,
    )..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  }

  // Use this instead of getAllNotes() if you want the buffer list to
  // auto-update when data changes elsewhere (e.g. a future sync feature).
  Stream<List<Note>> watchAllNotes() {
    return (select(
      notes,
    )..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).watch();
  }

  // ── Writes ───────────────────────────────────────────────
  Future<int> insertNote(NotesCompanion note) {
    return into(notes).insert(note);
  }

  Future<bool> updateNote(NotesCompanion note) {
    return update(notes).replace(note);
  }

  Future<int> deleteNote(String id) {
    return (delete(notes)..where((t) => t.id.equals(id))).go();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'nvnote');
}
