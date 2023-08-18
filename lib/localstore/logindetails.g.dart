// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logindetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogindetailsAdapter extends TypeAdapter<Logindetails> {
  @override
  final int typeId = 0;

  @override
  Logindetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Logindetails(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Logindetails obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogindetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
