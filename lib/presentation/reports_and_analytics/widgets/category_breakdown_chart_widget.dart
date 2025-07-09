import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryBreakdownChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const CategoryBreakdownChartWidget({
    super.key,
    required this.data,
  });

  @override
  State<CategoryBreakdownChartWidget> createState() =>
      _CategoryBreakdownChartWidgetState();
}

class _CategoryBreakdownChartWidgetState
    extends State<CategoryBreakdownChartWidget> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category Breakdown',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                CustomIconWidget(
                  iconName: 'pie_chart',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Spending distribution by category',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 25.h,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                _touchedIndex = null;
                                return;
                              }
                              _touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 8.w,
                        sections: _buildPieChartSections(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = _touchedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _touchedIndex = isSelected ? null : index;
                          });
                          _showCategoryDetails(item);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(int.parse(item["color"] as String))
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: Color(
                                        int.parse(item["color"] as String)),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 3.w,
                                height: 3.w,
                                decoration: BoxDecoration(
                                  color:
                                      Color(int.parse(item["color"] as String)),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["category"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${item["percentage"]}%',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Spending',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${widget.data.map((item) => item["amount"] as double).reduce((a, b) => a + b).toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == _touchedIndex;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 12.w : 10.w;

      return PieChartSectionData(
        color: Color(int.parse(item["color"] as String)),
        value: item["percentage"] as double,
        title: '${item["percentage"]}%',
        radius: radius,
        titleStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.surface,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: item["icon"] as String,
                  color: Color(int.parse(item["color"] as String)),
                  size: 16,
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  void _showCategoryDetails(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Color(int.parse(category["color"] as String))
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: category["icon"] as String,
                    color: Color(int.parse(category["color"] as String)),
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category["category"] as String,
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                      Text(
                        '${category["percentage"]}% of total spending',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount Spent',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${category["amount"].toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Color(int.parse(category["color"] as String)),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to detailed category view
              },
              child: const Text('View Details'),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
