import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddBudgetModalWidget extends StatefulWidget {
  final Map<String, dynamic>? budget;
  final Function(Map<String, dynamic>) onBudgetAdded;

  const AddBudgetModalWidget({
    super.key,
    this.budget,
    required this.onBudgetAdded,
  });

  @override
  State<AddBudgetModalWidget> createState() => _AddBudgetModalWidgetState();
}

class _AddBudgetModalWidgetState extends State<AddBudgetModalWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

  String _selectedCategory = "";
  String _selectedIcon = "";
  int _selectedColor = 0xFF4CAF50;
  String _selectedPeriod = "Monthly";
  bool _isCustomCategory = false;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Food & Dining", "icon": "restaurant", "color": 0xFF4CAF50},
    {"name": "Transportation", "icon": "directions_car", "color": 0xFF2196F3},
    {"name": "Entertainment", "icon": "movie", "color": 0xFF9C27B0},
    {"name": "Utilities", "icon": "electrical_services", "color": 0xFFFF9800},
    {"name": "Shopping", "icon": "shopping_bag", "color": 0xFFE91E63},
    {"name": "Healthcare", "icon": "local_hospital", "color": 0xFFF44336},
    {"name": "Education", "icon": "school", "color": 0xFF3F51B5},
    {"name": "Travel", "icon": "flight", "color": 0xFF00BCD4},
  ];

  final List<String> _periods = ["Weekly", "Monthly", "Yearly"];

  final List<Map<String, dynamic>> _suggestions = [
    {
      "category": "Food & Dining",
      "amount": 600.0,
      "reason": "Based on last 3 months average"
    },
    {
      "category": "Transportation",
      "amount": 300.0,
      "reason": "Similar to previous spending"
    },
    {
      "category": "Entertainment",
      "amount": 200.0,
      "reason": "Recommended for balanced budget"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    if (widget.budget != null) {
      _selectedCategory = widget.budget!["category"];
      _selectedIcon = widget.budget!["icon"];
      _selectedColor = widget.budget!["color"];
      _amountController.text = widget.budget!["limit"].toString();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryTab(),
                _buildAmountTab(),
                _buildSummaryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              widget.budget != null ? "Edit Budget" : "Add New Budget",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        tabs: const [
          Tab(text: "Category"),
          Tab(text: "Amount"),
          Tab(text: "Summary"),
        ],
      ),
    );
  }

  Widget _buildCategoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Category",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 3.5,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category["name"];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category["name"];
                    _selectedIcon = category["icon"];
                    _selectedColor = category["color"];
                    _isCustomCategory = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:
                              Color(category["color"]).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: category["icon"],
                          color: Color(category["color"]),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          category["name"],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 3.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isCustomCategory = true;
                _selectedCategory = "";
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: _isCustomCategory
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isCustomCategory
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: _isCustomCategory ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    "Custom Category",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isCustomCategory) ...[
            SizedBox(height: 3.h),
            TextField(
              controller: _customCategoryController,
              decoration: InputDecoration(
                labelText: "Category Name",
                hintText: "Enter custom category name",
              ),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
          ],
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _selectedCategory.isNotEmpty
                    ? () => _tabController.animateTo(1)
                    : null,
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Set Budget Amount",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: "Amount",
              hintText: "Enter budget amount",
              prefixText: "\$ ",
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "Time Period",
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: _periods.map((period) {
              final isSelected = _selectedPeriod == period;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        right: period != _periods.last ? 2.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      period,
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 4.h),
          Text(
            "Smart Suggestions",
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _suggestions[index];
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion["category"],
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            suggestion["reason"],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _amountController.text =
                              suggestion["amount"].toString();
                        });
                      },
                      child: Text(
                        "\$${suggestion["amount"].toStringAsFixed(0)}",
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => _tabController.animateTo(0),
                child: Text("Back"),
              ),
              ElevatedButton(
                onPressed: _amountController.text.isNotEmpty
                    ? () => _tabController.animateTo(2)
                    : null,
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Budget Summary",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Color(_selectedColor).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: _selectedIcon.isNotEmpty
                            ? _selectedIcon
                            : 'category',
                        color: Color(_selectedColor),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCategory,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            _selectedPeriod,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\$${amount.toStringAsFixed(2)}",
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow("Daily Limit",
                          "\$${(amount / 30).toStringAsFixed(2)}"),
                      SizedBox(height: 1.h),
                      _buildSummaryRow("Weekly Limit",
                          "\$${(amount / 4).toStringAsFixed(2)}"),
                      SizedBox(height: 1.h),
                      _buildSummaryRow(
                          "Monthly Limit", "\$${amount.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    "You'll receive notifications when you reach 80% and 100% of your budget limit.",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => _tabController.animateTo(1),
                child: Text("Back"),
              ),
              ElevatedButton(
                onPressed: _createBudget,
                child: Text(
                    widget.budget != null ? "Update Budget" : "Create Budget"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _createBudget() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (_selectedCategory.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill in all required fields",
            style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    final budget = {
      "id": widget.budget?["id"] ?? DateTime.now().millisecondsSinceEpoch,
      "category": _selectedCategory,
      "icon": _selectedIcon.isNotEmpty ? _selectedIcon : 'category',
      "spent": widget.budget?["spent"] ?? 0.0,
      "limit": amount,
      "remainingDays": 30,
      "color": _selectedColor,
      "transactions": widget.budget?["transactions"] ?? [],
    };

    widget.onBudgetAdded(budget);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.budget != null
              ? "Budget updated successfully"
              : "Budget created successfully",
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }
}
