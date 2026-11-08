import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/app_background.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_icons.dart';

class DoneScreen extends StatelessWidget {
  final int deletedCount;
  final int keptCount;
  final VoidCallback onStartOver;

  const DoneScreen({
    super.key,
    required this.deletedCount,
    required this.keptCount,
    required this.onStartOver,
  });

  @override
  Widget build(BuildContext context) {
    final title = deletedCount == 0
        ? 'Nothing deleted'
        : 'Deleted $deletedCount ${deletedCount == 1 ? "contact" : "contacts"}';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // 112 sage-tint circle with sage check (52)
                Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    color: AppColors.sageTint,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const CheckIcon(
                    size: 52,
                    color: AppColors.sageInk,
                    strokeWidth: 2.2,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  title,
                  style: AppTypography.screenTitle(),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Caption
                Text(
                  'YOUR CONTACT LIST IS CLEANER NOW',
                  style: AppTypography.screenCaption(),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 36),

                // Two stat cards (12 apart, Floral White, radius 16, padding 16/28)
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        number: '$deletedCount',
                        label: 'DELETED',
                        numberColor: AppColors.terracotta,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        number: '$keptCount',
                        label: 'KEPT',
                        numberColor: AppColors.sageInk,
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 3),

                // Full-width olive button: Start over
                PrimaryButton(
                  label: 'Start over',
                  onTap: onStartOver,
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String number,
    required String label,
    required Color numberColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.floralWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 18, 13, 0.08),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: AppTypography.doneStatNumber(color: numberColor),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.smallLabel(
              color: AppColors.oliveDrab,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

