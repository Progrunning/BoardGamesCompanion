class Result<TData> {
  Result({
    this.isSuccess = false,
    this.data,
  });

  factory Result.success({
    TData? data,
  }) =>
      Result(
        data: data,
        isSuccess: true,
      );

  factory Result.failure() => Result();

  bool isSuccess = false;

  TData? data;
}
