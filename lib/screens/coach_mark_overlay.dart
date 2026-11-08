import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_icons.dart';

class CoachMarkOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const CoachMarkOverlay({super.key, required this.onDismiss});

  @override
  State<CoachMarkOverlay> createState() => _CoachMarkOverlayState();
}

class _CoachMarkOverlayState extends State<CoachMarkOverlay>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _scrimAnimation;
  late Animation<double> _panelOpacity;
  late Animation<double> _panelTranslation;

  late AnimationController _demoLoopController;

  @override
  void initState() {
    super.initState();

    // Entrance animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _scrimAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 220 / 280, curve: Curves.easeOut),
      ),
    );

    _panelOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Cubic(0.2, 0.8, 0.2, 1.0),
      ),
    );

    _panelTranslation = Tween<double>(begin: 16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Cubic(0.2, 0.8, 0.2, 1.0),
      ),
    );

    _entranceController.forward();

    // 2.4s demo loop:
    // 0.0 - 0.25: Slide right (Delete)
    // 0.25 - 0.50: Return to center
    // 0.50 - 0.75: Slide left (Keep)
    // 0.75 - 1.00: Return to center
    _demoLoopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _demoLoopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _demoLoopController]),
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Scrim
            Opacity(
              opacity: _scrimAnimation.value,
              child: Container(color: AppColors.scrimCoach),
            ),

            // Centered panel wrapped in Material to prevent yellow text underlines
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Opacity(
                  opacity: _panelOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _panelTranslation.value),
                    child: Material(
                      color: AppColors.floralWhite,
                      borderRadius: BorderRadius.circular(28),
                      elevation: 16,
                      shadowColor: const Color.fromRGBO(17, 18, 13, 0.35),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Mono label
                            Text(
                              'QUICK TIP',
                              style: AppTypography.smallLabel(
                                color: AppColors.oliveDrab,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // 136 tall demo area with live swiping animations
                            _buildDemoArea(),

                            const SizedBox(height: 16),

                            // Title
                            Text(
                              'Swipe to decide',
                              style: AppTypography.coachTipTitle(),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 10),

                            // Body
                            Text(
                              'Drag a card right to delete, left to keep. Nothing is removed until you confirm.',
                              style: AppTypography.coachBody(),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            // 52 olive button: Got it
                            PrimaryButton(
                              height: 52,
                              borderRadius: 14,
                              label: 'Got it',
                              onTap: widget.onDismiss,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDemoArea() {
    final t = _demoLoopController.value;
    double dx = 0.0;
    double angle = 0.0;
    double deleteHighlight = 0.0;
    double keepHighlight = 0.0;

    if (t < 0.25) {
      // 0.0 - 0.25: Slide right (Delete)
      final p = Curves.easeInOut.transform(t / 0.25);
      dx = 38.0 * p;
      angle = 8.0 * (pi / 180.0) * p;
      deleteHighlight = p;
    } else if (t < 0.50) {
      // 0.25 - 0.50: Back to center
      final p = Curves.easeInOut.transform((t - 0.25) / 0.25);
      dx = 38.0 * (1.0 - p);
      angle = 8.0 * (pi / 180.0) * (1.0 - p);
      deleteHighlight = 1.0 - p;
    } else if (t < 0.75) {
      // 0.50 - 0.75: Slide left (Keep)
      final p = Curves.easeInOut.transform((t - 0.50) / 0.25);
      dx = -38.0 * p;
      angle = -8.0 * (pi / 180.0) * p;
      keepHighlight = p;
    } else {
      // 0.75 - 1.00: Back to center
      final p = Curves.easeInOut.transform((t - 0.75) / 0.25);
      dx = -38.0 * (1.0 - p);
      angle = -8.0 * (pi / 180.0) * (1.0 - p);
      keepHighlight = 1.0 - p;
    }

    return SizedBox(
      height: 136,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Left chip: KEEP (highlights when swiping left)
          Positioned(
            left: 6,
            child: Transform.scale(
              scale: 1.0 + (0.08 * keepHighlight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        AppColors.sageTint.withOpacity(0.4),
                        AppColors.sageTint,
                        keepHighlight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: keepHighlight > 0.4
                            ? AppColors.sageInk
                            : AppColors.sageTintBorder,
                        width: keepHighlight > 0.4 ? 1.8 : 1.0,
                      ),
                      boxShadow: keepHighlight > 0.3
                          ? [
                              BoxShadow(
                                color: AppColors.sageInk.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: const ArrowLeftIcon(
                      size: 20,
                      color: AppColors.sageInk,
                      strokeWidth: 2.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'KEEP',
                    style: AppTypography.smallLabel(
                      color: AppColors.sageInk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right chip: DELETE (highlights when swiping right)
          Positioned(
            right: 6,
            child: Transform.scale(
              scale: 1.0 + (0.08 * deleteHighlight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        AppColors.terracottaTint.withOpacity(0.4),
                        AppColors.terracottaTint,
                        deleteHighlight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: deleteHighlight > 0.4
                            ? AppColors.terracotta
                            : AppColors.terracottaTintBorder,
                        width: deleteHighlight > 0.4 ? 1.8 : 1.0,
                      ),
                      boxShadow: deleteHighlight > 0.3
                          ? [
                              BoxShadow(
                                color: AppColors.terracotta.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: const ArrowRightIcon(
                      size: 20,
                      color: AppColors.terracotta,
                      strokeWidth: 2.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DELETE',
                    style: AppTypography.smallLabel(
                      color: AppColors.terracotta,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stacked Next Card behind (scales up slightly as front card is swiped)
          Positioned(
            child: Transform.scale(
              scale: 0.90 + 0.08 * max(deleteHighlight, keepHighlight),
              child: Container(
                width: 92,
                height: 116,
                decoration: BoxDecoration(
                  color: AppColors.stackedCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder, width: 1.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.oliveDrab,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'B',
                        style: AppTypography.avatarInitial(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.progressTrack,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Swiping Mini Card
          Positioned(
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: Transform.rotate(
                angle: angle,
                alignment: const Alignment(0, 1.4),
                child: Container(
                  width: 92,
                  height: 116,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.floralWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder, width: 1.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(17, 18, 13, 0.20),
                        blurRadius: 18,
                        offset: Offset(0, 9),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Normal card content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AppColors.oliveDrab,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'A',
                              style: AppTypography.avatarInitial(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 52,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.smokyBlack,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 38,
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.progressTrack,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ],
                      ),

                      // Swiping Left -> KEEP tint & stamp
                      if (keepHighlight > 0.05)
                        Container(
                          color: Color.fromRGBO(
                            63,
                            90,
                            43,
                            0.18 * keepHighlight,
                          ),
                        ),
                      if (keepHighlight > 0.15)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Opacity(
                            opacity: keepHighlight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.floralWhite,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.sageInk,
                                  width: 1.8,
                                ),
                              ),
                              child: Text(
                                'KEEP',
                                style: AppTypography.smallLabel(
                                  color: AppColors.sageInk,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Swiping Right -> DELETE tint & stamp
                      if (deleteHighlight > 0.05)
                        Container(
                          color: Color.fromRGBO(
                            178,
                            58,
                            46,
                            0.18 * deleteHighlight,
                          ),
                        ),
                      if (deleteHighlight > 0.15)
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Opacity(
                            opacity: deleteHighlight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.floralWhite,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.terracotta,
                                  width: 1.8,
                                ),
                              ),
                              child: Text(
                                'DELETE',
                                style: AppTypography.smallLabel(
                                  color: AppColors.terracotta,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
