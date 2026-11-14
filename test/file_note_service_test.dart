import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nvnote/services/file_note_service.dart';

void main() {
  late Directory tmp;
  late FileNoteService svc;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('nvnote_test');
    svc = FileNoteService(tmp.path);
  });

  tearDown(() => tmp.delete(recursive: true));

  test('atomic write raound-trips and leave no .temp', () async {
    await svc.createNote('', 'a');
    await svc.writeContent('a.md', 'hello');
    expect(await svc.readContent('a.md'), 'hello');
    expect(File('${tmp.path}/a.md.tmp').existsSync(), false);
  });

  test('rejects path escape', () {
    expect(() => svc.readContent('../x.md'), throwsArgumentError);
  });

  test('rename Subvault rename folder and keeps its as notes', () async {
    await svc.createSubvault('', 'old');
    await svc.createNote('old', 'a');

    await svc.renameSubvault('old', 'new');

    expect(Directory('${tmp.path}/old').existsSync(), false);
    expect(File('${tmp.path}/new/a.md').existsSync(), true);
  });

  test('renameSubvault rejects names with seapators', () async {
    await svc.createNote('', 'old');
    expect(() => svc.renameSubvault('old', 'a/b'), throwsArgumentError);
  });
}
