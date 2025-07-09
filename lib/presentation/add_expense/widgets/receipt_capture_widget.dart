import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReceiptCaptureWidget extends StatelessWidget {
  final String? imagePath;
  final ValueChanged<String>? onImageCaptured;
  final VoidCallback? onImageRemoved;

  const ReceiptCaptureWidget({
    super.key,
    this.imagePath,
    this.onImageCaptured,
    this.onImageRemoved,
  });

  void _captureReceipt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
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
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Add Receipt',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildCaptureOption(
                    context,
                    'Camera',
                    'camera_alt',
                    () {
                      Navigator.pop(context);
                      // Simulate camera capture
                      onImageCaptured?.call('mock_receipt_camera.jpg');
                    },
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildCaptureOption(
                    context,
                    'Gallery',
                    'photo_library',
                    () {
                      Navigator.pop(context);
                      // Simulate gallery selection
                      onImageCaptured?.call('mock_receipt_gallery.jpg');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureOption(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receipt (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        imagePath != null
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'receipt',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Receipt captured',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            imagePath!,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _captureReceipt(context),
                          icon: CustomIconWidget(
                            iconName: 'edit',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: onImageRemoved,
                          icon: CustomIconWidget(
                            iconName: 'delete',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () => _captureReceipt(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'camera_alt',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Capture receipt',
                          style: AppTheme.lightTheme.textTheme.bodyLarge,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_right',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
