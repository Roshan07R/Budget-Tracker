import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpendingInsightsWidget extends StatefulWidget {
  final Map<String, dynamic> insights;

  const SpendingInsightsWidget({
    super.key,
    required this.insights,
  });

  @override
  State<SpendingInsightsWidget> createState() => _SpendingInsightsWidgetState();
}

class _SpendingInsightsWidgetState extends State<SpendingInsightsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final weeklyData =
        (widget.insights["weeklyData"] as List).cast<Map<String, dynamic>>();
    final totalSpending = widget.insights["totalWeeklySpending"] as double;
    final weeklyChange = widget.insights["weeklyChange"] as double;

    return Container(
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(children: [
          _buildHeader(totalSpending, weeklyChange),
          if (_isExpanded) ...[
            Divider(height: 1, color: AppTheme.lightTheme.dividerColor),
            _buildChart(weeklyData),
          ],
        ]));
  }

  Widget _buildHeader(double totalSpending, double weeklyChange) {
    final isPositiveChange = weeklyChange >= 0;

    return GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Weekly Spending',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface)),
                      SizedBox(height: 0.5.h),
                      Text('\$${totalSpending.toStringAsFixed(2)}',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface)),
                    ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                          color: (isPositiveChange
                                  ? AppTheme.lightTheme.colorScheme.error
                                  : AppTheme.lightTheme.colorScheme.secondary)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        CustomIconWidget(
                            iconName: isPositiveChange
                                ? 'trending_up'
                                : 'trending_down',
                            color: isPositiveChange
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.colorScheme.secondary,
                            size: 14),
                        SizedBox(width: 1.w),
                        Text(
                            '${isPositiveChange ? '+' : ''}${weeklyChange.toStringAsFixed(1)}%',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                                    color: isPositiveChange
                                        ? AppTheme.lightTheme.colorScheme.error
                                        : AppTheme
                                            .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp)),
                      ])),
                  SizedBox(height: 0.5.h),
                  CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20),
                ]),
              ]),
            ])));
  }

  Widget _buildChart(List<Map<String, dynamic>> weeklyData) {
    return Container(
        padding: EdgeInsets.all(4.w),
        height: 30.h,
        child: BarChart(BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: weeklyData
                    .map((data) => data["amount"] as double)
                    .reduce((a, b) => a > b ? a : b) *
                1.2,
            barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                          '\$${rod.toY.toStringAsFixed(2)}',
                          AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w500));
                    })),
            titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < weeklyData.length) {
                            return Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Text(
                                    weeklyData[value.toInt()]["day"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme
                                                .lightTheme
                                                .colorScheme
                                                .onSurfaceVariant)));
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 30)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant));
                        }))),
            borderData: FlBorderData(show: false),
            barGroups: weeklyData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final amount = data["amount"] as double;

              return BarChartGroupData(x: index, barRods: [
                BarChartRodData(
                    toY: amount,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 6.w,
                    borderRadius: BorderRadius.circular(4)),
              ]);
            }).toList(),
            gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 50,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                      color: AppTheme.lightTheme.dividerColor, strokeWidth: 1);
                }))));
  }
}
