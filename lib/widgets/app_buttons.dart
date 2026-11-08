import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final bool isEnabled;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor = AppColors.oliveDrab,
    this.textColor = AppColors.floralWhite,
    this.height = 56,
    this.borderRadius = 16,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isEnabled ? 1.0 : 0.4,
      child: SizedBox(
        height: height,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: isEnabled ? onTap : null,
            child: Center(
              child: Text(
                label,
                style: AppTypography.buttonLabel(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final Color textColor;

  const OutlineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 56,
    this.borderRadius = 16,
    this.textColor = AppColors.smokyBlack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: AppColors.outlineBorder, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: AppTypography.buttonLabel(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final double size;
  final String? semanticLabel;
  final bool isEnabled;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 44,
    this.semanticLabel,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: isEnabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isEnabled ? 1.0 : 0.4,
        child: SizedBox(
          width: size,
          height: size,
          child: Material(
            color: AppColors.floralWhite,
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.controlBorder, width: 1.0),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: isEnabled ? onTap : null,
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}

class ActionChoiceButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  final Color activeTint;
  final Color defaultBackground;
  final Color borderColor;
  final double highlightProgress; // 0.0 to 1.0 based on drag
  final String semanticLabel;

  const ActionChoiceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.activeTint,
    this.defaultBackground = AppColors.floralWhite,
    required this.borderColor,
    this.highlightProgress = 0.0,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final currentColor = Color.lerp(
      defaultBackground,
      activeTint,
      highlightProgress.clamp(0.0, 1.0),
    )!;

    return Semantics(
      label: semanticLabel,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 68,
              height: 68,
              child: Material(
                color: currentColor,
                shape: CircleBorder(
                  side: BorderSide(
                    color: highlightProgress > 0.05
                        ? borderColor
                        : AppColors.controlBorder,
                    width: highlightProgress > 0.05 ? 1.5 : 1.0,
                  ),
                ),
                elevation: 0,
                child: Center(child: icon),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: AppTypography.actionButtonLabel(),
            ),
          ],
        ),
      ),
    );
  }
}

