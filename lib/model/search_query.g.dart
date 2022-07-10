// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_query.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchQueryModelAdapter extends TypeAdapter<SearchQueryModel> {
  @override
  final int typeId = 1;

  @override
  SearchQueryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchQueryModel()..queryText = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, SearchQueryModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.queryText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchQueryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
