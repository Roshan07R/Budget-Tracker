import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortDropdownWidget extends StatelessWidget {
  final String currentSort;
  final ValueChanged<String> onSortChanged;

  const SortDropdownWidget({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  static const List<String> _sortOptions = [
    'Date (Newest)',
    'Date (Oldest)',
    'Amount (High to Low)',
    'Amount (Low to High)',
    'Merchant Name (A-Z)',
    'Merchant Name (Z-A)',
    'Category',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentSort,
          onChanged: (String? newValue) {
            if (newValue != null) {
              onSortChanged(newValue);
            }
          },
          icon: CustomIconWidget(
            iconName: 'arrow_drop_down',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          style: AppTheme.lightTheme.textTheme.bodyMedium,
          dropdownColor: AppTheme.lightTheme.colorScheme.surface,
          items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getSortIcon(value),
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getSortIcon(String sortOption) {
    switch (sortOption) {
      case 'Date (Newest)':
        return 'calendar_today';
      case 'Date (Oldest)':
        return 'calendar_today';
      case 'Amount (High to Low)':
        return 'trending_down';
      case 'Amount (Low to High)':
        return 'trending_up';
      case 'Merchant Name (A-Z)':
        return 'sort_by_alpha';
      case 'Merchant Name (Z-A)':
        return 'sort_by_alpha';
      case 'Category':
        return 'category';
      default:
        return 'sort';
    }
  }
}
