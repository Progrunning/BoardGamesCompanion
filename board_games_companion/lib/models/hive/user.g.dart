// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 10;

  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()..name = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.name);
  }
}
