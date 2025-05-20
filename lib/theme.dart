import 'package:flutter/material.dart';

// class AppColors {
//   static const Color primary = Color(0xFF9C27B0);
//   static const Color primaryVariant = Color(0xFF7B1FA2);
//   static const Color secondary = Color(0xFFE040FB);
//   static const Color secondaryVariant = Color(0xFFD500F9);
//   static const Color background = Color.fromARGB(255, 241, 239, 243);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color error = Color(0xFFB00020);
//   static const Color onPrimary = Color(0xFFFFFFFF);
//   static const Color onSecondary = Color(0xFFFFFFFF);
//   static const Color onBackground = Color(0xFF000000);
//   static const Color onSurface = Color(0xFF000000);
//   static const Color success = Color(0xFF4CAF50);
//   static const Color onSuccess = Color(0xFFFFFFFF);
//   static const Color lightGray = Color(0xFFD3D3D3);
//   static const Color lightGrayVariant = Color(0xFFA9A9A9);

//   // Dark Mode Colors
//   static const Color darkPrimary = Color(0xFFCE93D8);
//   static const Color darkPrimaryVariant = Color(0xFFAB47BC);
//   static const Color darkSecondary = Color(0xFFEA80FC);
//   static const Color darkSecondaryVariant = Color(0xFF9C4DCC);
//   static const Color darkBackground = Color.fromARGB(255, 17, 17, 17);
//   static const Color darkSurface = Color(0xFF1E1E1E);
//   static const Color darkError = Color(0xFFCF6679);
//   static const Color darkOnPrimary = Color(0xFF000000);
//   static const Color darkOnSecondary = Color(0xFF000000);
//   static const Color darkOnBackground = Color(0xFFFFFFFF);
//   static const Color darkOnSurface = Color(0xFFFFFFFF);
//   static const Color darkSuccess = Color(0xFF81C784);
//   static const Color darkOnSuccess = Color(0xFF000000);
//   static const Color darkGray = Color(0xFF696969);
//   static const Color darkGrayVariant = Color(0xFF505050);
// }

