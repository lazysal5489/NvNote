class Note {
  final String path;
  final String title;
  final DateTime modifiedAte;

  const Note({
    required this.path,
    required this.title,
    required this.modifiedAte,
  });

  @override
  bool operator ==(Object other) =>
      other is Note &&
      other.path == path &&
      other.title == title &&
      other.modifiedAte == modifiedAte;

  @override
  int get hashCode => Object.hash(path, title, modifiedAte);
}
