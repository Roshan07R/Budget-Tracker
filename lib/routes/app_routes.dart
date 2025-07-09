import 'package:flutter/material.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/profile_and_settings/profile_and_settings.dart';
import '../presentation/add_expense/add_expense.dart';
import '../presentation/expense_list/expense_list.dart';
import '../presentation/budget_management/budget_management.dart';
import '../presentation/reports_and_analytics/reports_and_analytics.dart';
import '../presentation/about_screen/about_screen.dart';
import '../presentation/side_menu/side_menu.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String dashboard = '/dashboard';
  static const String profileAndSettings = '/profile-and-settings';
  static const String addExpense = '/add-expense';
  static const String expenseList = '/expense-list';
  static const String budgetManagement = '/budget-management';
  static const String reportsAndAnalytics = '/reports-and-analytics';
  static const String aboutScreen = '/about-screen';
  static const String sideMenu = '/side-menu';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => Dashboard(),
    dashboard: (context) => Dashboard(),
    profileAndSettings: (context) => ProfileAndSettings(),
    addExpense: (context) => AddExpense(),
    expenseList: (context) => ExpenseList(),
    budgetManagement: (context) => BudgetManagement(),
    reportsAndAnalytics: (context) => ReportsAndAnalytics(),
    aboutScreen: (context) => const AboutScreen(),
    sideMenu: (context) => const SideMenu(),
    // TODO: Add your other routes here
  };
}
