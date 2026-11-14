import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_settings_database.g.dart';

/// App-level settings ONLY: theme + vault display name.
/// Never store note content, note metadata, or folder trees here.
@DataClassName('AppSettingsRow')
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get themeMode => text().withDefault(const Constant('dark'))();
  TextColumn get vaultName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [AppSettings])
class AppSettingsDatabase extends _$AppSettingsDatabase {
  /// Pass an executor in tests (e.g. NativeDatabase.memory()).
  AppSettingsDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static const _rowId = 1;

  // ── Reads ────────────────────────────────────────────────
  Future<AppSettingsRow?> _row() => (select(
    appSettings,
  )..where((t) => t.id.equals(_rowId))).getSingleOrNull();

  Future<String?> getVaultName() async => (await _row())?.vaultName;

  Future<String> getThemeMode() async => (await _row())?.themeMode ?? 'dark';

  /// Emits whenever settings change; handy for live theme switching.
  Stream<AppSettingsRow?> watchSettings() => (select(
    appSettings,
  )..where((t) => t.id.equals(_rowId))).watchSingleOrNull();

  // ── Writes (upsert the single row) ───────────────────────
  Future<void> setVaultName(String? name) => into(appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion(id: const Value(_rowId), vaultName: Value(name)),
      );

  Future<void> setThemeMode(String mode) => into(appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion(id: const Value(_rowId), themeMode: Value(mode)),
      );
}

QueryExecutor _openConnection() => driftDatabase(name: 'nvnote_settings');
