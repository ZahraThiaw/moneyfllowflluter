// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      nom: fields[1] as String,
      prenom: fields[2] as String,
      telephone: fields[3] as String,
      email: fields[4] as String,
      token: fields[5] as String?,
      type: fields[6] as String,
      solde: fields[7] as double,
      qrcode: fields[8] as String?,
      statut: fields[9] as String,
      plafonnd: fields[10] as double,
      enabled: fields[11] as bool,
      createdAt: fields[12] as String,
      updatedAt: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.prenom)
      ..writeByte(3)
      ..write(obj.telephone)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.token)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.solde)
      ..writeByte(8)
      ..write(obj.qrcode)
      ..writeByte(9)
      ..write(obj.statut)
      ..writeByte(10)
      ..write(obj.plafonnd)
      ..writeByte(11)
      ..write(obj.enabled)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
