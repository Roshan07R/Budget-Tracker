import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.black.withAlpha(128),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Row(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: _buildDrawer(theme, colorScheme, textTheme),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(
      ThemeData theme, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      width: 85.w,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(colorScheme, textTheme),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavigationSection(colorScheme, textTheme),
                  _buildDivider(colorScheme),
                  _buildSecondarySection(colorScheme, textTheme),
                ],
              ),
            ),
          ),
          _buildFooter(colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.fromLTRB(6.w, 12.h, 6.w, 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withAlpha(204),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'person',
                color: colorScheme.primary,
                size: 30,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Premium User',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const CustomIconWidget(
              iconName: 'close',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Navigation', textTheme, colorScheme),
        _buildMenuItem(
          'dashboard',
          'Dashboard',
          'Overview of your finances',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          },
        ),
        _buildMenuItem(
          'add_circle',
          'Add Transaction',
          'Record new expense or income',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, AppRoutes.addExpense);
          },
        ),
        _buildMenuItem(
          'bar_chart',
          'Reports',
          'View detailed analytics',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, AppRoutes.reportsAndAnalytics);
          },
        ),
        _buildMenuItem(
          'account_balance_wallet',
          'Accounts',
          'Manage your accounts',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, AppRoutes.expenseList);
          },
        ),
        _buildMenuItem(
          'savings',
          'Budget',
          'Track your budgets',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, AppRoutes.budgetManagement);
          },
        ),
      ],
    );
  }

  Widget _buildSecondarySection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('More Options', textTheme, colorScheme),
        _buildMenuItem(
          'track_changes',
          'Goals',
          'Set and track financial goals',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to goals screen
          },
        ),
        _buildMenuItem(
          'repeat',
          'Recurring',
          'Manage recurring transactions',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to recurring transactions screen
          },
        ),
        _buildMenuItem(
          'notifications',
          'Notifications',
          'Manage your notifications',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to notifications screen
          },
        ),
        _buildMenuItem(
          'settings',
          'Settings',
          'App preferences and configuration',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, AppRoutes.profileAndSettings);
          },
        ),
        _buildMenuItem(
          'help',
          'Help & Support',
          'Get help and support',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to help screen
          },
        ),
        _buildMenuItem(
          'info',
          'About',
          'App information and credits',
          colorScheme,
          textTheme,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, AppRoutes.aboutScreen);
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
      String title, TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 1.h),
      child: Text(
        title,
        style: textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurface.withAlpha(153),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String iconName,
    String title,
    String subtitle,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: colorScheme.onSurface.withAlpha(77),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      height: 1,
      color: colorScheme.outline.withAlpha(26),
    );
  }

  Widget _buildFooter(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.fromLTRB(6.w, 2.h, 6.w, 4.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withAlpha(26),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Budget Tracker',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Version 1.0.0',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha(153),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              _showLogoutDialog(colorScheme, textTheme);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'logout',
                  color: colorScheme.error,
                  size: 18,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Logout',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(ColorScheme colorScheme, TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withAlpha(179),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // TODO: Implement logout logic
            },
            child: Text(
              'Logout',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
