import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ai_20/features/main/widgets/add_plant_sheet.dart';
import 'package:ai_20/features/main/pages/plant_details_screen.dart';

class PlantCatalogScreen extends StatelessWidget {
  const PlantCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'My plants',
          style: AppTheme.headlineMedium.copyWith(
            color: AppTheme.primaryGreen,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.add,
            color: AppTheme.primaryGreen,
          ),
          onPressed: () => _showAddPlantBottomSheet(context),
        ),
      ),
      child: BlocBuilder<PlantBloc, PlantState>(
        builder: (context, state) {
          if (state is PlantsLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (state is PlantsLoaded) {
            if (state.plants.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.leaf_arrow_circlepath,
                      size: 64,
                      color: AppTheme.lightGreen,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    Text(
                      'Add your first plant',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textMedium,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    CupertinoButton(
                      child: const Text('Add a plant'),
                      onPressed: () => _showAddPlantBottomSheet(context),
                    ),
                  ],
                ),
              ).animate().fadeIn(
                    duration: AppTheme.animationNormal,
                  );
            }

            return CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    context.read<PlantBloc>().add(LoadPlants());
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppTheme.paddingMedium,
                      crossAxisSpacing: AppTheme.paddingMedium,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final plant = state.plants[index];
                        return PlantCard(plant: plant)
                            .animate()
                            .fadeIn(
                              duration: AppTheme.animationNormal,
                              delay: (index * 100).milliseconds,
                            )
                            .slideY(
                              begin: 0.2,
                              duration: AppTheme.animationNormal,
                              curve: Curves.easeOutQuad,
                            );
                      },
                      childCount: state.plants.length,
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text('Something went wrong.'),
          );
        },
      ),
    );
  }

  void _showAddPlantBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => const AddPlantSheet(),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPlantDetails(context),
      child: Container(
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.borderRadiusMedium),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(plant.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.lightGreen.withOpacity(0.1),
                          child: const Icon(
                            CupertinoIcons.leaf_arrow_circlepath,
                            color: AppTheme.lightGreen,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: AppTheme.paddingSmall,
                      right: AppTheme.paddingSmall,
                      child: _buildWateringIndicator(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plant.name,
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      plant.species,
                      style: AppTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.drop,
                          color: AppTheme.primaryGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getNextWateringText(),
                          style: AppTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWateringIndicator() {
    final daysUntilWatering = _getDaysUntilWatering();
    final color = daysUntilWatering <= 0
        ? CupertinoColors.destructiveRed
        : daysUntilWatering <= 1
            ? CupertinoColors.activeOrange
            : AppTheme.primaryGreen;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingSmall,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.drop_fill,
            color: CupertinoColors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            _getShortWateringText(),
            style: AppTheme.bodyMedium.copyWith(
              color: CupertinoColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  int _getDaysUntilWatering() {
    final nextWatering = plant.lastWatered.add(
      Duration(days: plant.wateringSchedule.frequencyDays),
    );
    return nextWatering.difference(DateTime.now()).inDays;
  }

  String _getNextWateringText() {
    final days = _getDaysUntilWatering();
    if (days < 0) {
      return 'Missed watering';
    } else if (days == 0) {
      return 'Water it today';
    } else {
      return 'In $days ${_getDaysWord(days)}';
    }
  }

  String _getShortWateringText() {
    final days = _getDaysUntilWatering();
    if (days < 0) return 'Urgently!';
    if (days == 0) return 'Today';
    return '$days days.';
  }

  String _getDaysWord(int days) {
    if (days % 10 == 1 && days % 100 != 11) {
      return 'day';
    } else if ([2, 3, 4].contains(days % 10) &&
        ![12, 13, 14].contains(days % 100)) {
      return 'days';
    } else {
      return 'days';
    }
  }

  void _showPlantDetails(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => PlantDetailsScreen(plant: plant),
      ),
    );
  }
}
