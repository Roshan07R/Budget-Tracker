import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/linked_account_widget.dart';
import './widgets/notification_toggle_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';

class ProfileAndSettings extends StatefulWidget {
  const ProfileAndSettings({super.key});

  @override
  State<ProfileAndSettings> createState() => _ProfileAndSettingsState();
}

class _ProfileAndSettingsState extends State<ProfileAndSettings> {
  int _currentIndex = 4; // Profile tab is active

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Roshni Sahu",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "accountTier": "Premium",
    "memberSince": "January 2023"
  };

  // Mock linked accounts data
  final List<Map<String, dynamic>> linkedAccounts = [
    {
      "id": 1,
      "bankName": "Chase Bank",
      "accountType": "Checking",
      "logo":
          "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isConnected": true,
      "lastSync": "2 hours ago"
    },
    {
      "id": 2,
      "bankName": "Wells Fargo",
      "accountType": "Savings",
      "logo":
          "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isConnected": true,
      "lastSync": "1 day ago"
    },
    {
      "id": 3,
      "bankName": "Bank of America",
      "accountType": "Credit Card",
      "logo":
          "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isConnected": false,
      "lastSync": "Disconnected"
    }
  ];

  // Notification settings
  bool budgetAlerts = true;
  bool expenseReminders = true;
  bool weeklySummaries = false;
  bool biometricAuth = true;
  bool dataSharing = false;
  bool analyticsOptOut = true;

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
        Navigator.pushReplacementNamed(context, '/budget-management');
        break;
      case 4:
        // Already on profile screen
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to logout? This will clear your session data.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Perform logout logic here
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
          content: Text(
            'This action cannot be undone. All your data will be permanently deleted.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Perform account deletion logic here
              },
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userData: userData,
              onEditPressed: () {
                // Navigate to edit profile
              },
            ),

            SizedBox(height: 3.h),

            // Account Section
            SettingsSectionWidget(
              title: 'Account',
              items: [
                {
                  'icon': 'person',
                  'title': 'Personal Information',
                  'subtitle': 'Name, email, phone number',
                  'onTap': () {},
                },
                {
                  'icon': 'account_balance',
                  'title': 'Linked Bank Accounts',
                  'subtitle':
                      '\${linkedAccounts.where((account) => (account["isConnected"] as bool)).length} connected',
                  'onTap': () {},
                },
                {
                  'icon': 'payment',
                  'title': 'Payment Methods',
                  'subtitle': 'Manage cards and payment options',
                  'onTap': () {},
                },
                {
                  'icon': 'star',
                  'title': 'Subscription Status',
                  'subtitle': userData["accountTier"] as String,
                  'onTap': () {},
                },
              ],
            ),

            SizedBox(height: 2.h),

            // Linked Accounts Detail
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Linked Accounts',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  ...linkedAccounts.map((dynamic account) {
                    final accountMap = account as Map<String, dynamic>;
                    return LinkedAccountWidget(
                      account: accountMap,
                      onTap: () {
                        // Handle account management
                      },
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // App Preferences Section
            SettingsSectionWidget(
              title: 'App Preferences',
              items: [
                {
                  'icon': 'attach_money',
                  'title': 'Default Currency',
                  'subtitle': 'USD (\$)',
                  'onTap': () {},
                },
                {
                  'icon': 'sync',
                  'title': 'Data Sync Frequency',
                  'subtitle': 'Every 15 minutes',
                  'onTap': () {},
                },
              ],
            ),

            SizedBox(height: 2.h),

            // Notification Settings
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  NotificationToggleWidget(
                    title: 'Budget Alerts',
                    subtitle: 'Get notified when approaching budget limits',
                    value: budgetAlerts,
                    onChanged: (value) {
                      setState(() {
                        budgetAlerts = value;
                      });
                    },
                  ),
                  NotificationToggleWidget(
                    title: 'Expense Reminders',
                    subtitle: 'Daily reminders to log expenses',
                    value: expenseReminders,
                    onChanged: (value) {
                      setState(() {
                        expenseReminders = value;
                      });
                    },
                  ),
                  NotificationToggleWidget(
                    title: 'Weekly Summaries',
                    subtitle: 'Weekly spending summary reports',
                    value: weeklySummaries,
                    onChanged: (value) {
                      setState(() {
                        weeklySummaries = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Security Section
            SettingsSectionWidget(
              title: 'Security',
              items: [
                {
                  'icon': 'lock',
                  'title': 'Change Password',
                  'subtitle': 'Update your account password',
                  'onTap': () {},
                },
                {
                  'icon': 'security',
                  'title': 'Two-Factor Authentication',
                  'subtitle': 'Add extra security to your account',
                  'onTap': () {},
                },
                {
                  'icon': 'devices',
                  'title': 'Active Sessions',
                  'subtitle': 'Manage logged-in devices',
                  'onTap': () {},
                },
              ],
            ),

            SizedBox(height: 2.h),

            // Biometric Authentication Toggle
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: NotificationToggleWidget(
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID to unlock',
                value: biometricAuth,
                onChanged: (value) {
                  setState(() {
                    biometricAuth = value;
                  });
                },
              ),
            ),

            SizedBox(height: 3.h),

            // Privacy Section
            SettingsSectionWidget(
              title: 'Privacy',
              items: [
                {
                  'icon': 'download',
                  'title': 'Export Data',
                  'subtitle': 'Download your financial data',
                  'onTap': () {},
                },
              ],
            ),

            SizedBox(height: 2.h),

            // Privacy Controls
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationToggleWidget(
                    title: 'Data Sharing',
                    subtitle: 'Share anonymous usage data',
                    value: dataSharing,
                    onChanged: (value) {
                      setState(() {
                        dataSharing = value;
                      });
                    },
                  ),
                  NotificationToggleWidget(
                    title: 'Analytics Opt-out',
                    subtitle: 'Disable analytics tracking',
                    value: analyticsOptOut,
                    onChanged: (value) {
                      setState(() {
                        analyticsOptOut = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Support Section
            SettingsSectionWidget(
              title: 'Support',
              items: [
                {
                  'icon': 'help',
                  'title': 'Help Center',
                  'subtitle': 'Browse help articles and guides',
                  'onTap': () {},
                },
                {
                  'icon': 'contact_support',
                  'title': 'Contact Support',
                  'subtitle': 'Get help from our support team',
                  'onTap': () {},
                },
                {
                  'icon': 'quiz',
                  'title': 'FAQ',
                  'subtitle': 'Frequently asked questions',
                  'onTap': () {},
                },
                {
                  'icon': 'info',
                  'title': 'App Version',
                  'subtitle': 'v2.1.0 - Update available',
                  'onTap': () {},
                },
              ],
            ),

            SizedBox(height: 4.h),

            // Danger Zone
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danger Zone',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CustomIconWidget(
                      iconName: 'logout',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 24,
                    ),
                    title: Text(
                      'Logout',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                    subtitle: Text(
                      'Sign out of your account',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: _showLogoutDialog,
                  ),
                  Divider(
                    color: AppTheme.lightTheme.dividerColor,
                    height: 1,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CustomIconWidget(
                      iconName: 'delete_forever',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 24,
                    ),
                    title: Text(
                      'Delete Account',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                    subtitle: Text(
                      'Permanently delete your account and data',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: _showDeleteAccountDialog,
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),
          ],
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
              iconName: 'add',
              color: _currentIndex == 1
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Add Expense',
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
              iconName: 'account_balance_wallet',
              color: _currentIndex == 3
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
              color: _currentIndex == 4
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
}
