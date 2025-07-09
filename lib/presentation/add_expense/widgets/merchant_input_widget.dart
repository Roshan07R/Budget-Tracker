import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MerchantInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<String> suggestions;

  const MerchantInputWidget({
    super.key,
    required this.controller,
    required this.suggestions,
  });

  @override
  State<MerchantInputWidget> createState() => _MerchantInputWidgetState();
}

class _MerchantInputWidgetState extends State<MerchantInputWidget> {
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        _filteredSuggestions = widget.suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(query))
            .take(5)
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
        _filteredSuggestions = [];
      });
    }
  }

  void _selectSuggestion(String suggestion) {
    widget.controller.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merchant',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: _showSuggestions
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: widget.controller,
                style: AppTheme.lightTheme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter merchant name',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'store',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: widget.controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            widget.controller.clear();
                            setState(() {
                              _showSuggestions = false;
                            });
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : null,
                ),
              ),
              if (_showSuggestions)
                Container(
                  constraints: BoxConstraints(maxHeight: 25.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8.0),
                    ),
                    border: Border.all(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1.0,
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _filteredSuggestions.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: AppTheme.lightTheme.dividerColor,
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = _filteredSuggestions[index];
                      return ListTile(
                        dense: true,
                        leading: CustomIconWidget(
                          iconName: 'history',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        title: Text(
                          suggestion,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        onTap: () => _selectSuggestion(suggestion),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