class AppColors {
  static const Color primary = Color(0xFF000000); // Black
  static const Color primaryVariant =
      Color(0xFF1A1A1A); // Slightly lighter black
  static const Color secondary = Color(0xFFFFFFFF); // White
  static const Color secondaryVariant = Color(0xFFF5F5F5); // Soft white/gray

  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFF0F0F0); // Light gray surface
  static const Color error = Color(0xFFB00020); // Keep red for visibility
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on black
  static const Color onSecondary = Color(0xFF000000); // Black text on white
  static const Color onBackground = Color(0xFF000000); // Black text on white bg
  static const Color onSurface = Color(0xFF000000); // Black text on surface

  static const Color success =
      Color(0xFF4CAF50); // Optional green (can be grayscale if preferred)
  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color lightGrayVariant = Color(0xFFBDBDBD);

  // Dark Mode
  static const Color darkPrimary = Color(0xFFFFFFFF); // White
  static const Color darkPrimaryVariant = Color(0xFFDCDCDC);
  static const Color darkSecondary = Color(0xFF000000); // Black
  static const Color darkSecondaryVariant = Color(0xFF1A1A1A);

  static const Color darkBackground = Color(0xFF000000); // True black
  static const Color darkSurface = Color(0xFF121212); // Slightly raised surface
  static const Color darkError =
      Color(0xFFCF6679); // Keep visibility for errors
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);

  static const Color darkSuccess = Color(0xFF81C784);
  static const Color darkOnSuccess = Color(0xFF000000);

  static const Color darkGray = Color(0xFF2E2E2E);
  static const Color darkGrayVariant = Color(0xFF424242);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 1,
        // centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onPrimary,
        ),
      ),
      dataTableTheme: DataTableThemeData(
          decoration: BoxDecoration(border: Border()),
          dividerThickness: 0,
          dataRowColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            return AppColors.surface;
          }),
          headingRowColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            return AppColors.surface;
          })),
      dividerTheme: DividerThemeData(
        color: AppColors.onSurface.withAlpha(0),
        space: 1,
        thickness: 1,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            fontSize: 16, color: AppColors.onBackground.withAlpha(200)),
        bodyMedium: TextStyle(
            fontSize: 14, color: AppColors.onBackground.withAlpha(250)),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(
            fontSize: 14, color: AppColors.onBackground.withAlpha(100)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: TextStyle(color: AppColors.onSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.lightGrayVariant),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.lightGray;
        }),
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.onPrimary
              : AppColors.lightGrayVariant;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.lightGrayVariant;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dividerColor: AppColors.lightGrayVariant,
      iconTheme: const IconThemeData(color: AppColors.onPrimary),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: TextStyle(color: AppColors.onPrimary),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.darkPrimary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnSecondary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        error: AppColors.darkError,
        onError: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        elevation: 1,
        // centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnPrimary,
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AppColors.darkGray),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.darkOnBackground,
          fontSize: 14,
        ),
        dataRowColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.darkGrayVariant.withAlpha(160);
            }
            return Colors.transparent;
          },
        ),
        dataTextStyle: const TextStyle(
          color: AppColors.darkOnBackground,
          fontSize: 13,
        ),
        dividerThickness: 0.5,
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.onSurface.withAlpha(1),
        space: 1,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkOnBackground),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkOnBackground),
        titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkOnBackground),
        labelLarge: TextStyle(fontSize: 14, color: AppColors.darkOnBackground),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkOnPrimary,
          side: const BorderSide(color: AppColors.darkPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        labelStyle: TextStyle(color: AppColors.darkOnSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.darkGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.darkPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.darkGrayVariant),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.darkPrimary
              : AppColors.darkGray;
        }),
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.darkOnPrimary
              : AppColors.darkGrayVariant;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.darkPrimary
              : AppColors.darkGrayVariant;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dividerColor: AppColors.darkGrayVariant,
      iconTheme: const IconThemeData(color: AppColors.darkOnPrimary),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.darkPrimary,
        contentTextStyle: TextStyle(color: AppColors.darkOnPrimary),
      ),
    );
  }
}
// Light theme
/*
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  cardColor: AppColors.surface,
  scaffoldBackgroundColor: AppColors.background,
  cardTheme: CardTheme(
    color: AppColors.surface,
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary),
    ),
  ),
  colorScheme: ColorScheme.light(
    surfaceBright: AppColors.lightGray,
    surfaceDim: AppColors.lightGrayVariant,
    tertiary: AppColors.success,
    onTertiary: AppColors.onSuccess,
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryVariant,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryVariant,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onSurface: AppColors.onSurface,
  ),
  dataTableTheme: DataTableThemeData(
      decoration: BoxDecoration(border: Border()),
      dividerThickness: 0,
      dataRowColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        return AppColors.surface;
      }),
      headingRowColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        return AppColors.surface;
      })),
  dividerTheme: DividerThemeData(
    color: AppColors.onSurface.withAlpha(0),
    space: 1,
    thickness: 1,
  ),
  iconTheme: IconThemeData(
    color: AppColors.onBackground,
    size: 24,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.primary;
      return AppColors.onSurface.withValues(alpha: 0.5);
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary.withValues(alpha: 0.5);
      }
      return AppColors.onSurface.withValues(alpha: 0.2);
    }),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.primary;
      return AppColors.onSurface.withValues(alpha: 0.5);
    }),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 1,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackground),
    titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.onBackground),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.onBackground),
    labelLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onPrimary),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.primary,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     foregroundColor: AppColors.onPrimary,
  //     backgroundColor: AppColors.primary,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //   ),
  // ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.onPrimary,
      backgroundColor: AppColors.primary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: BorderSide(color: AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
  ),
);

// Dark theme
final ThemeData darkTheme = ThemeData(
  fontFamily: 'Poppins',
  brightness: Brightness.dark,
  primaryColor: AppColors.darkPrimary,
  cardColor: AppColors.darkSurface,
  scaffoldBackgroundColor: AppColors.darkBackground,
  cardTheme: CardTheme(
    color: AppColors.darkSurface,
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          BorderSide(color: AppColors.darkPrimary.withValues(alpha: 0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.darkPrimary),
    ),
  ),
  colorScheme: ColorScheme.dark(
    surfaceBright: AppColors.darkGray,
    surfaceDim: AppColors.darkGrayVariant,
    tertiary: AppColors.darkSuccess,
    onTertiary: AppColors.darkOnSuccess,
    primary: AppColors.darkPrimary,
    primaryContainer: AppColors.darkPrimaryVariant,
    secondary: AppColors.darkSecondary,
    secondaryContainer: AppColors.darkSecondaryVariant,
    surface: AppColors.darkSurface,
    error: AppColors.darkError,
    onPrimary: AppColors.darkOnPrimary,
    onSecondary: AppColors.darkOnSecondary,
    onSurface: AppColors.darkOnSurface,
  ),
  dividerTheme: DividerThemeData(
    color: AppColors.darkOnSurface.withValues(alpha: 0.1),
    space: 1,
    thickness: 1,
  ),
  iconTheme: IconThemeData(
    color: AppColors.darkOnBackground,
    size: 24,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.darkPrimary;
      return AppColors.darkOnSurface.withValues(alpha: 0.5);
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.darkPrimary.withValues(alpha: 0.5);
      }
      return AppColors.darkOnSurface.withValues(alpha: 0.2);
    }),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.darkPrimary;
      return AppColors.darkOnSurface.withValues(alpha: 0.5);
    }),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkPrimary,
    foregroundColor: AppColors.darkOnPrimary,
    elevation: 1,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.darkOnBackground),
    titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.darkOnBackground),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkOnBackground),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkOnBackground),
    labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.darkOnPrimary),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.darkPrimary,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.darkOnPrimary,
      backgroundColor: AppColors.darkPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.darkPrimary,
  ),
);
*/
