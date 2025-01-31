// ignore_for_file: unused_field

import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import '../../../core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';

class AddPlantSheet extends StatefulWidget {
  const AddPlantSheet({super.key});

  @override
  State<AddPlantSheet> createState() => _AddPlantSheetState();
}

class _AddPlantSheetState extends State<AddPlantSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedImage;
  bool _isRecognizing = false;
  Map<String, dynamic>? _recognitionResult;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image.path;
        _isRecognizing = true;
      });

      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      context.read<PlantBloc>().add(RecognizePlant(base64Image));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'Add Plant',
          style: AppTheme.headlineMedium,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: BlocListener<PlantBloc, PlantState>(
          listener: (context, state) {
            if (state is PlantRecognized) {
              setState(() {
                _isRecognizing = false;
                _recognitionResult = state.recognitionResult;
                if (_nameController.text.isEmpty) {
                  _nameController.text = _recognitionResult?['identification']
                          ['common_name'] ??
                      '';
                }
              });
            }
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildImagePicker(),
                      const SizedBox(height: AppTheme.paddingMedium),
                      if (_isRecognizing)
                        const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      else if (_recognitionResult != null)
                        _buildRecognitionResult(),
                      const SizedBox(height: AppTheme.paddingMedium),
                      _buildForm(),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.lightGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          border: Border.all(
            color: AppTheme.primaryGreen.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusMedium),
                child: Image.file(
                  File(_selectedImage!),
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.camera,
                    size: 48,
                    color: AppTheme.primaryGreen.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  Text(
                    'Take a picture of the plant',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textMedium,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRecognitionResult() {
    final identification = _recognitionResult?['identification'] ?? {};
    final careGuide = _recognitionResult?['care_guide'] ?? {};

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recognized Plant:',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            identification['species_name'] ?? 'Could not determine species',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Text(
            'Care Recommendations:',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          _buildCareGuideItem(
            icon: CupertinoIcons.drop,
            title: 'Watering:',
            content: careGuide['watering'] ?? 'No data',
          ),
          _buildCareGuideItem(
            icon: CupertinoIcons.sun_max,
            title: 'Lighting:',
            content: careGuide['light'] ?? 'No data',
          ),
          _buildCareGuideItem(
            icon: CupertinoIcons.thermometer,
            title: 'Temperature:',
            content: careGuide['temperature'] ?? 'No data',
          ),
        ],
      ),
    );
  }

  Widget _buildCareGuideItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 16,
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

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoTextField(
          controller: _nameController,
          placeholder: 'Plant Name',
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            border: Border.all(
              color: AppTheme.primaryGreen.withOpacity(0.2),
            ),
          ),
          onChanged: (_) {
            setState(() {});
          },
        ),
        const SizedBox(height: AppTheme.paddingMedium),
        // Additional form fields can be added here
      ],
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: CupertinoButton.filled(
          onPressed: _selectedImage != null && _nameController.text.isNotEmpty
              ? _savePlant
              : null,
          child: const Text('Add Plant'),
        ),
      ),
    );
  }

  void _savePlant() {
    if (_selectedImage == null || _recognitionResult == null) return;

    final newPlant = Plant(
      name: _nameController.text,
      species: _recognitionResult!['identification']['species_name'] ??
          'Unknown species',
      imageUrl: _selectedImage!,
      lastWatered: DateTime.now(),
      lastFertilized: DateTime.now(),
      careGuide: _recognitionResult!['care_guide'] ?? {},
      lightingGuide: {
        'optimal_conditions':
            _recognitionResult!['care_guide']['light'] ?? 'No data',
      },
      wateringSchedule: WateringSchedule(
        frequencyDays: 7, // Default value, can be adjusted later
        season: 'all',
        adjustments: {},
      ),
    );

    context.read<PlantBloc>().add(AddPlant(newPlant));
    Navigator.of(context).pop();
  }
}
