import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          'Освещение',
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
                    _buildSection(
                      title: 'Оптимальные условия',
                      content: state.recommendations['optimal_conditions'],
                      icon: CupertinoIcons.sun_max,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    _buildSection(
                      title: 'Размещение',
                      content: state.recommendations['placement'],
                      icon: CupertinoIcons.home,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    _buildSection(
                      title: 'Расстояние от источников света',
                      content: state.recommendations['distance_guide'],
                      icon: CupertinoIcons.resize_h,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    _buildSection(
                      title: 'Сезонные изменения',
                      content: state.recommendations['seasonal_adjustments'],
                      icon: CupertinoIcons.calendar,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    _buildWarningSection(
                      warnings: state.recommendations['warning_signs'] as List<dynamic>,
                    ),
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
              child: Text('Не удалось загрузить рекомендации'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required dynamic content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            content is String
                ? content
                : content.toString(),
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSection({
    required List<dynamic> warnings,
  }) {
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
          Row(
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_triangle,
                color: CupertinoColors.destructiveRed,
              ),
              const SizedBox(width: AppTheme.paddingSmall),
              Text(
                'На что обратить внимание',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.destructiveRed,
                ),
              ),
            ],
          ),
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
}