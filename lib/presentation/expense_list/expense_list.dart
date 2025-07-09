import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/date_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/expense_card_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_dropdown_widget.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  int _currentIndex = 2; // Expenses tab active
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isSelectionMode = false;
  String _sortBy = 'Date (Newest)';
  String _searchQuery = '';
  final List<String> _selectedExpenseIds = [];
  final List<String> _recentSearches = ['Coffee', 'Groceries', 'Gas'];

  // Mock data for expenses grouped by date
  final Map<String, List<Map<String, dynamic>>> _groupedExpenses = {
    'Today': [
      {
        'id': '1',
        'merchant': 'Starbucks Coffee',
        'amount': '-\$4.85',
        'category': 'Food & Dining',
        'categoryIcon': 'restaurant',
        'paymentMethod': 'Credit Card',
        'hasReceipt': true,
        'time': '2:30 PM',
        'isFavorite': false,
      },
      {
        'id': '2',
        'merchant': 'Shell Gas Station',
        'amount': '-\$45.20',
        'category': 'Transportation',
        'categoryIcon': 'local_gas_station',
        'paymentMethod': 'Debit Card',
        'hasReceipt': false,
        'time': '10:15 AM',
        'isFavorite': true,
      },
    ],
    'Yesterday': [
      {
        'id': '3',
        'merchant': 'Whole Foods Market',
        'amount': '-\$87.34',
        'category': 'Groceries',
        'categoryIcon': 'shopping_cart',
        'paymentMethod': 'Credit Card',
        'hasReceipt': true,
        'time': '6:45 PM',
        'isFavorite': false,
      },
      {
        'id': '4',
        'merchant': 'Netflix Subscription',
        'amount': '-\$15.99',
        'category': 'Entertainment',
        'categoryIcon': 'movie',
        'paymentMethod': 'Auto-pay',
        'hasReceipt': false,
        'time': '12:00 PM',
        'isFavorite': false,
      },
    ],
    'Dec 15, 2024': [
      {
        'id': '5',
        'merchant': 'Amazon Purchase',
        'amount': '-\$129.99',
        'category': 'Shopping',
        'categoryIcon': 'shopping_bag',
        'paymentMethod': 'Credit Card',
        'hasReceipt': true,
        'time': '3:22 PM',
        'isFavorite': false,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreExpenses();
    }
  }

  void _loadMoreExpenses() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh data
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        onApplyFilters: (filters) {
          // Apply filters logic
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onSortChanged(String sortOption) {
    setState(() {
      _sortBy = sortOption;
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedExpenseIds.clear();
      }
    });
  }

  void _onExpenseSelected(String expenseId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedExpenseIds.add(expenseId);
      } else {
        _selectedExpenseIds.remove(expenseId);
      }
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/add-expense');
        break;
      case 2:
        // Current screen
        break;
      case 3:
        Navigator.pushNamed(context, '/budget-management');
        break;
      case 4:
        Navigator.pushNamed(context, '/reports-and-analytics');
        break;
      case 5:
        Navigator.pushNamed(context, '/profile-and-settings');
        break;
    }
  }

  Map<String, List<Map<String, dynamic>>> _getFilteredExpenses() {
    if (_searchQuery.isEmpty) return _groupedExpenses;

    Map<String, List<Map<String, dynamic>>> filtered = {};

    _groupedExpenses.forEach((date, expenses) {
      List<Map<String, dynamic>> filteredExpenses = expenses
          .where((expense) =>
              (expense['merchant'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (expense['category'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();

      if (filteredExpenses.isNotEmpty) {
        filtered[date] = filteredExpenses;
      }
    });

    return filtered;
  }

  double _getDailyTotal(List<Map<String, dynamic>> expenses) {
    return expenses.fold(0.0, (sum, expense) {
      String amountStr =
          (expense['amount'] as String).replaceAll(RegExp(r'[^\d.]'), '');
      return sum + double.parse(amountStr);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _getFilteredExpenses();
    final isEmpty = filteredExpenses.isEmpty;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: isEmpty ? _buildEmptyState() : _buildExpenseList(filteredExpenses),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      title: _isSearching
          ? SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                _searchController.clear();
                _onSearchChanged('');
              },
              recentSearches: _recentSearches,
            )
          : Text(
              'Expenses',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
      actions: [
        if (!_isSearching) ...[
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showFilterModal,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ] else ...[
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        if (_isSelectionMode) ...[
          IconButton(
            onPressed: _toggleSelectionMode,
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExpenseList(Map<String, List<Map<String, dynamic>>> expenses) {
    return Column(
      children: [
        if (!_isSearching) _buildSortDropdown(),
        if (_isSelectionMode) _buildSelectionToolbar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount: expenses.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == expenses.length) {
                  return _buildLoadingIndicator();
                }

                final date = expenses.keys.elementAt(index);
                final dayExpenses = expenses[date]!;
                final dailyTotal = _getDailyTotal(dayExpenses);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateHeaderWidget(
                      date: date,
                      total: dailyTotal,
                    ),
                    SizedBox(height: 1.h),
                    ...dayExpenses.map((expense) => Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: ExpenseCardWidget(
                            expense: expense,
                            isSelected:
                                _selectedExpenseIds.contains(expense['id']),
                            isSelectionMode: _isSelectionMode,
                            onTap: () {
                              if (_isSelectionMode) {
                                _onExpenseSelected(
                                  expense['id'] as String,
                                  !_selectedExpenseIds.contains(expense['id']),
                                );
                              }
                            },
                            onLongPress: () {
                              if (!_isSelectionMode) {
                                _toggleSelectionMode();
                                _onExpenseSelected(
                                    expense['id'] as String, true);
                              }
                            },
                            onEdit: () {
                              // Navigate to edit expense
                            },
                            onDuplicate: () {
                              // Duplicate expense logic
                            },
                            onShare: () {
                              // Share expense logic
                            },
                            onDelete: () {
                              // Delete expense logic
                            },
                            searchQuery: _searchQuery,
                          ),
                        )),
                    SizedBox(height: 2.h),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Transactions',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SortDropdownWidget(
            currentSort: _sortBy,
            onSortChanged: _onSortChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${_selectedExpenseIds.length} selected',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _selectedExpenseIds.isNotEmpty
                ? () {
                    // Delete selected expenses
                  }
                : null,
            icon: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
            label: Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          TextButton.icon(
            onPressed: _selectedExpenseIds.isNotEmpty
                ? () {
                    // Export selected expenses
                  }
                : null,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            label: Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      onAddExpense: () {
        Navigator.pushNamed(context, '/add-expense');
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'receipt_long',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: _currentIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: _currentIndex == 4
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentIndex == 5
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
