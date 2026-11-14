import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nvnote/data/app_settings_database.dart';
import 'package:nvnote/services/vault_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tmp;
  late AppSettingsDatabase db;
  late VaultService svc;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('vault_test');
    db = AppSettingsDatabase(NativeDatabase.memory());
    svc = VaultService(baseDir: () async => tmp, settings: db);
  });

  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  test('vaultExists is false before setup, true after', () async {
    expect(await svc.vaultExists(), isFalse);
    await svc.getOrCreateVault();
    expect(await svc.vaultExists(), isTrue);
  });

  test('rootPath is <base>/vault', () async {
    final vault = await svc.getOrCreateVault();
    expect(vault.rootPath, p.join(tmp.path, 'vault'));
  });

  test('getOrCreateVault is idempotent', () async {
    final a = await svc.getOrCreateVault('Brain');
    final b = await svc.getOrCreateVault('Brain');
    expect(a, b);
  });

  test('null name on later launch keeps the saved name', () async {
    await svc.getOrCreateVault('Brain');
    final later = await svc.getOrCreateVault();
    expect(later.name, 'Brain');
  });

  test('blank name is not saved', () async {
    final vault = await svc.getOrCreateVault('   ');
    expect(vault.name, isNull);
  });

  test('renameVault changes name only, not the folder', () async {
    final before = await svc.getOrCreateVault('Old');
    final after = await svc.renameVault('New');
    expect(after.name, 'New');
    expect(after.rootPath, before.rootPath);
    expect(Directory(before.rootPath).existsSync(), isTrue);
  });

  test('renameVault with blank clears the name', () async {
    await svc.getOrCreateVault('Brain');
    final vault = await svc.renameVault('  ');
    expect(vault.name, isNull);
  });
}
