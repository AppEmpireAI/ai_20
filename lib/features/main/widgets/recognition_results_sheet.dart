import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';

class RecognitionResultsSheet extends StatefulWidget {
  final Map<String, dynamic> results;
  final String imagePath;

  const RecognitionResultsSheet({
    super.key,
    required this.results,
    required this.imagePath,
  });

  @override
  State<RecognitionResultsSheet> createState() =>
      _RecognitionResultsSheetState();
}

class _RecognitionResultsSheetState extends State<RecognitionResultsSheet> {
  final _nameController = TextEditingController();
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();

    final identification = widget.results['identification'] ?? {};
    final commonNames = identification['commonNames'] ?? [];

    _nameController.text = commonNames.isNotEmpty ? commonNames[0] : 'Unknown';
    _confidence = identification['confidence'] ?? 0.0;

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _confidence = identification['confidence'] ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'Plant Identified',
          style: AppTheme.headlineMedium,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildConfidenceIndicator(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildPlantDetails(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildCareGuide(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildAddToCollectionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: AppTheme.defaultShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Image.file(
          File(widget.imagePath),
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
    ).animate().fadeIn(duration: AppTheme.animationNormal).scale(
          begin: const Offset(0.95, 0.95),
          duration: AppTheme.animationNormal,
        );
  }

  Widget _buildConfidenceIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recognition Confidence',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: AppTheme.animationSlow,
                curve: Curves.easeInOut,
                height: 8,
                width: MediaQuery.of(context).size.width * _confidence,
                decoration: BoxDecoration(
                  color: _getConfidenceColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            '${(_confidence * 100).toStringAsFixed(1)}% match',
            style: AppTheme.bodyMedium.copyWith(
              color: _getConfidenceColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: AppTheme.animationNormal,
          delay: 200.milliseconds,
        );
  }

  Widget _buildPlantDetails() {
    final identification = widget.results['identification'] ?? {};

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plant Details',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          CupertinoTextField(
            controller: _nameController,
            placeholder: 'Plant Name',
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              border: Border.all(
                color: AppTheme.primaryGreen.withOpacity(0.2),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          _buildDetailItem(
            icon: CupertinoIcons.doc_text,
            title: 'Scientific Name',
            content: identification['species'] ?? 'Unknown',
          ),
          // const SizedBox(height: AppTheme.paddingSmall),
          // _buildDetailItem(
          //   icon: CupertinoIcons.tree,
          //   title: 'Family',
          //   content: identification['family'] ?? 'Unknown',
          // ),
          // const SizedBox(height: AppTheme.paddingSmall),
          // _buildDetailItem(
          //   icon: CupertinoIcons.globe,
          //   title: 'Native Region',
          //   content: identification['native_region'] ?? 'Unknown',
          // ),
        ],
      ),
    ).animate().fadeIn(
          duration: AppTheme.animationNormal,
          delay: 400.milliseconds,
        );
  }

  Widget _buildCareGuide() {
    final careGuide = widget.results['careGuide'] ?? {};

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Care Guide',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          _buildCareItem(
            icon: CupertinoIcons.drop,
            title: 'Watering',
            content: careGuide['water'] ?? 'No watering information available',
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          _buildCareItem(
            icon: CupertinoIcons.sun_max,
            title: 'Light',
            content: careGuide['light'] ?? 'No light information available',
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          _buildCareItem(
            icon: CupertinoIcons.thermometer,
            title: 'Temperature',
            content: careGuide['temperature'] ??
                'No temperature information available',
          ),
          // const SizedBox(height: AppTheme.paddingSmall),
          // _buildCareItem(
          //   icon: CupertinoIcons.arrow_up_arrow_down,
          //   title: 'Humidity',
          //   content:
          //       careGuide['humidity'] ?? 'No humidity information available',
          // ),
          const SizedBox(height: AppTheme.paddingSmall),
          _buildCareItem(
            icon: CupertinoIcons.layers_alt,
            title: 'Soil',
            content: careGuide['soil'] ?? 'No soil information available',
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: AppTheme.animationNormal,
          delay: 600.milliseconds,
        );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryGreen,
          size: 20,
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
              Text(
                content,
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCareItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 20,
          ),
          const SizedBox(width: AppTheme.paddingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyMedium.copyWith(
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
        ],
      ),
    );
  }

  Widget _buildAddToCollectionButton() {
    return CupertinoButton.filled(
      onPressed: _addToCollection,
      child: const Text('Add to My Collection'),
    )
        .animate()
        .fadeIn(
          duration: AppTheme.animationNormal,
          delay: 800.milliseconds,
        )
        .slideY(
          begin: 0.2,
          duration: AppTheme.animationNormal,
        );
  }

  Color _getConfidenceColor() {
    if (_confidence >= 0.9) {
      return AppTheme.primaryGreen;
    } else if (_confidence >= 0.7) {
      return CupertinoColors.activeOrange;
    } else {
      return CupertinoColors.destructiveRed;
    }
  }

  void _addToCollection() {
    if (_nameController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Name Required'),
          content: const Text('Please enter a name for your plant.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final careGuideMap = widget.results['careGuide'] ?? {};
    final growthInfoMap = widget.results['growthInfo'] ?? {};
    final identificationMap = widget.results['identification'] ?? {};

    final lightingRecommendationsMap =
        widget.results['lightingRecommendations'] ?? {};

    final careGuide = PlantCareGuide.fromMap(careGuideMap);
    final growthInfo = PlantGrowthInfo.fromJson(growthInfoMap);
    final identification = PlantIdentification.fromJson(identificationMap);
    final lightingRecommendations =
        LightingRecommendations.fromJson(lightingRecommendationsMap);

    final newPlant = Plant(
      name: _nameController.text,
      species: identification.species,
      imageUrl: widget.imagePath,
      lastWatered: DateTime.now(),
      lastFertilized: DateTime.now(),
      careGuide: careGuide,
      wateringSchedule: WateringSchedule(
        frequencyDays: 7,
        season: 'all',
        adjustments: {},
      ),
      growthInfo: growthInfo,
      identification: identification,
      lightingRecommendations: lightingRecommendations,
    );

    context.read<PlantBloc>().add(AddPlant(newPlant));

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Plant Added'),
        content: const Text('The plant has been added to your collection.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              if (mounted) {
                setState(() {
                  _nameController.clear();
                });
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
