// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaythroughStatusAdapter extends TypeAdapter<PlaythroughStatus> {
  @override
  final typeId = 5;

  @override
  PlaythroughStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlaythroughStatus.Started;
      case 1:
        return PlaythroughStatus.Finished;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, PlaythroughStatus obj) {
    switch (obj) {
      case PlaythroughStatus.Started:
        writer.writeByte(0);
        break;
      case PlaythroughStatus.Finished:
        writer.writeByte(1);
        break;
    }
  }
}
