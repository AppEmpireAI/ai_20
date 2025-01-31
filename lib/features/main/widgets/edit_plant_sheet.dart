import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';

class EditPlantSheet extends StatefulWidget {
  final Plant plant;

  const EditPlantSheet({
    required this.plant,
  });

  @override
  State<EditPlantSheet> createState() => _EditPlantSheetState();
}

class _EditPlantSheetState extends State<EditPlantSheet> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  String? _newImagePath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.plant.name;
    _speciesController.text = widget.plant.species;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _newImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'Edit Plant',
          style: AppTheme.headlineMedium,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _canSave() ? _savePlant : null,
          child: Text(
            'Save',
            style: TextStyle(
              color: _canSave() ? AppTheme.primaryGreen : AppTheme.textLight,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildForm(),
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              child: _newImagePath != null
                  ? Image.file(
                      File(_newImagePath!),
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(widget.plant.imageUrl),
                      fit: BoxFit.cover,
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.black.withOpacity(0.3),
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusMedium),
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.camera,
                  color: CupertinoColors.white,
                  size: 48,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.paddingSmall),
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Plant Name',
                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusSmall),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(0.2),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.paddingMedium),
              Text(
                'Species',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.paddingSmall),
              CupertinoTextField(
                controller: _speciesController,
                placeholder: 'Plant Species',
                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusSmall),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _canSave() {
    return _nameController.text.isNotEmpty &&
        _speciesController.text.isNotEmpty;
  }

  void _savePlant() {
    final updatedPlant = Plant(
      id: widget.plant.id,
      name: _nameController.text,
      species: _speciesController.text,
      imageUrl: _newImagePath ?? widget.plant.imageUrl,
      lastWatered: widget.plant.lastWatered,
      lastFertilized: widget.plant.lastFertilized,
      careGuide: widget.plant.careGuide,
      lightingGuide: widget.plant.lightingGuide,
      wateringSchedule: widget.plant.wateringSchedule,
      growthJournal: widget.plant.growthJournal,
    );

    context.read<PlantBloc>().add(UpdatePlant(updatedPlant));
    Navigator.of(context).pop();
  }
}
