import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpendingTrendsChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String period;

  const SpendingTrendsChartWidget({
    super.key,
    required this.data,
    required this.period,
  });

  @override
  State<SpendingTrendsChartWidget> createState() =>
      _SpendingTrendsChartWidgetState();
}

class _SpendingTrendsChartWidgetState extends State<SpendingTrendsChartWidget> {
  int? _touchedIndex;

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
                Text('Spending Trends',
                    style: AppTheme.lightTheme.textTheme.titleLarge),
                CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24),
              ]),
              SizedBox(height: 1.h),
              Text('Daily spending patterns for ${widget.period.toLowerCase()}',
                  style: AppTheme.lightTheme.textTheme.bodySmall),
              SizedBox(height: 3.h),
              SizedBox(
                  height: 25.h,
                  child: LineChart(LineChartData(
                      gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 50,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                strokeWidth: 1);
                          }),
                      titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    if (value.toInt() < widget.data.length) {
                                      return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                              widget.data[value.toInt()]["day"]
                                                  as String,
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall));
                                    }
                                    return const Text('');
                                  })),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 50,
                                  reservedSize: 42,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text('\$${value.toInt()}',
                                            style: AppTheme.lightTheme.textTheme
                                                .bodySmall));
                                  }))),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2))),
                      minX: 0,
                      maxX: (widget.data.length - 1).toDouble(),
                      minY: 0,
                      maxY: 200,
                      lineBarsData: [
                        LineChartBarData(
                            spots: widget.data.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(),
                                  (entry.value["amount"] as double));
                            }).toList(),
                            isCurved: true,
                            gradient: LinearGradient(colors: [
                              AppTheme.lightTheme.colorScheme.primary,
                              AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                            ]),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  final item = widget.data[index];
                                  Color dotColor =
                                      AppTheme.lightTheme.colorScheme.primary;

                                  if (item["isHighest"] == true) {
                                    dotColor =
                                        AppTheme.lightTheme.colorScheme.error;
                                  } else if (item["isLowest"] == true) {
                                    dotColor = AppTheme
                                        .lightTheme.colorScheme.secondary;
                                  }

                                  return FlDotCirclePainter(
                                      radius: _touchedIndex == index ? 6 : 4,
                                      color: dotColor,
                                      strokeWidth: 2,
                                      strokeColor: AppTheme
                                          .lightTheme.colorScheme.surface);
                                }),
                            belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                    colors: [
                                      AppTheme.lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      AppTheme.lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter))),
                      ],
                      lineTouchData: LineTouchData(
                          enabled: true,
                          touchCallback: (FlTouchEvent event,
                              LineTouchResponse? touchResponse) {
                            setState(() {
                              if (touchResponse != null &&
                                  touchResponse.lineBarSpots != null) {
                                _touchedIndex =
                                    touchResponse.lineBarSpots!.first.spotIndex;
                              } else {
                                _touchedIndex = null;
                              }
                            });
                          },
                          touchTooltipData: LineTouchTooltipData(
                              getTooltipItems:
                                  (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final item = widget.data[barSpot.spotIndex];
                              return LineTooltipItem(
                                  '${item["day"]}\n\$${item["amount"].toStringAsFixed(2)}',
                                  AppTheme.lightTheme.textTheme.bodySmall!
                                      .copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w600));
                            }).toList();
                          }))))),
              SizedBox(height: 2.h),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _buildLegendItem(
                    'Highest',
                    AppTheme.lightTheme.colorScheme.error,
                    '\$${widget.data.where((item) => item["isHighest"] == true).first["amount"].toStringAsFixed(2)}'),
                _buildLegendItem(
                    'Lowest',
                    AppTheme.lightTheme.colorScheme.secondary,
                    '\$${widget.data.where((item) => item["isLowest"] == true).first["amount"].toStringAsFixed(2)}'),
                _buildLegendItem(
                    'Average',
                    AppTheme.lightTheme.colorScheme.primary,
                    '\$${(widget.data.map((item) => item["amount"] as double).reduce((a, b) => a + b) / widget.data.length).toStringAsFixed(2)}'),
              ]),
            ])));
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Column(children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 1.w),
        Text(label, style: AppTheme.lightTheme.textTheme.bodySmall),
      ]),
      SizedBox(height: 0.5.h),
      Text(value,
          style: AppTheme.lightTheme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
    ]);
  }
}
