import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/amount_input_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/merchant_input_widget.dart';
import './widgets/notes_input_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/receipt_capture_widget.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = '';
  String? _receiptImagePath;
  bool _isRecurring = false;
  bool _isTaxDeductible = false;
  bool _showAdvancedOptions = false;
  bool _isLoading = false;

  // Mock data for categories
  final List<Map<String, dynamic>> _categories = [
    {"id": "food", "name": "Food", "icon": "restaurant", "color": 0xFFFF6B35},
    {
      "id": "transport",
      "name": "Transport",
      "icon": "directions_car",
      "color": 0xFF2E7D32
    },
    {
      "id": "shopping",
      "name": "Shopping",
      "icon": "shopping_bag",
      "color": 0xFF1B365D
    },
    {
      "id": "entertainment",
      "name": "Entertainment",
      "icon": "movie",
      "color": 0xFFF57C00
    },
    {
      "id": "health",
      "name": "Health",
      "icon": "local_hospital",
      "color": 0xFFD32F2F
    },
    {
      "id": "utilities",
      "name": "Utilities",
      "icon": "electrical_services",
      "color": 0xFF388E3C
    },
    {
      "id": "education",
      "name": "Education",
      "icon": "school",
      "color": 0xFF4A90E2
    },
    {"id": "other", "name": "Other", "icon": "category", "color": 0xFF6B7280},
  ];

  // Mock data for payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {"id": "cash", "name": "Cash", "icon": "payments", "lastUsed": true},
    {
      "id": "card1",
      "name": "Visa ****1234",
      "icon": "credit_card",
      "lastUsed": false
    },
    {
      "id": "card2",
      "name": "Master ****5678",
      "icon": "credit_card",
      "lastUsed": false
    },
    {
      "id": "digital",
      "name": "Digital Wallet",
      "icon": "account_balance_wallet",
      "lastUsed": false
    },
  ];

  // Mock merchant suggestions
  final List<String> _merchantSuggestions = [
    "Starbucks",
    "McDonald's",
    "Walmart",
    "Target",
    "Amazon",
    "Shell Gas Station",
    "CVS Pharmacy",
    "Uber",
    "Netflix",
    "Spotify"
  ];

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = (_paymentMethods.firstWhere(
      (method) => (method["lastUsed"] as bool) == true,
      orElse: () => _paymentMethods.first,
    ))["id"] as String;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory.isEmpty) {
      _showErrorSnackBar('Please select a category');
      return;
    }

    if (_amountController.text.isEmpty) {
      _showErrorSnackBar('Please enter an amount');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Expense saved successfully!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );

    // Navigate back to dashboard
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        title: Text(
          'Add Expense',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveExpense,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    'Save',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input Section
              AmountInputWidget(
                controller: _amountController,
                onChanged: (value) => setState(() {}),
              ),

              SizedBox(height: 3.h),

              // Merchant Input Section
              MerchantInputWidget(
                controller: _merchantController,
                suggestions: _merchantSuggestions,
              ),

              SizedBox(height: 3.h),

              // Category Selection Section
              CategorySelectionWidget(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (categoryId) {
                  setState(() {
                    _selectedCategory = categoryId;
                  });
                  HapticFeedback.lightImpact();
                },
              ),

              SizedBox(height: 3.h),

              // Date Picker Section
              DatePickerWidget(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),

              SizedBox(height: 3.h),

              // Payment Method Section
              PaymentMethodWidget(
                paymentMethods: _paymentMethods,
                selectedMethod: _selectedPaymentMethod,
                onMethodSelected: (methodId) {
                  setState(() {
                    _selectedPaymentMethod = methodId;
                  });
                  HapticFeedback.lightImpact();
                },
              ),

              SizedBox(height: 3.h),

              // Receipt Capture Section
              ReceiptCaptureWidget(
                imagePath: _receiptImagePath,
                onImageCaptured: (imagePath) {
                  setState(() {
                    _receiptImagePath = imagePath;
                  });
                },
                onImageRemoved: () {
                  setState(() {
                    _receiptImagePath = null;
                  });
                },
              ),

              SizedBox(height: 3.h),

              // Notes Input Section
              NotesInputWidget(
                controller: _notesController,
              ),

              SizedBox(height: 3.h),

              // Advanced Options Section
              AdvancedOptionsWidget(
                isExpanded: _showAdvancedOptions,
                isRecurring: _isRecurring,
                isTaxDeductible: _isTaxDeductible,
                onExpandToggle: () {
                  setState(() {
                    _showAdvancedOptions = !_showAdvancedOptions;
                  });
                },
                onRecurringToggle: (value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
                onTaxDeductibleToggle: (value) {
                  setState(() {
                    _isTaxDeductible = value;
                  });
                },
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
