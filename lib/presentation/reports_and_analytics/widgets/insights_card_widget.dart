import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InsightsCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const InsightsCardWidget({
    super.key,
    required this.data,
  });

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
                  'Financial Insights',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                CustomIconWidget(
                  iconName: 'lightbulb',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'AI-powered analysis and recommendations',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 3.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final insight = data[index];
                return _buildInsightItem(insight);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(Map<String, dynamic> insight) {
    final insightType = insight["type"] as String;
    final color = _getInsightColor(insightType);
    final backgroundColor = color.withValues(alpha: 0.1);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: insight["icon"] as String,
                  color: AppTheme.lightTheme.colorScheme.surface,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight["title"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (insight["amount"] != null &&
                        (insight["amount"] as double) > 0)
                      Text(
                        '\$${insight["amount"].toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getInsightTypeLabel(insightType),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            insight["description"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'tips_and_updates',
                  color: color,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    insight["suggestion"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Handle dismiss action
                },
                child: Text(
                  'Dismiss',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: () {
                  _handleInsightAction(insightType);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: AppTheme.lightTheme.colorScheme.surface,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: Text(
                  _getActionButtonText(insightType),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getInsightColor(String type) {
    switch (type) {
      case 'warning':
        return AppTheme.lightTheme.colorScheme.error;
      case 'success':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'info':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getInsightTypeLabel(String type) {
    switch (type) {
      case 'warning':
        return 'Alert';
      case 'success':
        return 'Great!';
      case 'info':
        return 'Tip';
      default:
        return 'Info';
    }
  }

  String _getActionButtonText(String type) {
    switch (type) {
      case 'warning':
        return 'Set Budget';
      case 'success':
        return 'Save More';
      case 'info':
        return 'Learn More';
      default:
        return 'View Details';
    }
  }

  void _handleInsightAction(String type) {
    // Handle different insight actions based on type
    switch (type) {
      case 'warning':
        // Navigate to budget setting
        break;
      case 'success':
        // Navigate to savings goals
        break;
      case 'info':
        // Show more information
        break;
    }
  }
}
