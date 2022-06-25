import 'package:board_games_companion/models/result.dart';

class ImportResult<TData> extends Result<TData> {
  ImportResult();

  ImportResult.failure(this.errors);

  List<ImportError>? errors;

  @override
  bool get isSuccess => errors?.isEmpty ?? true;
}

class ImportError {
  ImportError(this.description);

  ImportError.exception(this.exception, this.stackTrace);

  String? description;
  Object? exception;
  StackTrace? stackTrace;
}
