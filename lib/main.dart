import 'package:flutter/material.dart';
import 'package:nvnote/data/app_settings_database.dart';
import 'package:nvnote/screens/note_editor_screen.dart';
import 'package:nvnote/screens/welcome_screen.dart';
import 'package:nvnote/themes/system_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nvnote/models/vault.dart';
import 'package:nvnote/services/vault_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final vaultService = VaultService(
    baseDir: getApplicationSupportDirectory,
    settings: AppSettingsDatabase(),
  );

  /*final Vault? vault = await vaultService.vaultExists()
      ? await vaultService.getOrCreateVault()
      : null;
    */
  final Vault? vault = null;
  runApp(MyApp(vaultService: vaultService, intialVault: vault));
}

class MyApp extends StatefulWidget {
  final VaultService vaultService;
  final Vault? intialVault;
  const MyApp({
    super.key,
    required this.vaultService,
    required this.intialVault,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Vault? _vault = widget.intialVault;

  @override
  Widget build(BuildContext context) {
    final vault = _vault;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NvNote',
      theme: SystemTheme.dark,
      home: vault == null
          ? WelcomeScreen(
              vaultService: widget.vaultService,
              onValueReady: (v) => setState(() => _vault = v),
            )
          : HomeScreen(vault: vault),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Vault vault;
  const HomeScreen({super.key, required this.vault});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(vault.displayName)),
      body: const LiveMarkdownEditor(),
    );
  }
}
