// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_data_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantAdapter extends TypeAdapter<Plant> {
  @override
  final int typeId = 0;

  @override
  Plant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plant(
      id: fields[0] as String?,
      name: fields[1] as String,
      species: fields[2] as String,
      imageUrl: fields[3] as String,
      lastWatered: fields[4] as DateTime,
      lastFertilized: fields[5] as DateTime,
      careGuide: (fields[6] as Map).cast<String, dynamic>(),
      lightingGuide: (fields[7] as Map).cast<String, dynamic>(),
      growthJournal: (fields[8] as List?)?.cast<GrowthEntry>(),
      wateringSchedule: fields[9] as WateringSchedule,
    );
  }

  @override
  void write(BinaryWriter writer, Plant obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.species)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.lastWatered)
      ..writeByte(5)
      ..write(obj.lastFertilized)
      ..writeByte(6)
      ..write(obj.careGuide)
      ..writeByte(7)
      ..write(obj.lightingGuide)
      ..writeByte(8)
      ..write(obj.growthJournal)
      ..writeByte(9)
      ..write(obj.wateringSchedule);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GrowthEntryAdapter extends TypeAdapter<GrowthEntry> {
  @override
  final int typeId = 1;

  @override
  GrowthEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrowthEntry(
      id: fields[0] as String?,
      date: fields[1] as DateTime,
      note: fields[2] as String,
      imageUrl: fields[3] as String?,
      height: fields[4] as double?,
      numberOfLeaves: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, GrowthEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.numberOfLeaves);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrowthEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WateringScheduleAdapter extends TypeAdapter<WateringSchedule> {
  @override
  final int typeId = 2;

  @override
  WateringSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WateringSchedule(
      frequencyDays: fields[0] as int,
      season: fields[1] as String,
      adjustments: (fields[2] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, WateringSchedule obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.frequencyDays)
      ..writeByte(1)
      ..write(obj.season)
      ..writeByte(2)
      ..write(obj.adjustments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WateringScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
