import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpenseCardWidget extends StatelessWidget {
  final Map<String, dynamic> expense;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final String searchQuery;

  const ExpenseCardWidget({
    super.key,
    required this.expense,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDuplicate,
    this.onShare,
    this.onDelete,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense['id'] as String),
      background: _buildSwipeBackground(isLeft: false),
      secondaryBackground: _buildSwipeBackground(isLeft: true),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete?.call();
        } else if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                if (isSelectionMode) ...[
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) => onTap?.call(),
                  ),
                  SizedBox(width: 3.w),
                ],
                _buildCategoryIcon(),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMerchantName(),
                      SizedBox(height: 0.5.h),
                      _buildCategoryAndTime(),
                      SizedBox(height: 0.5.h),
                      _buildPaymentMethod(),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildAmount(),
                    SizedBox(height: 1.h),
                    _buildReceiptIndicator(),
                  ],
                ),
                if (expense['isFavorite'] == true) ...[
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'favorite',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: expense['categoryIcon'] as String,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildMerchantName() {
    final merchantName = expense['merchant'] as String;

    if (searchQuery.isNotEmpty &&
        merchantName.toLowerCase().contains(searchQuery.toLowerCase())) {
      return RichText(
        text: TextSpan(
          style: AppTheme.lightTheme.textTheme.titleMedium,
          children: _highlightSearchQuery(merchantName, searchQuery),
        ),
      );
    }

    return Text(
      merchantName,
      style: AppTheme.lightTheme.textTheme.titleMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCategoryAndTime() {
    final category = expense['category'] as String;
    final time = expense['time'] as String;

    return Row(
      children: [
        Expanded(
          child: searchQuery.isNotEmpty &&
                  category.toLowerCase().contains(searchQuery.toLowerCase())
              ? RichText(
                  text: TextSpan(
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    children: _highlightSearchQuery(category, searchQuery),
                  ),
                )
              : Text(
                  category,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        Text(
          ' • $time',
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: _getPaymentMethodIcon(expense['paymentMethod'] as String),
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          expense['paymentMethod'] as String,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAmount() {
    return Text(
      expense['amount'] as String,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        color: AppTheme.lightTheme.colorScheme.error,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildReceiptIndicator() {
    final hasReceipt = expense['hasReceipt'] as bool;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: hasReceipt
            ? AppTheme.lightTheme.colorScheme.secondaryContainer
            : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: hasReceipt ? 'receipt' : 'receipt_long',
            color: hasReceipt
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            hasReceipt ? 'Receipt' : 'No Receipt',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: hasReceipt
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'delete' : 'edit',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Delete' : 'Edit',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _highlightSearchQuery(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          backgroundColor:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
          fontWeight: FontWeight.w600,
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }

  String _getPaymentMethodIcon(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'credit card':
        return 'credit_card';
      case 'debit card':
        return 'payment';
      case 'cash':
        return 'money';
      case 'auto-pay':
        return 'autorenew';
      default:
        return 'payment';
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Expense',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            content: Text(
              'Are you sure you want to delete this expense? This action cannot be undone.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
