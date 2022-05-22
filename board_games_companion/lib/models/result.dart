class Result<TData> {
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  set isSuccess(bool value) {
    _isSuccess = value;
  }

  TData? data;
}
