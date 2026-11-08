import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/app_background.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_icons.dart';

class PermissionScreen extends StatelessWidget {
  final VoidCallback onAllowAccess;

  const PermissionScreen({super.key, required this.onAllowAccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // 112 olive circle with white padlock icon (52)
                Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    color: AppColors.oliveDrab,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const LockIcon(
                    size: 52,
                    color: AppColors.floralWhite,
                    strokeWidth: 1.8,
                  ),
                ),

                const SizedBox(height: 32),

                // Title: Contacts access needed
                Text(
                  'Contacts access needed',
                  style: AppTypography.permissionHeadline(),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Paragraph
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 290),
                  child: Text(
                    'To show and delete your contacts, the app needs permission to read and edit them.',
                    style: AppTypography.permissionParagraph(),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(flex: 3),

                // Primary button: Allow access
                PrimaryButton(
                  label: 'Allow access',
                  onTap: onAllowAccess,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

