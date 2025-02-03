import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';

class GrowthJournalScreen extends StatefulWidget {
  const GrowthJournalScreen({super.key});

  @override
  State<GrowthJournalScreen> createState() => _GrowthJournalScreenState();
}

class _GrowthJournalScreenState extends State<GrowthJournalScreen> {
  String _selectedMetric = 'height';
  String _selectedTimeRange = '1M';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        border: null,
        middle: Text(
          'Growth Journal',
          style: AppTheme.headlineMedium.copyWith(
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
      child: BlocBuilder<PlantBloc, PlantState>(
        builder: (context, state) {
          if (state is PlantsLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (state is PlantsLoaded) {
            if (state.plants.isEmpty) {
              return _buildEmptyState();
            }

            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                children: [
                  _buildMetricSelector(),
                  const SizedBox(height: AppTheme.paddingMedium),
                  _buildTimeRangeSelector(),
                  const SizedBox(height: AppTheme.paddingMedium),
                  _buildGrowthChart(state.plants),
                  const SizedBox(height: AppTheme.paddingLarge),
                  _buildJournalHeader(),
                  const SizedBox(height: AppTheme.paddingMedium),
                  ..._buildJournalEntries(state.plants),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.chart_bar_alt_fill,
            size: 64,
            color: AppTheme.lightGreen,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Text(
            'No Plants Yet',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textMedium,
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            'Add plants to start tracking their growth',
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          CupertinoButton.filled(
            child: const Text('Add First Plant'),
            onPressed: () {
              final tabController = CupertinoTabController(initialIndex: 0);
              tabController.index = 0;
            },
          ),
        ],
      ).animate().fadeIn(duration: AppTheme.animationNormal).slideY(
            begin: 0.2,
            duration: AppTheme.animationNormal,
          ),
    );
  }

  Widget _buildMetricSelector() {
    return CupertinoSlidingSegmentedControl<String>(
      backgroundColor: AppTheme.lightGreen.withOpacity(0.1),
      thumbColor: AppTheme.primaryGreen,
      groupValue: _selectedMetric,
      onValueChanged: (value) {
        if (value != null) {
          setState(() => _selectedMetric = value);
        }
      },
      children: {
        'height': _buildSegmentItem('Height'),
        'leaves': _buildSegmentItem('Leaves'),
      },
    );
  }

  Widget _buildTimeRangeSelector() {
    return CupertinoSlidingSegmentedControl<String>(
      backgroundColor: AppTheme.lightGreen.withOpacity(0.1),
      thumbColor: AppTheme.primaryGreen,
      groupValue: _selectedTimeRange,
      onValueChanged: (value) {
        if (value != null) {
          setState(() => _selectedTimeRange = value);
        }
      },
      children: {
        '1M': _buildSegmentItem('1M'),
        '3M': _buildSegmentItem('3M'),
        '6M': _buildSegmentItem('6M'),
        '1Y': _buildSegmentItem('1Y'),
        'ALL': _buildSegmentItem('ALL'),
      },
    );
  }

  Widget _buildSegmentItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingSmall),
      child: Text(
        text,
        style: AppTheme.bodyMedium.copyWith(
          color: CupertinoColors.black,
        ),
      ),
    );
  }

  Widget _buildGrowthChart(List<Plant> plants) {
    final data = _prepareGrowthData(plants);
    if (data.isEmpty) {
      return _buildEmptyChart();
    }

    return Container(
      height: 300,
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.textLight.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final date =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return SideTitleWidget(
                    // meta: meta,
                    axisSide: meta.axisSide,
                    child: Text(
                      _formatDateForChart(date),
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
                interval: _calculateDateInterval(data),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    // meta: meta,
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toInt().toString(),
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
                interval: _calculateValueInterval(data),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.map((point) {
                return FlSpot(
                  point.date.millisecondsSinceEpoch.toDouble(),
                  _selectedMetric == 'height'
                      ? point.height
                      : point.leaves.toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: AppTheme.primaryGreen,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppTheme.primaryGreen,
                    strokeWidth: 2,
                    strokeColor: CupertinoColors.black,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primaryGreen.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor: AppTheme.primaryGreen.withOpacity(0.8),
              tooltipBorder:
                  const BorderSide(color: CupertinoColors.black, width: 2),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final date =
                      DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                  return LineTooltipItem(
                    '${_formatDate(date)}\n${spot.y.toStringAsFixed(1)} ${_selectedMetric == 'height' ? 'cm' : 'leaves'}',
                    AppTheme.bodyMedium.copyWith(
                      color: CupertinoColors.black,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: AppTheme.animationNormal).slideY(
          begin: 0.2,
          duration: AppTheme.animationNormal,
        );
  }

  Widget _buildEmptyChart() {
    return Container(
      height: 300,
      decoration: AppTheme.cardDecoration,
      child: Center(
        child: Text(
          'No growth data for selected period',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textLight,
          ),
        ),
      ),
    );
  }

  Widget _buildJournalHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Journal Entries',
          style: AppTheme.headlineMedium,
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showJournalHelp(context),
          child: const Icon(
            CupertinoIcons.info_circle,
            color: AppTheme.primaryGreen,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildJournalEntries(List<Plant> plants) {
    final entries = _getAllGrowthEntries(plants);

    if (entries.isEmpty) {
      return [
        Center(
          child: Text(
            'No journal entries yet',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textLight,
            ),
          ),
        ),
      ];
    }

    return entries.map((entry) {
      final plant = plants.firstWhere(
        (p) => p.growthJournal.contains(entry),
      );
      return _buildJournalEntry(entry, plant);
    }).toList();
  }

  Widget _buildJournalEntry(GrowthEntry entry, Plant plant) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.borderRadiusMedium),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: FileImage(File(plant.imageUrl)),
                ),
                const SizedBox(width: AppTheme.paddingSmall),
                Text(
                  plant.name,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(entry.date),
                  style: AppTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (entry.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppTheme.borderRadiusMedium),
              ),
              child: Image.file(
                File(entry.imageUrl!),
                height: 200,
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
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entry.height != null || entry.numberOfLeaves != null) ...[
                  _buildMeasurements(entry),
                  const SizedBox(height: AppTheme.paddingSmall),
                ],
                Text(
                  entry.note,
                  style: AppTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: AppTheme.animationNormal).slideY(
          begin: 0.2,
          duration: AppTheme.animationNormal,
        );
  }

  Widget _buildMeasurements(GrowthEntry entry) {
    return Row(
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
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.primaryGreen,
            ),
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
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.primaryGreen,
            ),
          ),
        ],
      ],
    );
  }

  void _showJournalHelp(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Growth Journal Tips'),
        content: const Text(
          'Track your plant\'s growth by adding regular measurements and photos. '
          'You can record height and leaf count to see progress over time.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _formatDateForChart(DateTime date) {
    switch (_selectedTimeRange) {
      case '1M':
      case '3M':
        return '${date.day}/${date.month}';
      case '6M':
      case '1Y':
        return DateFormat('MMM').format(date);
      case 'ALL':
        return DateFormat('MMM yy').format(date);
      default:
        return '${date.day}/${date.month}';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  double _calculateDateInterval(List<GrowthDataPoint> data) {
    if (data.length <= 1) return 1;

    final timeSpan = data.last.date.millisecondsSinceEpoch -
        data.first.date.millisecondsSinceEpoch;

    switch (_selectedTimeRange) {
      case '1M':
        return timeSpan / 4; // Show 4 dates
      case '3M':
        return timeSpan / 6;
      case '6M':
        return timeSpan / 6;
      case '1Y':
        return timeSpan / 12;
      case 'ALL':
        return timeSpan / 8;
      default:
        return timeSpan / 4;
    }
  }

  double _calculateValueInterval(List<GrowthDataPoint> data) {
    if (data.isEmpty) return 1;

    final values = data
        .map(
            (e) => _selectedMetric == 'height' ? e.height : e.leaves.toDouble())
        .toList();

    final max = values.reduce((max, value) => value > max ? value : max);
    final min = values.reduce((min, value) => value < min ? value : min);

    return ((max - min) / 5).roundToDouble().clamp(1, double.infinity);
  }

  List<GrowthEntry> _getAllGrowthEntries(List<Plant> plants) {
    final allEntries = plants.expand((plant) => plant.growthJournal).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return allEntries;
  }

  List<GrowthDataPoint> _prepareGrowthData(List<Plant> plants) {
    final allEntries = _getAllGrowthEntries(plants);
    final filteredEntries = _filterEntriesByTimeRange(allEntries);

    return filteredEntries
        .where((entry) => _selectedMetric == 'height'
            ? entry.height != null
            : entry.numberOfLeaves != null)
        .map((entry) {
      return GrowthDataPoint(
        date: entry.date,
        height: entry.height ?? 0,
        leaves: entry.numberOfLeaves ?? 0,
      );
    }).toList();
  }

  List<GrowthEntry> _filterEntriesByTimeRange(List<GrowthEntry> entries) {
    final now = DateTime.now();
    final startDate = switch (_selectedTimeRange) {
      '1M' => now.subtract(const Duration(days: 30)),
      '3M' => now.subtract(const Duration(days: 90)),
      '6M' => now.subtract(const Duration(days: 180)),
      '1Y' => now.subtract(const Duration(days: 365)),
      'ALL' => DateTime(1970), // Show all entries
      _ => now.subtract(const Duration(days: 30)),
    };

    return entries.where((entry) => entry.date.isAfter(startDate)).toList();
  }
}

class GrowthDataPoint {
  final DateTime date;
  final double height;
  final int leaves;

  const GrowthDataPoint({
    required this.date,
    required this.height,
    required this.leaves,
  });
}
