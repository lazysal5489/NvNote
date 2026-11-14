class Vault {
  final String rootPath;
  final String? name;

  const Vault({required this.rootPath, this.name});

  @override
  bool operator ==(Object other) =>
      other is Vault && other.rootPath == rootPath && other.name == name;
  @override
  int get hashCode => Object.hash(rootPath, name);

  String get displayName => name != null ? name! : 'My Vault';
}
