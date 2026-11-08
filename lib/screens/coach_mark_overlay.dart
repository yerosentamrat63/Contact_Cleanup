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

    // 2.4s demo loop: rest -> slide +30, tilt +7° -> rest -> slide -30, tilt -7° -> rest
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

            // Centered panel
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Opacity(
                  opacity: _panelOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _panelTranslation.value),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.floralWhite,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(17, 18, 13, 0.25),
                            blurRadius: 36,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
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

                          // 130 tall demo area
                          _buildDemoArea(),

                          const SizedBox(height: 20),

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
          ],
        );
      },
    );
  }

  Widget _buildDemoArea() {
    final t = _demoLoopController.value;
    // Calculate dx and angle over 2.4s loop:
    // 0.0 - 0.25: 0 -> +30 dx, 0 -> +7 deg
    // 0.25 - 0.50: +30 -> 0 dx, +7 -> 0 deg
    // 0.50 - 0.75: 0 -> -30 dx, 0 -> -7 deg
    // 0.75 - 1.00: -30 -> 0 dx, -7 -> 0 deg
    double dx = 0.0;
    double angle = 0.0;

    if (t < 0.25) {
      final p = Curves.easeInOut.transform(t / 0.25);
      dx = 30.0 * p;
      angle = 7.0 * (3.14159 / 180) * p;
    } else if (t < 0.50) {
      final p = Curves.easeInOut.transform((t - 0.25) / 0.25);
      dx = 30.0 * (1.0 - p);
      angle = 7.0 * (3.14159 / 180) * (1.0 - p);
    } else if (t < 0.75) {
      final p = Curves.easeInOut.transform((t - 0.50) / 0.25);
      dx = -30.0 * p;
      angle = -7.0 * (3.14159 / 180) * p;
    } else {
      final p = Curves.easeInOut.transform((t - 0.75) / 0.25);
      dx = -30.0 * (1.0 - p);
      angle = -7.0 * (3.14159 / 180) * (1.0 - p);
    }

    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Left chip: KEEP
          Positioned(
            left: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.sageTint,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.sageTintBorder, width: 1),
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

          // Right chip: DELETE
          Positioned(
            right: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.terracottaTint,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.terracottaTintBorder,
                      width: 1,
                    ),
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

          // Left ghost card (40% opacity, tilted left)
          Positioned(
            child: Opacity(
              opacity: 0.4,
              child: Transform.rotate(
                angle: -6 * 3.14159 / 180,
                alignment: const Alignment(0, 1.4),
                child: Container(
                  width: 92,
                  height: 116,
                  decoration: BoxDecoration(
                    color: AppColors.floralWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder, width: 1),
                  ),
                ),
              ),
            ),
          ),

          // Right ghost card (40% opacity, tilted right)
          Positioned(
            child: Opacity(
              opacity: 0.4,
              child: Transform.rotate(
                angle: 6 * 3.14159 / 180,
                alignment: const Alignment(0, 1.4),
                child: Container(
                  width: 92,
                  height: 116,
                  decoration: BoxDecoration(
                    color: AppColors.floralWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder, width: 1),
                  ),
                ),
              ),
            ),
          ),

          // Looping animated mini card (92x116, radius 18, avatar 36, two bars)
          Positioned(
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: Transform.rotate(
                angle: angle,
                alignment: const Alignment(0, 1.4),
                child: Container(
                  width: 92,
                  height: 116,
                  decoration: BoxDecoration(
                    color: AppColors.floralWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(17, 18, 13, 0.14),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
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
                        width: 50,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

