import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedOptionsWidget extends StatelessWidget {
  final bool isExpanded;
  final bool isRecurring;
  final bool isTaxDeductible;
  final VoidCallback onExpandToggle;
  final ValueChanged<bool> onRecurringToggle;
  final ValueChanged<bool> onTaxDeductibleToggle;

  const AdvancedOptionsWidget({
    super.key,
    required this.isExpanded,
    required this.isRecurring,
    required this.isTaxDeductible,
    required this.onExpandToggle,
    required this.onRecurringToggle,
    required this.onTaxDeductibleToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: onExpandToggle,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Advanced Options',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Column(
                    children: [
                      Divider(
                        height: 1,
                        color: AppTheme.lightTheme.dividerColor,
                      ),

                      // Recurring Expense Option
                      Container(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'repeat',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recurring Expense',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Set up automatic recurring entries',
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
                            Switch(
                              value: isRecurring,
                              onChanged: onRecurringToggle,
                            ),
                          ],
                        ),
                      ),

                      Divider(
                        height: 1,
                        color: AppTheme.lightTheme.dividerColor,
                      ),

                      // Tax Deductible Option
                      Container(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.tertiary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'receipt_long',
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tax Deductible',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Mark as business or tax deductible expense',
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
                            Switch(
                              value: isTaxDeductible,
                              onChanged: onTaxDeductibleToggle,
                            ),
                          ],
                        ),
                      ),

                      Divider(
                        height: 1,
                        color: AppTheme.lightTheme.dividerColor,
                      ),

                      // Split Transaction Option
                      Container(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'call_split',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Split Transaction',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Divide expense across multiple categories',
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
                            CustomIconWidget(
                              iconName: 'keyboard_arrow_right',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
