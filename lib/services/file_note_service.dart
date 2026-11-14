import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../models/note.dart';

class FileNoteService {
  final String rootPath;
  FileNoteService(this.rootPath);

  // Resovle a vault-relative path and refuse anything that escape the vault.
  String _resovle(String relative) {
    final full = p.normalize(p.join(rootPath, relative));

    if (full != rootPath && !p.isWithin(rootPath, full)) {
      throw ArgumentError('Path escape vault: $relative');
    }

    return full;
  }

  Future<Note> _toNote(File f) async => Note(
    path: f.path,
    title: p.basenameWithoutExtension(f.path),
    modifiedAte: (await f.stat()).modified,
  );

  // Shallow listing of notes in a folder ('' = vault root)
  Future<List<Note>> listNotes([String dir = '']) async {
    final d = Directory(_resovle(dir));

    if (!await d.exists()) return [];

    final notes = <Note>[];
    await for (final e in d.list(followLinks: false)) {
      if (e is File && p.extension(e.path) == '.md') {
        notes.add(await _toNote(e));
      }
    }

    notes.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
    return notes;
  }

  // Shallow listing of subvault folder
  Future<List<Directory>> listSubvaults([String dir = '']) async {
    final d = Directory(_resovle(dir));

    if (!await d.exists()) return [];
    return d
        .list(followLinks: false)
        .where((e) => e is Directory)
        .cast<Directory>()
        .toList();
  }

  Future<String> readContent(String relative) =>
      File(_resovle(relative)).readAsString();

  // Atomic write: temp file, flush, rename over target.
  Future<void> writeContent(String relative, String content) async {
    final target = _resovle(relative);
    final tmp = File('$target.tmp');
    await tmp.writeAsString(content, flush: true);
    await tmp.rename(target);
  }

  Future<Note> createNote(String dir, String name) async {
    final file = File(_resovle(p.join(dir, '$name.md')));

    if (await file.exists()) {
      throw FileSystemException('Note already exists', file.path);
    }

    await file.parent.create(recursive: true);
    await file.writeAsString('', flush: true);
    return _toNote(file);
  }

  Future<Directory> createSubvault(String dir, String name) async {
    final target = Directory(_resovle(p.join(dir, name)));

    if (await target.exists()) {
      throw FileSystemException('Folder already exists', target.path);
    }
    return target.create(recursive: true);
  }

  Future<Note> renameNote(String relative, String newName) async {
    final src = File(_resovle(relative));
    final dest = _resovle(p.join(p.dirname(relative), '$newName.md'));

    if (await File(dest).exists()) {
      throw FileSystemException('Target exists', dest);
    }
    return _toNote(await src.rename(dest));
  }

  Future<void> deleteNote(String relative) => File(_resovle(relative)).delete();

  Future<Directory> renameSubvault(String relative, String newName) async {
    final src = _resovle(relative);
    if (src == rootPath) {
      throw ArgumentError('Connote rename vault root');
    }
    if (newName.isEmpty || newName != p.basename(newName)) {
      throw ArgumentError('Invalid folder name: $newName');
    }

    final dest = _resovle(p.join(p.dirname(relative), newName));
    if (!await Directory(src).exists()) {
      throw FileSystemException('Subvault not found', src);
    }
    if (await Directory(dest).exists()) {
      throw FileSystemException('Target already exists', dest);
    }

    return Directory(src).rename(dest);
  }

  Future<void> deleteSubvault(String relative) {
    final target = _resovle(relative);

    if (target == rootPath) {
      throw ArgumentError('Cannot delete vault root');
    }
    return Directory(target).delete(recursive: true);
  }
}
