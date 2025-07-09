import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_breakdown_chart_widget.dart';
import './widgets/insights_card_widget.dart';
import './widgets/monthly_comparison_chart_widget.dart';
import './widgets/spending_trends_chart_widget.dart';
import './widgets/time_period_selector_widget.dart';
import './widgets/top_merchants_widget.dart';

class ReportsAndAnalytics extends StatefulWidget {
  const ReportsAndAnalytics({super.key});

  @override
  State<ReportsAndAnalytics> createState() => _ReportsAndAnalyticsState();
}

class _ReportsAndAnalyticsState extends State<ReportsAndAnalytics>
    with TickerProviderStateMixin {
  int _currentIndex = 3; // Reports tab active
  String _selectedPeriod = 'Month';
  bool _isLoading = false;
  final bool _isOffline = false;

  final List<Map<String, dynamic>> _mockSpendingData = [
    {
      "date": "2024-01-01",
      "amount": 45.50,
      "day": "Mon",
      "isHighest": false,
      "isLowest": true
    },
    {
      "date": "2024-01-02",
      "amount": 78.20,
      "day": "Tue",
      "isHighest": false,
      "isLowest": false
    },
    {
      "date": "2024-01-03",
      "amount": 156.75,
      "day": "Wed",
      "isHighest": true,
      "isLowest": false
    },
    {
      "date": "2024-01-04",
      "amount": 92.30,
      "day": "Thu",
      "isHighest": false,
      "isLowest": false
    },
    {
      "date": "2024-01-05",
      "amount": 67.80,
      "day": "Fri",
      "isHighest": false,
      "isLowest": false
    },
    {
      "date": "2024-01-06",
      "amount": 134.25,
      "day": "Sat",
      "isHighest": false,
      "isLowest": false
    },
    {
      "date": "2024-01-07",
      "amount": 89.40,
      "day": "Sun",
      "isHighest": false,
      "isLowest": false
    }
  ];

  final List<Map<String, dynamic>> _mockCategoryData = [
    {
      "category": "Food & Dining",
      "amount": 450.75,
      "percentage": 35.2,
      "color": "0xFFFF6B35",
      "icon": "restaurant"
    },
    {
      "category": "Transportation",
      "amount": 280.50,
      "percentage": 21.9,
      "color": "0xFF2E7D32",
      "icon": "directions_car"
    },
    {
      "category": "Shopping",
      "amount": 320.25,
      "percentage": 25.0,
      "color": "0xFF1B365D",
      "icon": "shopping_bag"
    },
    {
      "category": "Entertainment",
      "amount": 180.30,
      "percentage": 14.1,
      "color": "0xFFF57C00",
      "icon": "movie"
    },
    {
      "category": "Others",
      "amount": 48.20,
      "percentage": 3.8,
      "color": "0xFF6B7280",
      "icon": "more_horiz"
    }
  ];

  final List<Map<String, dynamic>> _mockMonthlyData = [
    {"month": "Oct", "income": 3500.0, "expenses": 2800.0, "savings": 700.0},
    {"month": "Nov", "income": 3800.0, "expenses": 3200.0, "savings": 600.0},
    {"month": "Dec", "income": 4200.0, "expenses": 3600.0, "savings": 600.0},
    {"month": "Jan", "income": 3900.0, "expenses": 3100.0, "savings": 800.0}
  ];

  final List<Map<String, dynamic>> _mockMerchantsData = [
    {
      "name": "Starbucks Coffee",
      "amount": 156.80,
      "visits": 12,
      "category": "Food & Dining",
      "logo": "https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg"
    },
    {
      "name": "Amazon",
      "amount": 289.45,
      "visits": 8,
      "category": "Shopping",
      "logo": "https://images.pexels.com/photos/230544/pexels-photo-230544.jpeg"
    },
    {
      "name": "Shell Gas Station",
      "amount": 180.20,
      "visits": 6,
      "category": "Transportation",
      "logo":
          "https://images.pexels.com/photos/33688/delicate-arch-night-stars-landscape.jpg"
    },
    {
      "name": "Netflix",
      "amount": 15.99,
      "visits": 1,
      "category": "Entertainment",
      "logo": "https://images.pexels.com/photos/265685/pexels-photo-265685.jpeg"
    }
  ];

  final List<Map<String, dynamic>> _mockInsightsData = [
    {
      "title": "Dining Spending Alert",
      "description":
          "You spent 20% more on dining this month compared to last month",
      "suggestion": "Try cooking at home 2-3 times per week to save \$80-120",
      "type": "warning",
      "icon": "trending_up",
      "amount": 89.50
    },
    {
      "title": "Great Savings!",
      "description": "You saved \$150 more than your target this month",
      "suggestion": "Consider increasing your emergency fund contribution",
      "type": "success",
      "icon": "savings",
      "amount": 150.0
    },
    {
      "title": "Budget Optimization",
      "description": "Transportation costs are within budget",
      "suggestion": "You're doing great! Keep up the good spending habits",
      "type": "info",
      "icon": "check_circle",
      "amount": 0.0
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    await _loadAnalyticsData();
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    _loadAnalyticsData();
  }

  void _exportReport() {
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
            Text(
              'Export Report',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: const Text('Export as PDF'),
              subtitle: const Text('Detailed report with charts'),
              onTap: () {
                Navigator.pop(context);
                // Handle PDF export
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: const Text('Export as CSV'),
              subtitle: const Text('Raw data for analysis'),
              onTap: () {
                Navigator.pop(context);
                // Handle CSV export
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share via Email'),
              subtitle: const Text('Send report to email'),
              onTap: () {
                Navigator.pop(context);
                // Handle email sharing
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/add-expense');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/expense-list');
        break;
      case 3:
        // Current screen - Reports and Analytics
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/budget-management');
        break;
      case 5:
        Navigator.pushReplacementNamed(context, '/profile-and-settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Reports & Analytics',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          if (_isOffline)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'wifi_off',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Offline',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            onPressed: _exportReport,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimePeriodSelectorWidget(
                      selectedPeriod: _selectedPeriod,
                      onPeriodChanged: _onPeriodChanged,
                    ),
                    SizedBox(height: 3.h),
                    SpendingTrendsChartWidget(
                      data: _mockSpendingData,
                      period: _selectedPeriod,
                    ),
                    SizedBox(height: 3.h),
                    CategoryBreakdownChartWidget(
                      data: _mockCategoryData,
                    ),
                    SizedBox(height: 3.h),
                    MonthlyComparisonChartWidget(
                      data: _mockMonthlyData,
                    ),
                    SizedBox(height: 3.h),
                    TopMerchantsWidget(
                      data: _mockMerchantsData,
                    ),
                    SizedBox(height: 3.h),
                    InsightsCardWidget(
                      data: _mockInsightsData,
                    ),
                    SizedBox(height: 10.h), // Bottom padding for navigation
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
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
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
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
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'list',
              color: _currentIndex == 2
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: _currentIndex == 3
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: _currentIndex == 4
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 5
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Time period selector skeleton
          Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 3.h),
          // Chart skeletons
          ...List.generate(
              4,
              (index) => Column(
                    children: [
                      Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  )),
        ],
      ),
    );
  }
}
