class BackupFile {
  BackupFile({
    required this.name,
    required this.size,
    required this.changed,
  });

  String name;
  int size;
  DateTime changed;
}
