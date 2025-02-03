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
  PlantCareGuide careGuide;

  @HiveField(7)
  PlantGrowthInfo growthInfo;

  @HiveField(8)
  List<GrowthEntry> growthJournal;

  @HiveField(9)
  WateringSchedule wateringSchedule;

  @HiveField(10)
  List<PlantIssue> commonIssues;

  @HiveField(11)
  List<String> specialNotes;

  @HiveField(12)
  PlantIdentification identification;

  @HiveField(13)
  LightingRecommendations lightingRecommendations;

  Plant({
    String? id,
    required this.name,
    required this.species,
    required this.imageUrl,
    required this.lastWatered,
    required this.lastFertilized,
    required this.careGuide,
    required this.growthInfo,
    required this.identification,
    required this.lightingRecommendations,
    List<GrowthEntry>? growthJournal,
    required this.wateringSchedule,
    List<PlantIssue>? commonIssues,
    List<String>? specialNotes,
  })  : id = id ?? const Uuid().v4(),
        growthJournal = growthJournal ?? [],
        commonIssues = commonIssues ?? [],
        specialNotes = specialNotes ?? [];

  factory Plant.fromRecognitionResult(
      Map<String, dynamic> result, String imageUrl) {
    final identification =
        PlantIdentification.fromJson(result['identification']);
    final careGuide = PlantCareGuide.fromJson(result['care_guide']);
    final lightingRecommendations =
        LightingRecommendations.fromJson(result['lightingRecommendations']);
    final growthInfo = PlantGrowthInfo.fromJson(result['growth_info']);

    final commonIssues = (result['common_issues'] as List?)
            ?.map((issue) => PlantIssue.fromJson(issue))
            .toList() ??
        [];

    final specialNotes = List<String>.from(result['special_notes'] ?? []);

    return Plant(
      name: identification.commonNames.isNotEmpty
          ? identification.commonNames.first
          : identification.species,
      species: identification.species,
      imageUrl: imageUrl,
      lastWatered: DateTime.now(),
      lastFertilized: DateTime.now(),
      careGuide: careGuide,
      growthInfo: growthInfo,
      identification: identification,
      wateringSchedule: WateringSchedule(
        frequencyDays: 7,
        season: 'all',
        adjustments: {},
      ),
      lightingRecommendations: lightingRecommendations,
      commonIssues: commonIssues,
      specialNotes: specialNotes,
    );
  }
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

@HiveType(typeId: 3)
class PlantIdentification {
  @HiveField(0)
  final String species;

  @HiveField(1)
  final List<String> commonNames;

  @HiveField(2)
  final double confidence;

  PlantIdentification({
    required this.species,
    required this.commonNames,
    required this.confidence,
  });

  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    return PlantIdentification(
      species: json['species'] ?? '',
      commonNames: List<String>.from(json['commonNames'] ?? []),
      confidence: json['confidence']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'species': species,
        'commonNames': commonNames,
        'confidence': confidence,
      };
}

@HiveType(typeId: 4)
class PlantCareGuide {
  @HiveField(0)
  final String water;

  @HiveField(1)
  final String light;

  @HiveField(2)
  final String soil;

  @HiveField(3)
  final String temperature;

  PlantCareGuide({
    required this.water,
    required this.light,
    required this.soil,
    required this.temperature,
  });

  factory PlantCareGuide.fromMap(Map<String, dynamic> map) {
    return PlantCareGuide(
      water: map['water'] ?? 'No watering information available',
      light: map['light'] ?? 'No light information available',
      temperature: map['temperature'] ?? 'No temperature information available',
      soil: map['soil'] ?? 'No soil information available',
    );
  }

