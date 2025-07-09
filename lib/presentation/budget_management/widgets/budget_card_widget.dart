import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetCardWidget extends StatelessWidget {
  final Map<String, dynamic> budget;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewTransactions;

  const BudgetCardWidget({
    super.key,
    required this.budget,
    required this.onEdit,
    required this.onDelete,
    required this.onViewTransactions,
  });

  @override
  Widget build(BuildContext context) {
    final spent = budget["spent"] as double;
    final limit = budget["limit"] as double;
    final percentage = spent / limit;
    final remainingDays = budget["remainingDays"] as int;
    final categoryColor = Color(budget["color"] as int);

    return Dismissible(
      key: Key(budget["id"].toString()),
      background: _buildSwipeBackground(
        color: AppTheme.lightTheme.colorScheme.primary,
        icon: 'edit',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeBackground(
        color: AppTheme.lightTheme.colorScheme.error,
        icon: 'delete',
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit();
          return false;
        } else {
          return await _showDeleteConfirmation(context);
        }
      },
      child: GestureDetector(
        onTap: onViewTransactions,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(categoryColor),
              SizedBox(height: 3.h),
              _buildAmountInfo(spent, limit),
              SizedBox(height: 2.h),
              _buildProgressBar(percentage, categoryColor),
              SizedBox(height: 2.h),
              _buildFooter(remainingDays, percentage),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required String icon,
    required Alignment alignment,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: CustomIconWidget(
            iconName: icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color categoryColor) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: budget["icon"],
            color: categoryColor,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            budget["category"],
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInfo(double spent, double limit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Spent",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              "\$${spent.toStringAsFixed(2)}",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: _getAmountColor(spent, limit),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Budget",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              "\$${limit.toStringAsFixed(2)}",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(double percentage, Color categoryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${(percentage * 100).toInt()}% used",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "\$${(budget["limit"] - budget["spent"]).toStringAsFixed(2)} left",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          height: 0.8.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: _getProgressColor(percentage),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(int remainingDays, double percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              "$remainingDays days left",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (percentage >= 0.8)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getStatusColor(percentage).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getStatusText(percentage),
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: _getStatusColor(percentage),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Color _getAmountColor(double spent, double limit) {
    final percentage = spent / limit;
    if (percentage >= 1.0) return AppTheme.lightTheme.colorScheme.error;
    if (percentage >= 0.8) return const Color(0xFFF57C00);
    return AppTheme.lightTheme.colorScheme.onSurface;
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 1.0) return AppTheme.lightTheme.colorScheme.error;
    if (percentage >= 0.8) return const Color(0xFFF57C00);
    return AppTheme.lightTheme.colorScheme.secondary;
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 1.0) return AppTheme.lightTheme.colorScheme.error;
    return const Color(0xFFF57C00);
  }

  String _getStatusText(double percentage) {
    if (percentage >= 1.0) return "Over Budget";
    return "Near Limit";
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Delete Budget",
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            content: Text(
              "Are you sure you want to delete this budget?",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  onDelete();
                },
                child: Text(
                  "Delete",
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
