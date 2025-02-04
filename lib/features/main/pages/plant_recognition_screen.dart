import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/features/main/widgets/recognition_results_sheet.dart';

class PlantRecognitionScreen extends StatefulWidget {
  const PlantRecognitionScreen({super.key});

  @override
  State<PlantRecognitionScreen> createState() => _PlantRecognitionScreenState();
}

class _PlantRecognitionScreenState extends State<PlantRecognitionScreen> {
  String? _imagePath;
  bool _isRecognizing = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'Identify Plant',
          style: AppTheme.headlineMedium.copyWith(
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
      child: _imagePath == null ? _buildCameraView() : _buildRecognitionView(),
    );
  }

  Widget _buildCameraView() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                margin: const EdgeInsets.all(AppTheme.paddingMedium),
                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusLarge),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.camera_circle_fill,
                      size: 80,
                      color: AppTheme.primaryGreen.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    Text(
                      'Take a photo of your plant',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textMedium,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Text(
                      'Make sure the plant is well lit and in focus',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: AppTheme.animationNormal).scale(
                    begin: const Offset(0.9, 0.9),
                    duration: AppTheme.animationNormal,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              children: [
                _buildFeatureItem(
                  icon: CupertinoIcons.sparkles,
                  title: 'Instant Recognition',
                  description: 'Get detailed plant information in seconds',
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                _buildFeatureItem(
                  icon: CupertinoIcons.leaf_arrow_circlepath,
                  title: 'Care Guide',
                  description: 'Receive personalized care recommendations',
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                _buildFeatureItem(
                  icon: CupertinoIcons.calendar_badge_plus,
                  title: 'Easy Addition',
                  description: 'Add the plant to your collection with one tap',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecognitionView() {
    return SafeArea(
      child: BlocConsumer<PlantBloc, PlantState>(
        listener: (context, state) {
          if (state is PlantRecognized) {
            _showRecognitionResults(context, state.recognitionResult);
          } else if (state is PlantOperationFailure) {
            _showError(context, state.error);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(_imagePath!),
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
                    if (_isRecognizing)
                      Container(
                        color: CupertinoColors.black.withOpacity(0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CupertinoActivityIndicator(
                              radius: 20,
                              color: CupertinoColors.white,
                            ),
                            const SizedBox(height: AppTheme.paddingMedium),
                            Text(
                              'Analyzing your plant...',
                              style: AppTheme.bodyLarge.copyWith(
                                color: CupertinoColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Column(
                  children: [
                    CupertinoButton.filled(
                      onPressed: _isRecognizing ? null : _recognizePlant,
                      child: const Text('Identify'),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    CupertinoButton(
                      color: CupertinoColors.destructiveRed,
                      onPressed: _resetImage,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.paddingMedium),
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
                  description,
                  style: AppTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: 200.milliseconds)
        .fadeIn(duration: AppTheme.animationNormal)
        .slideX(
          begin: 0.2,
          duration: AppTheme.animationNormal,
        );
  }

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> _recognizePlant() async {
    if (_imagePath == null) return;

    setState(() {
      _isRecognizing = true;
    });

    final bytes = await File(_imagePath!).readAsBytes();
    final base64Image = base64Encode(bytes);

    context.read<PlantBloc>().add(RecognizePlant(base64Image));
  }

  void _resetImage() {
    setState(() {
      _imagePath = null;
      _isRecognizing = false;
    });
  }

  void _showError(BuildContext context, String error) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );

    setState(() {
      _isRecognizing = false;
    });
  }

  void _showRecognitionResults(
    BuildContext context,
    Map<String, dynamic> results,
  ) {
    setState(() {
      _isRecognizing = false;
    });

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => RecognitionResultsSheet(
        results: results,
        imagePath: _imagePath!,
      ),
    ).then((_) {
      // Reset the screen state when the sheet is closed
      if (mounted) {
        setState(() {
          _imagePath = null;
          _isRecognizing = false;
        });
      }
    });
  }
}
