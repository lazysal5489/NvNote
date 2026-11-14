import 'dart:io';

import 'package:path/path.dart' as p;

import '../data/app_settings_database.dart';
import '../models/vault.dart';

class VaultService {
  final Future<Directory> Function() baseDir;
  final AppSettingsDatabase settings;

  VaultService({required this.baseDir, required this.settings});

  static const _vaultFolder = 'vault';

  Future<String> _rootPath() async =>
      p.join((await baseDir()).path, _vaultFolder);

  String? _clean(String? name) {
    final trimmed = name?.trim();

    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  Future<bool> vaultExists() async => Directory(await _rootPath()).exists();

  Future<Vault> getOrCreateVault([String? name]) async {
    final root = await _rootPath();

    await Directory(root).create(recursive: true);

    final cleaned = _clean(name);

    if (cleaned != null) {
      await settings.setVaultName(cleaned);
    }

    return Vault(rootPath: root, name: await settings.getVaultName());
  }

  Future<Vault> renameVault(String? name) async {
    final cleaned = _clean(name);
    final root = await _rootPath();
    await settings.setVaultName(cleaned);

    return Vault(rootPath: root, name: await settings.getVaultName());
  }
}
