import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';

class AddGrowthEntrySheet extends StatefulWidget {
  final String plantId;

  const AddGrowthEntrySheet({
    super.key,
    required this.plantId,
  });

  @override
  State<AddGrowthEntrySheet> createState() => _AddGrowthEntrySheetState();
}

class _AddGrowthEntrySheetState extends State<AddGrowthEntrySheet> {
  final _noteController = TextEditingController();
  final _heightController = TextEditingController();
  final _leavesController = TextEditingController();
  String? _selectedImage;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _noteController.dispose();
    _heightController.dispose();
    _leavesController.dispose();
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
        _selectedImage = image.path;
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
          'New Growth Entry',
          style: AppTheme.headlineMedium,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _canSave() ? _saveEntry : null,
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
              _buildDatePicker(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildMeasurements(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildNoteField(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildImagePicker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selectedDate,
              maximumDate: DateTime.now(),
              onDateTimeChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurements() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Measurements',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Height (cm)',
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    CupertinoTextField(
                      controller: _heightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                      placeholder: '0.0',
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
              const SizedBox(width: AppTheme.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of Leaves',
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    CupertinoTextField(
                      controller: _leavesController,
                      keyboardType: TextInputType.number,
                      placeholder: '0',
                      onChanged: (_) {
                        setState(() {});
                      },
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
          ),
        ],
      ),
    );
  }

  Widget _buildNoteField() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          CupertinoTextField(
            controller: _noteController,
            placeholder: 'Describe the plant’s condition...',
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            minLines: 3,
            maxLines: 5,
            onChanged: (_) {
              setState(() {});
            },
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              border: Border.all(
                color: AppTheme.primaryGreen.withOpacity(0.2),
              ),
            ),
          ),
        ],
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
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusMedium),
                    child: Image.file(
                      File(_selectedImage!),
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
                  Positioned(
                    right: AppTheme.paddingSmall,
                    top: AppTheme.paddingSmall,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: CupertinoColors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusSmall,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          color: CupertinoColors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
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
                    'Add Photo',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textMedium,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  bool _canSave() {
    return _noteController.text.isNotEmpty;
  }

  void _saveEntry() {
    final entry = GrowthEntry(
      date: _selectedDate,
      note: _noteController.text,
      imageUrl: _selectedImage,
      height: _heightController.text.isNotEmpty
          ? double.parse(_heightController.text)
          : null,
      numberOfLeaves: _leavesController.text.isNotEmpty
          ? int.parse(_leavesController.text)
          : null,
    );

    context.read<PlantBloc>().add(AddGrowthEntry(widget.plantId, entry));
    Navigator.of(context).pop();
  }
}
