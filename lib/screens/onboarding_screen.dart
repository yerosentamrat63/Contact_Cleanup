import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/app_background.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_icons.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const OnboardingScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Contact Cleaner',
                                  style: AppTypography.appName(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'HOW IT WORKS',
                                style: AppTypography.smallLabel(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Illustration container (216 tall)
                          SizedBox(
                            height: 200,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                // Back card
                                Positioned(
                                  left: 60,
                                  top: 10,
                                  child: Transform.rotate(
                                    angle: -8 * 3.14159 / 180,
                                    child: Container(
                                      width: 168,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: AppColors.onboardingBackCard,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: AppColors.onboardingBackBorder,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Front card
                                Positioned(
                                  left: 100,
                                  top: 4,
                                  child: Transform.rotate(
                                    angle: 6 * 3.14159 / 180,
                                    child: Container(
                                      width: 168,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: AppColors.floralWhite,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: AppColors.cardBorder,
                                          width: 1,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(17, 18, 13, 0.16),
                                            blurRadius: 30,
                                            offset: Offset(0, 14),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: const BoxDecoration(
                                              color: AppColors.oliveDrab,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'A',
                                              style: AppTypography.avatarInitial(
                                                fontSize: 28,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: 90,
                                            height: 9,
                                            decoration: BoxDecoration(
                                              color: AppColors.smokyBlack,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                          Container(
                                            width: 66,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              color: AppColors.progressTrack,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            width: 78,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              color: AppColors.progressTrack,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Left chip: Keep
                                Positioned(
                                  left: 0,
                                  top: 60,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: AppColors.floralWhite,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.controlBorder,
                                            width: 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const ArrowLeftIcon(
                                          size: 26,
                                          color: AppColors.sageInk,
                                          strokeWidth: 2.4,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'KEEP',
                                        style: AppTypography.smallLabel(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right chip: Delete
                                Positioned(
                                  right: 0,
                                  top: 60,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: AppColors.floralWhite,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.controlBorder,
                                            width: 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const ArrowRightIcon(
                                          size: 26,
                                          color: AppColors.terracotta,
                                          strokeWidth: 2.4,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'DELETE',
                                        style: AppTypography.smallLabel(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Headline
                          Text(
                            'Clean your contacts,\none swipe at a time.',
                            style: AppTypography.onboardingHeadline(),
                          ),

                          const SizedBox(height: 16),

                          // Steps list
                          _buildStep(
                            number: '01',
                            title: 'Swipe through them',
                            description: 'Right to delete, left to keep.',
                            isFirst: true,
                          ),
                          _buildStep(
                            number: '02',
                            title: 'Review your picks',
                            description: 'Untick anything you changed your mind on.',
                          ),
                          _buildStep(
                            number: '03',
                            title: 'Delete them all',
                            description: 'One confirmation, then they are gone.',
                            isLast: true,
                          ),

                          const Spacer(),
                          const SizedBox(height: 16),

                          // Primary button
                          PrimaryButton(
                            label: 'Get started',
                            onTap: onGetStarted,
                          ),

                          const SizedBox(height: 12),

                          // Footnote
                          Center(
                            child: Text(
                              'NEEDS ACCESS TO YOUR CONTACTS',
                              style: AppTypography.smallLabel(
                                color: AppColors.oliveDrab,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: const BorderSide(color: AppColors.controlBorder, width: 1.0),
          bottom: isLast
              ? const BorderSide(color: AppColors.controlBorder, width: 1.0)
              : BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Text(number, style: AppTypography.stepNumber()),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.rowName()),
                const SizedBox(height: 2),
                Text(description, style: AppTypography.stepDescription()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
