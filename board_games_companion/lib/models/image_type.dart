import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_type.freezed.dart';

@freezed
class ImageType with _$ImageType {
  const factory ImageType.web() = _web;
  const factory ImageType.file() = _file;
  const factory ImageType.undefined() = _undefined;
}
