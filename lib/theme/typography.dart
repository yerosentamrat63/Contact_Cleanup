import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  // --- Bricolage Grotesque Styles ---

  static TextStyle counterBig({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.0,
        letterSpacing: -1.8,
        color: color,
      );

  static TextStyle onboardingHeadline({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 38,
        fontWeight: FontWeight.w800,
        height: 1.02,
        letterSpacing: -1.52,
        color: color,
      );

  static TextStyle permissionHeadline({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 38,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.52,
        color: color,
      );

  static TextStyle screenTitle({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.6,
        color: color,
      );

  static TextStyle contactCardName({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.26,
        color: color,
      );

  static TextStyle contactCardPhone({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.66,
        color: color,
      );

  static TextStyle coachTipTitle({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        color: color,
      );

  static TextStyle confirmSheetTitle({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.28,
        color: color,
      );

  static TextStyle doneStatNumber({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.0,
        letterSpacing: -1.62,
        color: color,
      );

  static TextStyle stepNumber({Color color = AppColors.oliveDrab}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.17,
        color: color,
      );

  static TextStyle appName({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: color,
      );

  static TextStyle rowName({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.34,
        color: color,
      );

  static TextStyle buttonLabel({Color color = AppColors.floralWhite}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.34,
        color: color,
      );

  static TextStyle avatarInitial({
    required double fontSize,
    Color color = AppColors.floralWhite,
    FontWeight fontWeight = FontWeight.w800,
  }) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: -0.03 * fontSize,
        color: color,
      );

  // --- JetBrains Mono Styles ---

  static TextStyle counterTotal({Color color = AppColors.oliveDrab}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.44,
        color: color,
      );

  static TextStyle actionButtonLabel({Color color = AppColors.oliveDrab}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.68,
        color: color,
      );

  static TextStyle screenCaption({Color color = AppColors.oliveDrab}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        color: color,
      );

  static TextStyle reviewSelectedCount({Color color = AppColors.smokyBlack}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.44,
        color: color,
      );

  static TextStyle reviewTickAll({Color color = AppColors.oliveDrab}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.44,
        decoration: TextDecoration.underline,
        color: color,
      );

  static TextStyle stamp({required Color color}) => GoogleFonts.jetBrainsMono(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.4,
        color: color,
      );

  static TextStyle smallLabel({
    Color color = AppColors.oliveDrab,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: fontWeight,
        letterSpacing: 1.54,
        color: color,
      );

  static TextStyle rowPhone({Color color = AppColors.oliveDrab}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.48,
        color: color,
      );

  static TextStyle cardEmail({Color color = AppColors.oliveDrab}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.48,
        color: color,
      );

  static TextStyle stepDescription({Color color = AppColors.oliveDrab}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.24,
        color: color,
      );

  static TextStyle coachBody({Color color = AppColors.oliveInk}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.24,
        color: color,
      );

  static TextStyle permissionParagraph({Color color = AppColors.oliveInk}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.26,
        color: color,
      );
}
