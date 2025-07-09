import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MonthlyComparisonChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const MonthlyComparisonChartWidget({
    super.key,
    required this.data,
  });

  @override
  State<MonthlyComparisonChartWidget> createState() =>
      _MonthlyComparisonChartWidgetState();
}

class _MonthlyComparisonChartWidgetState
    extends State<MonthlyComparisonChartWidget> {
  int? _touchedGroupIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: AppTheme.lightTheme.cardTheme.elevation,
        shape: AppTheme.lightTheme.cardTheme.shape,
        child: Padding(
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Income vs Expenses',
                    style: AppTheme.lightTheme.textTheme.titleLarge),
                CustomIconWidget(
                    iconName: 'bar_chart',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24),
              ]),
              SizedBox(height: 1.h),
              Text('Monthly comparison with savings trend',
                  style: AppTheme.lightTheme.textTheme.bodySmall),
              SizedBox(height: 3.h),
              SizedBox(
                  height: 25.h,
                  child: BarChart(BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 5000,
                      barTouchData: BarTouchData(
                          enabled: true,
                          touchCallback:
                              (FlTouchEvent event, barTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  barTouchResponse == null ||
                                  barTouchResponse.spot == null) {
                                _touchedGroupIndex = null;
                                return;
                              }
                              _touchedGroupIndex =
                                  barTouchResponse.spot!.touchedBarGroupIndex;
                            });
                          },
                          touchTooltipData: BarTouchTooltipData(getTooltipItem:
                              (group, groupIndex, rod, rodIndex) {
                            final item = widget.data[groupIndex];
                            String label = '';
                            String value = '';

                            switch (rodIndex) {
                              case 0:
                                label = 'Income';
                                value =
                                    '\$${item["income"].toStringAsFixed(0)}';
                                break;
                              case 1:
                                label = 'Expenses';
                                value =
                                    '\$${item["expenses"].toStringAsFixed(0)}';
                                break;
                              case 2:
                                label = 'Savings';
                                value =
                                    '\$${item["savings"].toStringAsFixed(0)}';
                                break;
                            }

                            return BarTooltipItem(
                                '$label\n$value',
                                AppTheme.lightTheme.textTheme.bodySmall!
                                    .copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w600));
                          })),
                      titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    if (value.toInt() < widget.data.length) {
                                      return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                              widget.data[value.toInt()]
                                                  ["month"] as String,
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall));
                                    }
                                    return const Text('');
                                  },
                                  reservedSize: 30)),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 42,
                                  interval: 1000,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(
                                            '\$${(value / 1000).toStringAsFixed(0)}k',
                                            style: AppTheme.lightTheme.textTheme
                                                .bodySmall));
                                  }))),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2))),
                      barGroups: widget.data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final isTouched = index == _touchedGroupIndex;

                        return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                  toY: item["income"] as double,
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  width: isTouched ? 5.w : 4.w,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4))),
                              BarChartRodData(
                                  toY: item["expenses"] as double,
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  width: isTouched ? 5.w : 4.w,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4))),
                              BarChartRodData(
                                  toY: item["savings"] as double,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  width: isTouched ? 5.w : 4.w,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4))),
                            ],
                            barsSpace: 1.w);
                      }).toList(),
                      gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1000,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                strokeWidth: 1);
                          })))),
              SizedBox(height: 2.h),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _buildLegendItem(
                    'Income', AppTheme.lightTheme.colorScheme.secondary),
                _buildLegendItem(
                    'Expenses', AppTheme.lightTheme.colorScheme.error),
                _buildLegendItem(
                    'Savings', AppTheme.lightTheme.colorScheme.primary),
              ]),
              SizedBox(height: 2.h),
              Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('Net Savings Trend',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                          SizedBox(height: 0.5.h),
                          Row(children: [
                            CustomIconWidget(
                                iconName: _getSavingsTrendIcon(),
                                color: _getSavingsTrendColor(),
                                size: 16),
                            SizedBox(width: 1.w),
                            Text(_getSavingsTrendText(),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                        color: _getSavingsTrendColor(),
                                        fontWeight: FontWeight.w500)),
                          ]),
                        ])),
                    Text('\$${_getAverageSavings().toStringAsFixed(0)}',
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600)),
                  ])),
            ])));
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      SizedBox(width: 1.w),
      Text(label, style: AppTheme.lightTheme.textTheme.bodySmall),
    ]);
  }

  String _getSavingsTrendIcon() {
    final currentSavings = widget.data.last["savings"] as double;
    final previousSavings =
        widget.data[widget.data.length - 2]["savings"] as double;

    if (currentSavings > previousSavings) {
      return 'trending_up';
    } else if (currentSavings < previousSavings) {
      return 'trending_down';
    } else {
      return 'trending_flat';
    }
  }

  Color _getSavingsTrendColor() {
    final currentSavings = widget.data.last["savings"] as double;
    final previousSavings =
        widget.data[widget.data.length - 2]["savings"] as double;

    if (currentSavings > previousSavings) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else if (currentSavings < previousSavings) {
      return AppTheme.lightTheme.colorScheme.error;
    } else {
      return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getSavingsTrendText() {
    final currentSavings = widget.data.last["savings"] as double;
    final previousSavings =
        widget.data[widget.data.length - 2]["savings"] as double;
    final difference =
        ((currentSavings - previousSavings) / previousSavings * 100).abs();

    if (currentSavings > previousSavings) {
      return '+${difference.toStringAsFixed(1)}% from last month';
    } else if (currentSavings < previousSavings) {
      return '-${difference.toStringAsFixed(1)}% from last month';
    } else {
      return 'No change from last month';
    }
  }

  double _getAverageSavings() {
    return widget.data
            .map((item) => item["savings"] as double)
            .reduce((a, b) => a + b) /
        widget.data.length;
  }
}
