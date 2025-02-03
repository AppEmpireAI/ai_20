import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';

class LightingDetailsSheet extends StatelessWidget {
  final Plant plant;

  const LightingDetailsSheet({
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'Lighting',
          style: AppTheme.headlineMedium,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<PlantBloc, PlantState>(
          builder: (context, state) {
            if (state is LightingRecommendationsLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildOptimalConditions(
                        state.recommendations['optimal_conditions']),
                    const SizedBox(height: AppTheme.paddingMedium),
                    _buildPlacement(state.recommendations['placement']),
                    const SizedBox(height: AppTheme.paddingMedium),
                    _buildDistanceGuide(
                        state.recommendations['distance_guide']),
                    const SizedBox(height: AppTheme.paddingMedium),
                    _buildSeasonalAdjustments(
                        state.recommendations['seasonal_adjustments']),
                    const SizedBox(height: AppTheme.paddingMedium),
                    _buildWarningSection(
                        state.recommendations['warning_signs']),
                  ],
                ),
              );
            }

            if (state is PlantsLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            return const Center(
              child: Text('Failed to load recommendations'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptimalConditions(dynamic conditions) {
    if (conditions is Map<String, dynamic>) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(CupertinoIcons.sun_max, 'Optimal Conditions'),
            const SizedBox(height: AppTheme.paddingSmall),
            Text(
              'Light Type: ${conditions['light_type']}',
              style: AppTheme.bodyMedium,
            ),
            Text(
              'Light Intensity: ${conditions['light_intensity']}',
              style: AppTheme.bodyMedium,
            ),
            Text(
              'Duration: ${conditions['duration']}',
              style: AppTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPlacement(dynamic placement) {
    if (placement is List<dynamic>) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(CupertinoIcons.home, 'Placement'),
            const SizedBox(height: AppTheme.paddingSmall),
            ...placement.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    item.toString(),
                    style: AppTheme.bodyMedium,
                  ),
                )),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Build the Distance Guide Section
  Widget _buildDistanceGuide(dynamic distanceGuide) {
    if (distanceGuide is Map<String, dynamic>) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
                CupertinoIcons.resize_h, 'Distance from Light Sources'),
            const SizedBox(height: AppTheme.paddingSmall),
            Text(
              'Minimum Distance: ${distanceGuide['minimum_distance']}',
              style: AppTheme.bodyMedium,
            ),
            Text(
              'Maximum Distance: ${distanceGuide['maximum_distance']}',
              style: AppTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSeasonalAdjustments(dynamic seasonalAdjustments) {
    if (seasonalAdjustments is Map<String, dynamic>) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
                CupertinoIcons.calendar, 'Seasonal Adjustments'),
            const SizedBox(height: AppTheme.paddingSmall),
            ...seasonalAdjustments.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: AppTheme.bodyMedium,
                  ),
                )),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildWarningSection(dynamic warnings) {
    if (warnings is List<dynamic>) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        decoration: BoxDecoration(
          color: CupertinoColors.destructiveRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          border: Border.all(
            color: CupertinoColors.destructiveRed.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
                CupertinoIcons.exclamationmark_triangle, 'What to Watch For'),
            const SizedBox(height: AppTheme.paddingSmall),
            ...warnings.map((warning) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: AppTheme.bodyMedium.copyWith(
                          color: CupertinoColors.destructiveRed,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          warning.toString(),
                          style: AppTheme.bodyMedium.copyWith(
                            color: CupertinoColors.destructiveRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryGreen,
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        Text(
          title,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