  factory PlantCareGuide.fromJson(Map<String, dynamic> json) {
    return PlantCareGuide(
      water: json['water'] ?? '',
      light: json['light'] ?? '',
      soil: json['soil'] ?? '',
      temperature: json['temperature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'water': water,
        'light': light,
        'soil': soil,
        'temperature': temperature,
      };
}

@HiveType(typeId: 5)
class PlantGrowthInfo {
  @HiveField(0)
  final String growthRate;

  @HiveField(1)
  final String height;

  @HiveField(2)
  final String spread;

  PlantGrowthInfo({
    required this.growthRate,
    required this.height,
    required this.spread,
  });

  factory PlantGrowthInfo.fromJson(Map<String, dynamic> map) {
    return PlantGrowthInfo(
      growthRate: map['growthRate'] ?? '',
      height: map['height'] ?? '',
      spread: map['temperature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'growthRate': growthRate,
        'height': height,
        'spread': spread,
      };
}

@HiveType(typeId: 6)
class PlantIssue {
  @HiveField(0)
  final String issue;

  @HiveField(1)
  final String solution;

  PlantIssue({
    required this.issue,
    required this.solution,
  });

  factory PlantIssue.fromJson(Map<String, dynamic> json) {
    return PlantIssue(
      issue: json['issue'] ?? '',
      solution: json['solution'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'issue': issue,
        'solution': solution,
      };
}

@HiveType(typeId: 7)
class LightingRecommendations extends HiveObject {
  @HiveField(0)
  final OptimalConditions optimalConditions;

  @HiveField(1)
  final List<String> placement;

  @HiveField(2)
  final DistanceGuide distanceGuide;

  @HiveField(3)
  final SeasonalAdjustments seasonalAdjustments;

  @HiveField(4)
  final List<String> warningSigns;

  LightingRecommendations({
    required this.optimalConditions,
    required this.placement,
    required this.distanceGuide,
    required this.seasonalAdjustments,
    required this.warningSigns,
  });

  factory LightingRecommendations.fromJson(Map<String, dynamic> json) {
    return LightingRecommendations(
      optimalConditions: OptimalConditions.fromJson(json['optimal_conditions']),
      placement: List<String>.from(json['placement']),
      distanceGuide: DistanceGuide.fromJson(json['distance_guide']),
      seasonalAdjustments:
          SeasonalAdjustments.fromJson(json['seasonal_adjustments']),
      warningSigns: List<String>.from(json['warning_signs']),
    );
  }

  Map<String, dynamic> toJson() => {
        'optimal_conditions': optimalConditions.toJson(),
        'placement': placement,
        'distance_guide': distanceGuide.toJson(),
        'seasonal_adjustments': seasonalAdjustments.toJson(),
        'warning_signs': warningSigns,
      };
}

@HiveType(typeId: 8)
class OptimalConditions {
  @HiveField(0)
  final String lightType;

  @HiveField(1)
  final String lightIntensity;

  @HiveField(2)
  final String duration;

  OptimalConditions({
    required this.lightType,
    required this.lightIntensity,
    required this.duration,
  });

  factory OptimalConditions.fromJson(Map<String, dynamic> json) {
    return OptimalConditions(
      lightType: json['light_type'] ?? '',
      lightIntensity: json['light_intensity'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'light_type': lightType,
        'light_intensity': lightIntensity,
        'duration': duration,
      };
}

@HiveType(typeId: 9)
class DistanceGuide {
  @HiveField(0)
  final String minimumDistance;

  @HiveField(1)
  final String maximumDistance;

  DistanceGuide({
    required this.minimumDistance,
    required this.maximumDistance,
  });

  factory DistanceGuide.fromJson(Map<String, dynamic> json) {
    return DistanceGuide(
      minimumDistance: json['minimum_distance'] ?? '',
      maximumDistance: json['maximum_distance'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'minimum_distance': minimumDistance,
        'maximum_distance': maximumDistance,
      };
}

@HiveType(typeId: 10)
class SeasonalAdjustments {
  @HiveField(0)
  final String spring;

  @HiveField(1)
  final String summer;

  @HiveField(2)
  final String fall;

  @HiveField(3)
  final String winter;

  SeasonalAdjustments({
    required this.spring,
    required this.summer,
    required this.fall,
    required this.winter,
  });

  factory SeasonalAdjustments.fromJson(Map<String, dynamic> json) {
    return SeasonalAdjustments(
      spring: json['spring'] ?? '',
      summer: json['summer'] ?? '',
      fall: json['fall'] ?? '',
      winter: json['winter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'spring': spring,
        'summer': summer,
        'fall': fall,
        'winter': winter,
      };
}
