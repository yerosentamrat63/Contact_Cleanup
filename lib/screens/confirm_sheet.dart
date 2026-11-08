import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/app_buttons.dart';

class ConfirmDeletionSheet extends StatelessWidget {
  final int count;
  final VoidCallback onCancel;
  final VoidCallback onConfirmDelete;

  const ConfirmDeletionSheet({
    super.key,
    required this.count,
    required this.onCancel,
    required this.onConfirmDelete,
  });

  static Future<bool?> show(
    BuildContext context, {
    required int count,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.scrimConfirm,
      isScrollControlled: true,
      builder: (context) => ConfirmDeletionSheet(
        count: count,
        onCancel: () => Navigator.of(context).pop(false),
        onConfirmDelete: () => Navigator.of(context).pop(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactWord = count == 1 ? 'contact' : 'contacts';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.floralWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Delete $count $contactWord?',
              style: AppTypography.confirmSheetTitle(),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Mono caption
            Text(
              'THIS CANNOT BE UNDONE',
              style: AppTypography.smallLabel(
                color: AppColors.oliveDrab,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Two equal 56 tall buttons 12 apart: Cancel (outline) and Delete (terracotta)
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    label: 'Cancel',
                    onTap: onCancel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Delete',
                    backgroundColor: AppColors.terracotta,
                    onTap: onConfirmDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

