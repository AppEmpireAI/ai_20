import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'plant_data_models.g.dart';

@HiveType(typeId: 0)
class Plant extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String species;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  DateTime lastWatered;

  @HiveField(5)
  DateTime lastFertilized;

  @HiveField(6)
  Map<String, dynamic> careGuide;

  @HiveField(7)
  Map<String, dynamic> lightingGuide;

  @HiveField(8)
  List<GrowthEntry> growthJournal;

  @HiveField(9)
  WateringSchedule wateringSchedule;

  Plant({
    String? id,
    required this.name,
    required this.species,
    required this.imageUrl,
    required this.lastWatered,
    required this.lastFertilized,
    required this.careGuide,
    required this.lightingGuide,
    List<GrowthEntry>? growthJournal,
    required this.wateringSchedule,
  }) : id = id ?? const Uuid().v4(),
        growthJournal = growthJournal ?? [];
}

@HiveType(typeId: 1)
class GrowthEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String note;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final double? height;

  @HiveField(5)
  final int? numberOfLeaves;

  GrowthEntry({
    String? id,
    required this.date,
    required this.note,
    this.imageUrl,
    this.height,
    this.numberOfLeaves,
  }) : id = id ?? const Uuid().v4();
}

@HiveType(typeId: 2)
class WateringSchedule extends HiveObject {
  @HiveField(0)
  final int frequencyDays;

  @HiveField(1)
  final String season;

  @HiveField(2)
  final Map<String, dynamic> adjustments;

  WateringSchedule({
    required this.frequencyDays,
    required this.season,
    required this.adjustments,
  });
}