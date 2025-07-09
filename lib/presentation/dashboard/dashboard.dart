import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/balance_card_widget.dart';
import './widgets/budget_progress_widget.dart';
import './widgets/recent_transactions_widget.dart';
import './widgets/spending_insights_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool _isBalanceVisible = true;
  int _currentIndex = 0;
  late TabController _tabController;

  // Mock data for dashboard
  final Map<String, dynamic> _dashboardData = {
    "currentBalance": 2847.50,
    "lastSyncTime": "2 minutes ago",
    "recentTransactions": [
      {
        "id": 1,
        "merchant": "Starbucks Coffee",
        "amount": -4.85,
        "category": "Food & Dining",
        "categoryIcon": "local_cafe",
        "date": "Today, 2:30 PM",
        "type": "expense"
      },
      {
        "id": 2,
        "merchant": "Salary Deposit",
        "amount": 3200.00,
        "category": "Income",
        "categoryIcon": "account_balance_wallet",
        "date": "Yesterday, 9:00 AM",
        "type": "income"
      },
      {
        "id": 3,
        "merchant": "Amazon Purchase",
        "amount": -89.99,
        "category": "Shopping",
        "categoryIcon": "shopping_bag",
        "date": "Dec 15, 3:45 PM",
        "type": "expense"
      },
      {
        "id": 4,
        "merchant": "Gas Station",
        "amount": -45.20,
        "category": "Transportation",
        "categoryIcon": "local_gas_station",
        "date": "Dec 14, 6:15 PM",
        "type": "expense"
      },
      {
        "id": 5,
        "merchant": "Netflix",
        "amount": -15.99,
        "category": "Entertainment",
        "categoryIcon": "movie",
        "date": "Dec 13, 12:00 PM",
        "type": "expense"
      }
    ],
    "budgets": [
      {
        "id": 1,
        "category": "Food & Dining",
        "spent": 245.80,
        "budget": 400.00,
        "daysLeft": 12,
        "color": 0xFF4CAF50
      },
      {
        "id": 2,
        "category": "Transportation",
        "spent": 180.50,
        "budget": 200.00,
        "daysLeft": 12,
        "color": 0xFFFF9800
      },
      {
        "id": 3,
        "category": "Entertainment",
        "spent": 95.99,
        "budget": 100.00,
        "daysLeft": 12,
        "color": 0xFFF44336
      }
    ],
    "spendingInsights": {
      "weeklyData": [
        {"day": "Mon", "amount": 45.20},
        {"day": "Tue", "amount": 32.15},
        {"day": "Wed", "amount": 78.90},
        {"day": "Thu", "amount": 23.45},
        {"day": "Fri", "amount": 156.80},
        {"day": "Sat", "amount": 89.30},
        {"day": "Sun", "amount": 67.25}
      ],
      "totalWeeklySpending": 493.05,
      "weeklyChange": -12.5
    }
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  void _navigateToAddExpense() {
    Navigator.pushNamed(context, AppRoutes.addExpense);
  }

  void _navigateToExpenseList() {
    Navigator.pushNamed(context, AppRoutes.expenseList);
  }

  void _navigateToBudgetManagement() {
    Navigator.pushNamed(context, AppRoutes.budgetManagement);
  }

  void _navigateToReports() {
    Navigator.pushNamed(context, AppRoutes.reportsAndAnalytics);
  }

  void _openSideMenu() {
    Navigator.pushNamed(context, AppRoutes.sideMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: _openSideMenu,
        icon: CustomIconWidget(
          iconName: 'menu',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Row(
        children: [
          Text(
            'Budget Tracker',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'sync',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  _dashboardData["lastSyncTime"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: CustomIconWidget(
            iconName: 'notifications_outlined',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceCardWidget(
              balance: _dashboardData["currentBalance"] as double,
              isVisible: _isBalanceVisible,
              onToggleVisibility: _toggleBalanceVisibility,
            ),
            SizedBox(height: 3.h),
            _buildSectionHeader('Recent Transactions',
                onViewAll: _navigateToExpenseList),
            SizedBox(height: 1.h),
            RecentTransactionsWidget(
              transactions: (_dashboardData["recentTransactions"] as List)
                  .cast<Map<String, dynamic>>(),
            ),
            SizedBox(height: 3.h),
            _buildSectionHeader('Budget Overview',
                onViewAll: _navigateToBudgetManagement),
            SizedBox(height: 1.h),
            BudgetProgressWidget(
              budgets: (_dashboardData["budgets"] as List)
                  .cast<Map<String, dynamic>>(),
            ),
            SizedBox(height: 3.h),
            _buildSectionHeader('Spending Insights',
                onViewAll: _navigateToReports),
            SizedBox(height: 1.h),
            SpendingInsightsWidget(
              insights:
                  _dashboardData["spendingInsights"] as Map<String, dynamic>,
            ),
            SizedBox(height: 10.h), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'View All',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
      selectedLabelStyle:
          AppTheme.lightTheme.bottomNavigationBarTheme.selectedLabelStyle,
      unselectedLabelStyle:
          AppTheme.lightTheme.bottomNavigationBarTheme.unselectedLabelStyle,
      elevation: 8,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
            // Already on dashboard
            break;
          case 1:
            _navigateToAddExpense();
            break;
          case 2:
            _navigateToReports();
            break;
          case 3:
            _navigateToExpenseList();
            break;
          case 4:
            _navigateToBudgetManagement();
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme
                    .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme
                    .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'bar_chart',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme
                    .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: _currentIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme
                    .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          label: 'Accounts',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'savings',
            color: _currentIndex == 4
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme
                    .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          label: 'Budget',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToAddExpense,
      backgroundColor:
          AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
      foregroundColor:
          AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
      elevation: AppTheme.lightTheme.floatingActionButtonTheme.elevation,
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
        size: 28,
      ),
    );
  }
}
