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
      careGuide: fields[6] as PlantCareGuide,
      growthInfo: fields[7] as PlantGrowthInfo,
      identification: fields[12] as PlantIdentification,
      lightingRecommendations: fields[13] as LightingRecommendations,
      growthJournal: (fields[8] as List?)?.cast<GrowthEntry>(),
      wateringSchedule: fields[9] as WateringSchedule,
      commonIssues: (fields[10] as List?)?.cast<PlantIssue>(),
      specialNotes: (fields[11] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Plant obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.growthInfo)
      ..writeByte(8)
      ..write(obj.growthJournal)
      ..writeByte(9)
      ..write(obj.wateringSchedule)
      ..writeByte(10)
      ..write(obj.commonIssues)
      ..writeByte(11)
      ..write(obj.specialNotes)
      ..writeByte(12)
      ..write(obj.identification)
      ..writeByte(13)
      ..write(obj.lightingRecommendations);
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

class PlantIdentificationAdapter extends TypeAdapter<PlantIdentification> {
  @override
  final int typeId = 3;

  @override
  PlantIdentification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantIdentification(
      species: fields[0] as String,
      commonNames: (fields[1] as List).cast<String>(),
      confidence: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PlantIdentification obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.species)
      ..writeByte(1)
      ..write(obj.commonNames)
      ..writeByte(2)
      ..write(obj.confidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantIdentificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantCareGuideAdapter extends TypeAdapter<PlantCareGuide> {
  @override
  final int typeId = 4;

  @override
  PlantCareGuide read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantCareGuide(
      water: fields[0] as String,
      light: fields[1] as String,
      soil: fields[2] as String,
      temperature: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlantCareGuide obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.water)
      ..writeByte(1)
      ..write(obj.light)
      ..writeByte(2)
      ..write(obj.soil)
      ..writeByte(3)
      ..write(obj.temperature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantCareGuideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantGrowthInfoAdapter extends TypeAdapter<PlantGrowthInfo> {
  @override
  final int typeId = 5;

  @override
  PlantGrowthInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantGrowthInfo(
      growthRate: fields[0] as String,
      height: fields[1] as String,
      spread: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlantGrowthInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.growthRate)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.spread);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantGrowthInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantIssueAdapter extends TypeAdapter<PlantIssue> {
  @override
  final int typeId = 6;

  @override
  PlantIssue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantIssue(
      issue: fields[0] as String,
      solution: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlantIssue obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.issue)
      ..writeByte(1)
      ..write(obj.solution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantIssueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LightingRecommendationsAdapter
    extends TypeAdapter<LightingRecommendations> {
  @override
  final int typeId = 7;

  @override
  LightingRecommendations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LightingRecommendations(
      optimalConditions: fields[0] as OptimalConditions,
      placement: (fields[1] as List).cast<String>(),
      distanceGuide: fields[2] as DistanceGuide,
      seasonalAdjustments: fields[3] as SeasonalAdjustments,
      warningSigns: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, LightingRecommendations obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.optimalConditions)
      ..writeByte(1)
      ..write(obj.placement)
      ..writeByte(2)
      ..write(obj.distanceGuide)
      ..writeByte(3)
      ..write(obj.seasonalAdjustments)
      ..writeByte(4)
      ..write(obj.warningSigns);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LightingRecommendationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OptimalConditionsAdapter extends TypeAdapter<OptimalConditions> {
  @override
  final int typeId = 8;

  @override
  OptimalConditions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OptimalConditions(
      lightType: fields[0] as String,
      lightIntensity: fields[1] as String,
      duration: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OptimalConditions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lightType)
      ..writeByte(1)
      ..write(obj.lightIntensity)
      ..writeByte(2)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptimalConditionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DistanceGuideAdapter extends TypeAdapter<DistanceGuide> {
  @override
  final int typeId = 9;

  @override
  DistanceGuide read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DistanceGuide(
      minimumDistance: fields[0] as String,
      maximumDistance: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DistanceGuide obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.minimumDistance)
      ..writeByte(1)
      ..write(obj.maximumDistance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistanceGuideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SeasonalAdjustmentsAdapter extends TypeAdapter<SeasonalAdjustments> {
  @override
  final int typeId = 10;

  @override
  SeasonalAdjustments read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SeasonalAdjustments(
      spring: fields[0] as String,
      summer: fields[1] as String,
      fall: fields[2] as String,
      winter: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SeasonalAdjustments obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.spring)
      ..writeByte(1)
      ..write(obj.summer)
      ..writeByte(2)
      ..write(obj.fall)
      ..writeByte(3)
      ..write(obj.winter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonalAdjustmentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
