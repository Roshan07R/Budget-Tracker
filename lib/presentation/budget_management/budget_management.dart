import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_budget_modal_widget.dart';
import './widgets/budget_card_widget.dart';
import './widgets/empty_budget_state_widget.dart';

class BudgetManagement extends StatefulWidget {
  const BudgetManagement({super.key});

  @override
  State<BudgetManagement> createState() => _BudgetManagementState();
}

class _BudgetManagementState extends State<BudgetManagement>
    with TickerProviderStateMixin {
  final int _currentIndex = 2; // Budgets tab active
  DateTime _currentMonth = DateTime.now();
  late TabController _tabController;

  final List<Map<String, dynamic>> _budgetData = [
    {
      "id": 1,
      "category": "Food & Dining",
      "icon": "restaurant",
      "spent": 450.75,
      "limit": 600.0,
      "remainingDays": 12,
      "color": 0xFF4CAF50,
      "transactions": [
        {"name": "Starbucks", "amount": 15.50, "date": "2024-01-15"},
        {"name": "McDonald's", "amount": 12.25, "date": "2024-01-14"},
      ]
    },
    {
      "id": 2,
      "category": "Transportation",
      "icon": "directions_car",
      "spent": 280.00,
      "limit": 300.0,
      "remainingDays": 12,
      "color": 0xFFF57C00,
      "transactions": [
        {"name": "Gas Station", "amount": 45.00, "date": "2024-01-15"},
        {"name": "Uber", "amount": 18.50, "date": "2024-01-13"},
      ]
    },
    {
      "id": 3,
      "category": "Entertainment",
      "icon": "movie",
      "spent": 180.50,
      "limit": 150.0,
      "remainingDays": 12,
      "color": 0xFFD32F2F,
      "transactions": [
        {"name": "Netflix", "amount": 15.99, "date": "2024-01-10"},
        {"name": "Cinema", "amount": 25.00, "date": "2024-01-08"},
      ]
    },
    {
      "id": 4,
      "category": "Utilities",
      "icon": "electrical_services",
      "spent": 120.00,
      "limit": 200.0,
      "remainingDays": 12,
      "color": 0xFF4CAF50,
      "transactions": [
        {"name": "Electric Bill", "amount": 85.00, "date": "2024-01-05"},
        {"name": "Internet", "amount": 35.00, "date": "2024-01-01"},
      ]
    },
  ];

  final List<Map<String, dynamic>> _navigationItems = [
    {"icon": "dashboard", "label": "Dashboard", "route": "/dashboard"},
    {"icon": "add", "label": "Add Expense", "route": "/add-expense"},
    {"icon": "list", "label": "Expenses", "route": "/expense-list"},
    {
      "icon": "account_balance_wallet",
      "label": "Budgets",
      "route": "/budget-management"
    },
    {
      "icon": "analytics",
      "label": "Reports",
      "route": "/reports-and-analytics"
    },
    {"icon": "person", "label": "Profile", "route": "/profile-and-settings"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToMonth(int direction) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + direction,
        1,
      );
    });
  }

  Future<void> _refreshBudgets() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showAddBudgetModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBudgetModalWidget(
        onBudgetAdded: (budget) {
          setState(() {
            _budgetData.add(budget);
          });
        },
      ),
    );
  }

  void _onNavigationTap(int index) {
    if (index != _currentIndex) {
      Navigator.pushNamed(context, _navigationItems[index]["route"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _budgetData.isEmpty ? _buildEmptyState() : _buildBudgetList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _navigateToMonth(-1),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'chevron_left',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
          Text(
            "${_getMonthName(_currentMonth.month)} ${_currentMonth.year}",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () => _navigateToMonth(1),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _showAddBudgetModal,
          child: Text(
            "Add Budget",
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 4.w),
      ],
    );
  }

  Widget _buildEmptyState() {
    return EmptyBudgetStateWidget(
      onCreateBudget: _showAddBudgetModal,
    );
  }

  Widget _buildBudgetList() {
    return RefreshIndicator(
      onRefresh: _refreshBudgets,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final budget = _budgetData[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: BudgetCardWidget(
                      budget: budget,
                      onEdit: () => _editBudget(budget),
                      onDelete: () => _deleteBudget(budget["id"]),
                      onViewTransactions: () => _viewTransactions(budget),
                    ),
                  );
                },
                childCount: _budgetData.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == _currentIndex;

              return GestureDetector(
                onTap: () => _onNavigationTap(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: item["icon"],
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        item["label"],
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showQuickActions,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      child: CustomIconWidget(
        iconName: 'more_horiz',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
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
            Text(
              "Quick Actions",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionItem(
              icon: 'content_copy',
              title: 'Duplicate Last Month',
              subtitle: 'Copy previous month\'s budgets',
              onTap: () {
                Navigator.pop(context);
                _duplicateLastMonth();
              },
            ),
            _buildQuickActionItem(
              icon: 'auto_awesome',
              title: 'Auto-Create from Analysis',
              subtitle: 'Generate budgets from spending patterns',
              onTap: () {
                Navigator.pop(context);
                _autoCreateBudgets();
              },
            ),
            _buildQuickActionItem(
              icon: 'download',
              title: 'Import from Templates',
              subtitle: 'Use pre-made budget templates',
              onTap: () {
                Navigator.pop(context);
                _importFromTemplates();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }

  void _editBudget(Map<String, dynamic> budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBudgetModalWidget(
        budget: budget,
        onBudgetAdded: (updatedBudget) {
          setState(() {
            final index =
                _budgetData.indexWhere((b) => b["id"] == budget["id"]);
            if (index != -1) {
              _budgetData[index] = updatedBudget;
            }
          });
        },
      ),
    );
  }

  void _deleteBudget(int budgetId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Budget",
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          "Are you sure you want to delete this budget? This action cannot be undone.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _budgetData.removeWhere((budget) => budget["id"] == budgetId);
              });
              Navigator.pop(context);
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
    );
  }

  void _viewTransactions(Map<String, dynamic> budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 70.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: EdgeInsets.only(left: 38.w, bottom: 3.h),
            ),
            Text(
              "${budget["category"]} Transactions",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: (budget["transactions"] as List).length,
                itemBuilder: (context, index) {
                  final transaction = (budget["transactions"] as List)[index];
                  return ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Color(budget["color"]).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: budget["icon"],
                        color: Color(budget["color"]),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      transaction["name"],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      transaction["date"],
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    trailing: Text(
                      "-\$${transaction["amount"].toStringAsFixed(2)}",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _duplicateLastMonth() {
    // Mock implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Last month's budgets duplicated successfully",
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _autoCreateBudgets() {
    // Mock implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Budgets created from spending analysis",
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _importFromTemplates() {
    // Mock implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Budget templates imported successfully",
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
