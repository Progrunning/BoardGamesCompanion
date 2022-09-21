import 'dart:math';

import 'package:intl/intl.dart';
import 'package:path/path.dart';

class BackupFile {
  BackupFile({
    required this.path,
    required this.size,
    required this.changed,
  });

  static final NumberFormat _fileSizeFormat = NumberFormat('#,##0.#');
  static final List<String> _fileSizeUnits = ['B', 'kB', 'MB', 'GB', 'TB'];

  int size;
  DateTime changed;
  String path;

  String get name => basenameWithoutExtension(path);

  String get nameWithExtension => basename(path);

  String get readableFileSize {
    if (size <= 0) {
      return '0';
    }

    final digitGroups = logBase(size, 10) ~/ logBase(1024, 10);
    return '${_fileSizeFormat.format(size / pow(1024, digitGroups))} ${_fileSizeUnits[digitGroups]}';
  }

  double logBase(num x, num base) => log(x) / log(base);
}
