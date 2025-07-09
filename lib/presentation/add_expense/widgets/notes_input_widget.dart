import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NotesInputWidget extends StatefulWidget {
  final TextEditingController controller;

  const NotesInputWidget({
    super.key,
    required this.controller,
  });

  @override
  State<NotesInputWidget> createState() => _NotesInputWidgetState();
}

class _NotesInputWidgetState extends State<NotesInputWidget> {
  static const int maxLength = 200;

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentLength = widget.controller.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          maxLines: 4,
          maxLength: maxLength,
          style: AppTheme.lightTheme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Add notes about this expense...',
            counterText: '',
            alignLabelWithHint: true,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add context to help categorize future expenses',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$currentLength/$maxLength',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: currentLength > maxLength * 0.8
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
