import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WateringDetailsSheet extends StatefulWidget {
  final Plant plant;

  const WateringDetailsSheet({
    required this.plant,
  });

  @override
  State<WateringDetailsSheet> createState() => _WateringDetailsSheetState();
}

class _WateringDetailsSheetState extends State<WateringDetailsSheet> {
  late int _selectedFrequency;

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.plant.wateringSchedule.frequencyDays;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'График полива',
          style: AppTheme.headlineMedium,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Сохранить'),
          onPressed: _saveChanges,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCurrentSchedule(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildFrequencyPicker(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildWateringTips(),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildWateringHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSchedule() {
    final nextWatering = widget.plant.lastWatered.add(
      Duration(days: widget.plant.wateringSchedule.frequencyDays),
    );

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Текущий график',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Следующий полив:',
                    style: AppTheme.bodyMedium,
                  ),
                  Text(
                    _formatDate(nextWatering),
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingMedium,
                  vertical: AppTheme.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.refresh,
                      color: AppTheme.primaryGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Каждые ${widget.plant.wateringSchedule.frequencyDays} ${_getDaysWord(widget.plant.wateringSchedule.frequencyDays)}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
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

  Widget _buildFrequencyPicker() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Частота полива',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedFrequency = index + 1;
                });
              },
              children: List.generate(30, (index) {
                final days = index + 1;
                return Text(
                  '$days ${_getDaysWord(days)}',
                  style: AppTheme.bodyLarge,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWateringTips() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.lightbulb,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(width: AppTheme.paddingSmall),
              Text(
                'Советы по поливу',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            widget.plant.careGuide['watering'] ?? 'Нет рекомендаций',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          _buildWateringTip(
            icon: CupertinoIcons.drop,
            tip: 'Используйте отстоянную воду комнатной температуры',
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          _buildWateringTip(
            icon: CupertinoIcons.sun_dust,
            tip: 'Поливайте утром или вечером, избегая прямых солнечных лучей',
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          _buildWateringTip(
            icon: CupertinoIcons.hand_raised,
            tip: 'Проверяйте влажность почвы перед каждым поливом',
          ),
        ],
      ),
    );
  }

  Widget _buildWateringTip({
    required IconData icon,
    required String tip,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.primaryGreen,
          size: 16,
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        Expanded(
          child: Text(
            tip,
            style: AppTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildWateringHistory() {
    // TODO: Implement watering history view
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'История полива',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Center(
            child: Text(
              'История полива будет отображаться здесь',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    if (_selectedFrequency != widget.plant.wateringSchedule.frequencyDays) {
      final newSchedule = WateringSchedule(
        frequencyDays: _selectedFrequency,
        season: widget.plant.wateringSchedule.season,
        adjustments: widget.plant.wateringSchedule.adjustments,
      );

      context.read<PlantBloc>().add(
        UpdateWateringSchedule(widget.plant.id, newSchedule),
      );

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('График обновлен'),
          content: Text(
            'Теперь полив будет каждые $_selectedFrequency ${_getDaysWord(_selectedFrequency)}',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // закрываем диалог
                Navigator.pop(context); // закрываем sheet
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _getDaysWord(int days) {
    if (days % 10 == 1 && days % 100 != 11) {
      return 'день';
    } else if ([2, 3, 4].contains(days % 10) && ![12, 13, 14].contains(days % 100)) {
      return 'дня';
    } else {
      return 'дней';
    }
  }
}