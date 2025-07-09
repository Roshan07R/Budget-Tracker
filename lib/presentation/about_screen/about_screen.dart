import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_logo_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(colorScheme, textTheme),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5.h),
                  _buildAppLogo(),
                  SizedBox(height: 5.h),
                  _buildVersionInfo(textTheme, colorScheme),
                  SizedBox(height: 3.h),
                  _buildCreditLine(textTheme, colorScheme),
                  SizedBox(height: 6.h),
                  _buildAppDescription(textTheme, colorScheme),
                  SizedBox(height: 4.h),
                  _buildAdditionalInfo(textTheme, colorScheme),
                  SizedBox(height: 6.h),
                  _buildFooter(textTheme, colorScheme),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      ColorScheme colorScheme, TextTheme textTheme) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: colorScheme.onSurface,
          size: 20,
        ),
      ),
      title: Text(
        'About',
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    );
  }

  Widget _buildAppLogo() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () {
          _animationController.reset();
          _animationController.forward();
        },
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const AppLogoWidget(
            size: 120,
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withAlpha(26),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: colorScheme.primary,
            size: 28,
          ),
          SizedBox(height: 1.h),
          Text(
            'Version 1.0.0',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Latest Release',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary.withAlpha(179),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditLine(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary.withAlpha(13),
            colorScheme.tertiary.withAlpha(13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.secondary.withAlpha(26),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Created with ',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            '❤️',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            ' by ',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Roshan',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDescription(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'description',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'About Budget Tracker',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Budget Tracker is a comprehensive financial management app designed to help you take control of your finances. Track expenses, manage budgets, analyze spending patterns, and achieve your financial goals with ease.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(204),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Key Features',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildFeatureItem(
            'account_balance_wallet',
            'Expense Tracking',
            'Monitor your daily expenses and categorize them',
            textTheme,
            colorScheme,
          ),
          _buildFeatureItem(
            'bar_chart',
            'Budget Management',
            'Set and track budgets for different categories',
            textTheme,
            colorScheme,
          ),
          _buildFeatureItem(
            'insights',
            'Analytics & Reports',
            'Gain insights into your spending patterns',
            textTheme,
            colorScheme,
          ),
          _buildFeatureItem(
            'savings',
            'Financial Goals',
            'Set and achieve your financial objectives',
            textTheme,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    String iconName,
    String title,
    String description,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
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
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        Divider(
          color: colorScheme.outline.withAlpha(77),
          thickness: 1,
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'copyright',
              color: colorScheme.onSurface.withAlpha(128),
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              '2024 Budget Tracker. All rights reserved.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withAlpha(128),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Last updated: December 2024',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withAlpha(128),
          ),
        ),
      ],
    );
  }
}
