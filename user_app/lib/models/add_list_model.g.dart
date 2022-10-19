// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddListModelAdapter extends TypeAdapter<AddListModel> {
  @override
  final int typeId = 0;

  @override
  AddListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddListModel(
      fields[0] as String,
      (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AddListModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.itemList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
