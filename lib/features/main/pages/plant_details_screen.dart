import 'dart:io';
import 'package:ai_20/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import '../../../core/constants/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ai_20/features/main/widgets/edit_plant_sheet.dart';
import 'package:ai_20/features/main/widgets/growth_entry_sheet.dart';
import 'package:ai_20/features/main/widgets/lighting_details_sheet.dart';
import 'package:ai_20/features/main/widgets/watering_details_sheet.dart';
import 'package:ai_20/features/main/widgets/cuprtino_sliver_hearder.dart';

class PlantDetailsScreen extends StatefulWidget {
  final Plant plant;

  const PlantDetailsScreen({
    super.key,
    required this.plant,
  });

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  final _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_isHeaderCollapsed) {
      setState(() => _isHeaderCollapsed = true);
    } else if (_scrollController.offset <= 200 && _isHeaderCollapsed) {
      setState(() => _isHeaderCollapsed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight.withOpacity(
          _isHeaderCollapsed ? 1.0 : 0.0,
        ),
        border: null,
        middle: _isHeaderCollapsed
            ? Text(
                widget.plant.name,
                style: AppTheme.headlineMedium.copyWith(
                  color: AppTheme.primaryGreen,
                ),
              )
            : null,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.ellipsis_circle,
            color: AppTheme.primaryGreen,
          ),
          onPressed: () => _showActions(context),
        ),
      ),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeader(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return CupertinoSliverHeader(
      expandedHeight: 300,
      backgroundColor: AppTheme.backgroundLight,
      background: Hero(
        tag: 'plant_image_${widget.plant.id}',
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(widget.plant.imageUrl),
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CupertinoColors.black.withOpacity(0.0),
                    AppTheme.primaryGreen.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppTheme.paddingMedium,
              right: AppTheme.paddingMedium,
              bottom: AppTheme.paddingMedium,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.plant.name,
                    style: AppTheme.headlineLarge.copyWith(
                      color: CupertinoColors.white,
                    ),
                  ),
                  Text(
                    widget.plant.species,
                    style: AppTheme.bodyLarge.copyWith(
                      color: CupertinoColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCareSection(),
            const SizedBox(height: AppTheme.paddingMedium),
            _buildWateringSection(),
            const SizedBox(height: AppTheme.paddingMedium),
            _buildGrowthJournal(),
          ]
              .animate(interval: 100.milliseconds)
              .fadeIn(
                duration: AppTheme.animationNormal,
              )
              .slideY(
                begin: 0.2,
                duration: AppTheme.animationNormal,
                curve: Curves.easeOutQuad,
              ),
        ),
      ),
    );
  }

  Widget _buildCareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Plant Care',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: AppTheme.paddingMedium),
        Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: AppTheme.cardDecoration,
          child: Column(
            children: [
              _buildCareItem(
                icon: CupertinoIcons.sun_max,
                title: 'Lighting',
                content: widget.plant.lightingGuide['optimal_conditions'] ??
                    'No data available',
                onTap: () => _showLightingDetails(context),
              ),
              const Divider(height: AppTheme.paddingLarge),
              _buildCareItem(
                icon: CupertinoIcons.drop,
                title: 'Watering',
                content:
                    widget.plant.careGuide['watering'] ?? 'No data available',
                onTap: () => _showWateringDetails(context),
              ),
              const Divider(height: AppTheme.paddingLarge),
              _buildCareItem(
                icon: CupertinoIcons.thermometer,
                title: 'Temperature',
                content: widget.plant.careGuide['temperature'] ??
                    'No data available',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWateringSection() {
    final nextWatering = widget.plant.lastWatered.add(
      Duration(days: widget.plant.wateringSchedule.frequencyDays),
    );
    final daysUntil = nextWatering.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.drop_fill,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(width: AppTheme.paddingSmall),
              Text(
                'Next Watering',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getWateringStatusText(daysUntil),
                    style: AppTheme.bodyLarge.copyWith(
                      color: _getWateringStatusColor(daysUntil),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Last watered: ${_formatDate(widget.plant.lastWatered)}',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingMedium,
                ),
                child: const Text('Watered'),
                onPressed: () => _markAsWatered(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthJournal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Growth Journal',
              style: AppTheme.headlineMedium,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('Add Entry'),
              onPressed: () => _addGrowthEntry(context),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.paddingMedium),
        if (widget.plant.growthJournal.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: Column(
                children: [
                  const Icon(
                    CupertinoIcons.chart_bar_alt_fill,
                    size: 48,
                    color: AppTheme.lightGreen,
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  Text(
                    'No entries yet',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textMedium,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  Text(
                    'Add your first growth entry for your plant',
                    style: AppTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.plant.growthJournal.length,
            separatorBuilder: (context, index) => const Divider(
              height: AppTheme.paddingLarge,
            ),
            itemBuilder: (context, index) {
              final entry = widget.plant.growthJournal[index];
              return _buildGrowthEntry(entry);
            },
          ),
      ],
    );
  }

  Widget _buildCareItem({
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: AppTheme.paddingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  content,
                  style: AppTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(
              CupertinoIcons.chevron_right,
              color: AppTheme.textLight,
            ),
        ],
      ),
    );
  }

  Widget _buildGrowthEntry(GrowthEntry entry) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(entry.date),
                style: AppTheme.bodyMedium,
              ),
              if (entry.height != null || entry.numberOfLeaves != null)
                Row(
                  children: [
                    if (entry.height != null) ...[
                      const Icon(
                        CupertinoIcons.arrow_up,
                        size: 16,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.height} cm',
                        style: AppTheme.bodyMedium,
                      ),
                      const SizedBox(width: AppTheme.paddingMedium),
                    ],
                    if (entry.numberOfLeaves != null) ...[
                      const Icon(
                        CupertinoIcons.leaf_arrow_circlepath,
                        size: 16,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.numberOfLeaves} leaves',
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            entry.note,
            style: AppTheme.bodyLarge,
          ),
          if (entry.imageUrl != null) ...[
            const SizedBox(height: AppTheme.paddingSmall),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              child: Image.file(
                File(entry.imageUrl!),
                height: 200,
                width: double.infinity,
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
            ),
          ],
        ],
      ),
    );
  }

  String _getWateringStatusText(int daysUntil) {
    if (daysUntil < 0) {
      return 'Missed watering!';
    } else if (daysUntil == 0) {
      return 'Water today';
    } else {
      return 'In $daysUntil ${_getDaysWord(daysUntil)}';
    }
  }

  Color _getWateringStatusColor(int daysUntil) {
    if (daysUntil < 0) {
      return CupertinoColors.destructiveRed;
    } else if (daysUntil == 0) {
      return CupertinoColors.activeOrange;
    } else {
      return AppTheme.primaryGreen;
    }
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _showActions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _editPlant(context);
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showLightingDetails(context);
            },
            child: const Text('Lighting Recommendations'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _deletePlant(context);
            },
            isDestructiveAction: true,
            child: const Text('Delete Plant'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showLightingDetails(BuildContext context) {
    context.read<PlantBloc>().add(GetLightingRecommendations(widget.plant.id));

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => LightingDetailsSheet(plant: widget.plant),
    );
  }

  void _showWateringDetails(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => WateringDetailsSheet(plant: widget.plant),
    );
  }

  void _markAsWatered(BuildContext context) {
    final plant = widget.plant;
    plant.lastWatered = DateTime.now();

    context.read<PlantBloc>().add(UpdatePlant(plant));

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Great!'),
        content: Text(
          'Next watering in ${plant.wateringSchedule.frequencyDays} ${_getDaysWord(plant.wateringSchedule.frequencyDays)}',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addGrowthEntry(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => AddGrowthEntrySheet(plantId: widget.plant.id),
    );
  }

  void _editPlant(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => EditPlantSheet(plant: widget.plant),
    );
  }

  void _deletePlant(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Plant?'),
        content: const Text(
          'This action cannot be undone. All plant data will be deleted.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              context.read<PlantBloc>().add(DeletePlant(widget.plant.id));

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false);
            },
            isDestructiveAction: true,
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
