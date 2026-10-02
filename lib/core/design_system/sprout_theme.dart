import 'package:flutter/material.dart';

import 'sprout_tokens.dart';

abstract final class SproutTheme {
  static ThemeData child() {
    return _base(parent: false);
  }

  static ThemeData parent() {
    return _base(parent: true);
  }

  static ThemeData _base({required bool parent}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: SproutColors.primary,
      primary: SproutColors.primary,
      onPrimary: SproutColors.surface,
      primaryContainer: SproutColors.primarySoft,
      onPrimaryContainer: SproutColors.ink,
      secondaryContainer: SproutColors.primarySoft,
      onSecondaryContainer: SproutColors.ink,
      surface: SproutColors.surface,
      onSurface: SproutColors.ink,
      onSurfaceVariant: SproutColors.inkMuted,
      outline: SproutColors.line,
      outlineVariant: SproutColors.cardEdge,
      surfaceTint: Colors.transparent,
      error: SproutColors.retry,
      onError: SproutColors.surface,
    );
    final titleSize = parent ? SproutType.parentTitle : SproutType.childTitle;
    final bodySize = parent ? SproutType.parentBody : SproutType.childBody;
    const buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(SproutRadius.button)),
    );
    final buttonSize = Size(
      SproutSize.parentTarget * 2,
      parent ? SproutSize.parentTarget : SproutSize.childTarget,
    );
    final buttonText = TextStyle(
      fontFamily: SproutType.family,
      fontSize: parent ? 16 : SproutType.childLabel + 2,
      fontWeight: FontWeight.w800,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: SproutType.family,
      scaffoldBackgroundColor: SproutColors.background,
      canvasColor: SproutColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: SproutColors.background,
        foregroundColor: SproutColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: const TextStyle(
          fontFamily: SproutType.family,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: SproutColors.ink,
        ),
      ),
      cardTheme: const CardThemeData(
        color: SproutColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SproutRadius.card)),
          side: BorderSide(color: SproutColors.cardEdge),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SproutColors.primary,
          foregroundColor: SproutColors.surface,
          disabledBackgroundColor: SproutColors.disabledFill,
          disabledForegroundColor: SproutColors.disabledInk,
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: buttonText,
          padding: const EdgeInsets.symmetric(horizontal: SproutSpace.lg),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SproutColors.primary,
          disabledForegroundColor: SproutColors.disabledInk,
          backgroundColor: SproutColors.surface,
          minimumSize: buttonSize,
          shape: buttonShape,
          side: const BorderSide(color: SproutColors.primary, width: 2),
          textStyle: buttonText,
          padding: const EdgeInsets.symmetric(horizontal: SproutSpace.lg),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SproutColors.primary,
          minimumSize: const Size(
            SproutSize.parentTarget,
            SproutSize.parentTarget,
          ),
          textStyle: const TextStyle(
            fontFamily: SproutType.family,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: SproutColors.ink,
          minimumSize: const Size(
            SproutSize.parentTarget,
            SproutSize.parentTarget,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: SproutColors.surface,
        labelStyle: TextStyle(color: SproutColors.inkMuted),
        floatingLabelStyle: TextStyle(color: SproutColors.primary),
        contentPadding: EdgeInsets.symmetric(
          horizontal: SproutSpace.md,
          vertical: SproutSpace.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: SproutColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: SproutColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: SproutColors.primary, width: 2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? SproutColors.surface
              : SproutColors.line,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? SproutColors.primary
              : SproutColors.disabledFill,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(SproutColors.line),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: SproutColors.primary,
        textColor: SproutColors.ink,
        selectedColor: SproutColors.primary,
        minVerticalPadding: SproutSpace.sm,
        titleTextStyle: TextStyle(
          fontFamily: SproutType.family,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: SproutColors.ink,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: SproutType.family,
          fontSize: 15,
          color: SproutColors.inkMuted,
          height: 1.35,
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: SproutColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SproutRadius.card)),
        ),
        titleTextStyle: TextStyle(
          fontFamily: SproutType.family,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: SproutColors.ink,
        ),
        contentTextStyle: TextStyle(
          fontFamily: SproutType.family,
          fontSize: 17,
          color: SproutColors.ink,
          height: 1.35,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: SproutColors.cardEdge,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: SproutColors.ink,
        contentTextStyle: TextStyle(
          fontFamily: SproutType.family,
          color: SproutColors.surface,
          fontSize: 16,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        backgroundColor: SproutColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: SproutColors.primarySoft,
        indicatorShape: const StadiumBorder(),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 28,
            color: states.contains(WidgetState.selected)
                ? SproutColors.primary
                : SproutColors.inkMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: SproutType.family,
            fontSize: 15,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? SproutColors.primary
                : SproutColors.inkMuted,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SproutColors.primary,
        linearTrackColor: SproutColors.primarySoft,
        circularTrackColor: SproutColors.primarySoft,
        linearMinHeight: 10,
        borderRadius: BorderRadius.all(Radius.circular(SproutRadius.pill)),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: titleSize + 2,
          fontWeight: FontWeight.w800,
          color: SproutColors.ink,
          height: 1.15,
        ),
        headlineMedium: TextStyle(
          fontSize: titleSize,
          fontWeight: FontWeight.w800,
          color: SproutColors.ink,
          height: 1.2,
        ),
        headlineSmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: SproutColors.ink,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          fontSize: parent ? 20 : SproutType.childSection,
          fontWeight: FontWeight.w800,
          color: SproutColors.ink,
          height: 1.2,
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: SproutColors.ink,
          height: 1.25,
        ),
        titleSmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: SproutColors.ink,
          height: 1.25,
        ),
        bodyLarge: TextStyle(
          fontSize: bodySize,
          fontWeight: FontWeight.w600,
          color: SproutColors.ink,
          height: 1.35,
        ),
        bodyMedium: TextStyle(
          fontSize: parent ? SproutType.parentBody : SproutType.childLabel,
          fontWeight: FontWeight.w500,
          color: SproutColors.inkMuted,
          height: 1.35,
        ),
        bodySmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: SproutColors.inkMuted,
          height: 1.35,
        ),
        labelLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: SproutColors.ink,
        ),
        labelMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: SproutColors.ink,
        ),
      ),
    );
  }
}
