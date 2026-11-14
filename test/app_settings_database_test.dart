import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nvnote/data/app_settings_database.dart';

void main() {
  late AppSettingsDatabase db;

  setUp(() => db = AppSettingsDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('defaults when no row exists', () async {
    expect(await db.getVaultName(), isNull);
    expect(await db.getThemeMode(), 'dark');
  });

  test('setting one field does not wipe the other', () async {
    await db.setThemeMode('light');
    await db.setVaultName('Brain');
    expect(await db.getThemeMode(), 'light');
    expect(await db.getVaultName(), 'Brain');
  });
}
