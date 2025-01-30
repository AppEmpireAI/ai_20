import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import '../../../core/constants/theme/app_theme.dart';

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
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

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
          'Добавить растение',
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
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
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
              'Сфотографировать растение',
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
            'Распознанное растение:',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            identification['species_name'] ?? 'Не удалось определить вид',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Text(
            'Рекомендации по уходу:',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          _buildCareGuideItem(
            icon: CupertinoIcons.drop,
            title: 'Полив:',
            content: careGuide['watering'] ?? 'Нет данных',
          ),
          _buildCareGuideItem(
            icon: CupertinoIcons.sun_max,
            title: 'Освещение:',
            content: careGuide['light'] ?? 'Нет данных',
          ),
          _buildCareGuideItem(
            icon: CupertinoIcons.thermometer,
            title: 'Температура:',
            content: careGuide['temperature'] ?? 'Нет данных',
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
          placeholder: 'Название растения',
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            border: Border.all(
              color: AppTheme.primaryGreen.withOpacity(0.2),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.paddingMedium),
        // Здесь можно добавить дополнительные поля формы
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
          child: const Text('Добавить растение'),
        ),
      ),
    );
  }

  void _savePlant() {
    if (_selectedImage == null || _recognitionResult == null) return;

    final newPlant = Plant(
      name: _nameController.text,
      species: _recognitionResult!['identification']['species_name'] ?? 'Неизвестный вид',
      imageUrl: _selectedImage!,
      lastWatered: DateTime.now(),
      lastFertilized: DateTime.now(),
      careGuide: _recognitionResult!['care_guide'] ?? {},
      lightingGuide: {
        'optimal_conditions': _recognitionResult!['care_guide']['light'] ?? 'Нет данных',
      },
      wateringSchedule: WateringSchedule(
        frequencyDays: 7, // Дефолтное значение, можно настроить позже
        season: 'all',
        adjustments: {},
      ),
    );

    context.read<PlantBloc>().add(AddPlant(newPlant));
    Navigator.of(context).pop();
  }
}