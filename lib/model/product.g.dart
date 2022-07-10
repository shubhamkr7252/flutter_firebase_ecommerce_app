// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductListModelAdapter extends TypeAdapter<ProductListModel> {
  @override
  final int typeId = 0;

  @override
  ProductListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductListModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      price: fields[2] as double?,
      salePrice: fields[3] as double?,
      images: (fields[4] as List?)?.cast<String>(),
      attributes: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductListModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.salePrice)
      ..writeByte(4)
      ..write(obj.images)
      ..writeByte(5)
      ..write(obj.attributes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
