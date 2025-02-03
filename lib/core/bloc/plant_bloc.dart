import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:ai_20/core/services/ai_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

abstract class PlantEvent extends Equatable {
  const PlantEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlants extends PlantEvent {}

class AddPlant extends PlantEvent {
  final Plant plant;

  const AddPlant(this.plant);

  @override
  List<Object?> get props => [plant];
}

class UpdatePlant extends PlantEvent {
  final Plant plant;

  const UpdatePlant(this.plant);

  @override
  List<Object?> get props => [plant];
}

class DeletePlant extends PlantEvent {
  final String plantId;

  const DeletePlant(this.plantId);

  @override
  List<Object?> get props => [plantId];
}

class AddGrowthEntry extends PlantEvent {
  final String plantId;
  final GrowthEntry entry;

  const AddGrowthEntry(this.plantId, this.entry);

  @override
  List<Object?> get props => [plantId, entry];
}

class UpdateWateringSchedule extends PlantEvent {
  final String plantId;
  final WateringSchedule schedule;

  const UpdateWateringSchedule(this.plantId, this.schedule);

  @override
  List<Object?> get props => [plantId, schedule];
}

class RecognizePlant extends PlantEvent {
  final String imagePath;

  const RecognizePlant(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class GetLightingRecommendations extends PlantEvent {
  final String plantId;

  const GetLightingRecommendations(this.plantId);

  @override
  List<Object?> get props => [plantId];
}

class UpdatePlantCareSchedule extends PlantEvent {
  final String plantId;

  const UpdatePlantCareSchedule(this.plantId);

  @override
  List<Object?> get props => [plantId];
}

abstract class PlantState extends Equatable {
  const PlantState();

  @override
  List<Object?> get props => [];
}

class PlantInitial extends PlantState {}

class PlantsLoading extends PlantState {}

class PlantsLoaded extends PlantState {
  final List<Plant> plants;

  const PlantsLoaded(this.plants);

  @override
  List<Object?> get props => [plants];
}

class PlantRecognized extends PlantState {
  final Map<String, dynamic> recognitionResult;

  const PlantRecognized(this.recognitionResult);

  @override
  List<Object?> get props => [recognitionResult];
}

class LightingRecommendationsLoaded extends PlantState {
  final Map<String, dynamic> recommendations;

  const LightingRecommendationsLoaded(this.recommendations);

  @override
  List<Object?> get props => [recommendations];
}

class PlantCareScheduleUpdated extends PlantState {
  final Map<String, dynamic> careSchedule;

  const PlantCareScheduleUpdated(this.careSchedule);

  @override
  List<Object?> get props => [careSchedule];
}

class PlantOperationSuccess extends PlantState {}

class PlantOperationFailure extends PlantState {
  final String error;

  const PlantOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class PlantBloc extends Bloc<PlantEvent, PlantState> {
  final Box<Plant> plantBox;
  final PlantAIService aiService;

  PlantBloc({
    required this.plantBox,
    required this.aiService,
  }) : super(PlantInitial()) {
    on<LoadPlants>(_onLoadPlants);
    on<AddPlant>(_onAddPlant);
    on<UpdatePlant>(_onUpdatePlant);
    on<DeletePlant>(_onDeletePlant);
    on<AddGrowthEntry>(_onAddGrowthEntry);
    on<UpdateWateringSchedule>(_onUpdateWateringSchedule);
    on<RecognizePlant>(_onRecognizePlant);
    on<GetLightingRecommendations>(_onGetLightingRecommendations);
    on<UpdatePlantCareSchedule>(_onUpdatePlantCareSchedule);
  }

  Future<void> _onLoadPlants(LoadPlants event, Emitter<PlantState> emit) async {
    emit(PlantsLoading());
    try {
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    } catch (e) {
      emit(PlantOperationFailure(e.toString()));
    }
  }

  Future<void> _onAddPlant(AddPlant event, Emitter<PlantState> emit) async {
    try {
      await plantBox.put(event.plant.id, event.plant);
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    } catch (e) {
      final plants = plantBox.values.toList();
      emit(PlantOperationFailure(e.toString()));
      emit(PlantsLoaded(plants));
    }
  }

  Future<void> _onUpdatePlant(
      UpdatePlant event, Emitter<PlantState> emit) async {
    try {
      await plantBox.put(event.plant.id, event.plant);
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    } catch (e) {
      emit(PlantOperationFailure(e.toString()));
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    }
  }

  Future<void> _onDeletePlant(
      DeletePlant event, Emitter<PlantState> emit) async {
    try {
      await plantBox.delete(event.plantId);
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    } catch (e) {
      emit(PlantOperationFailure(e.toString()));
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    }
  }

  Future<void> _onAddGrowthEntry(
    AddGrowthEntry event,
    Emitter<PlantState> emit,
  ) async {
    try {
      final plant = plantBox.get(event.plantId);
      if (plant != null) {
        plant.growthJournal.add(event.entry);
        await plantBox.put(event.plantId, plant);
        final plants = plantBox.values.toList();
        emit(PlantsLoaded(plants));
      } else {
        emit(const PlantOperationFailure('Plant not found'));
      }
    } catch (e) {
      emit(PlantOperationFailure(e.toString()));
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    }
  }

  Future<void> _onUpdateWateringSchedule(
    UpdateWateringSchedule event,
    Emitter<PlantState> emit,
  ) async {
    try {
      final plant = plantBox.get(event.plantId);
      if (plant != null) {
        plant.wateringSchedule = event.schedule;
        await plantBox.put(event.plantId, plant);
        final plants = plantBox.values.toList();
        emit(PlantsLoaded(plants));
      } else {
        emit(const PlantOperationFailure('Plant not found'));
        final plants = plantBox.values.toList();
        emit(PlantsLoaded(plants));
      }
    } catch (e) {
      emit(PlantOperationFailure(e.toString()));
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    }
  }

  Future<void> _onRecognizePlant(
    RecognizePlant event,
    Emitter<PlantState> emit,
  ) async {
    emit(PlantsLoading());
    try {
      final result = await aiService.identifyPlant(event.imagePath);
      emit(PlantRecognized(result));
    } catch (e) {
      emit(PlantOperationFailure(e.toString()));
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    }
  }

  Future<void> _onGetLightingRecommendations(
    GetLightingRecommendations event,
    Emitter<PlantState> emit,
  ) async {
    emit(PlantsLoading());
    try {
      final plant = plantBox.get(event.plantId);
      if (plant != null) {
        final recommendations = await aiService.getLightingRecommendations(
          plant.name,
          plant.lightingRecommendations,
        );
        emit(LightingRecommendationsLoaded(recommendations));
      } else {
        emit(const PlantOperationFailure('Plant not found'));
      }
    } catch (e) {
      emit(PlantOperationFailure(e.toString()));
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    }
  }

  Future<void> _onUpdatePlantCareSchedule(
    UpdatePlantCareSchedule event,
    Emitter<PlantState> emit,
  ) async {
    emit(PlantsLoading());
    try {
      final plant = plantBox.get(event.plantId);
      if (plant != null) {
        final careSchedule = await aiService.getPlantCareSchedule(
          plant.name,
          plant.careGuide,
        );
        emit(PlantCareScheduleUpdated(careSchedule));
      } else {
        emit(const PlantOperationFailure('Plant not found'));
        final plants = plantBox.values.toList();
        emit(PlantsLoaded(plants));
      }
    } catch (e) {
      emit(PlantOperationFailure(e.toString()));
      final plants = plantBox.values.toList();
      emit(PlantsLoaded(plants));
    }
  }
}
