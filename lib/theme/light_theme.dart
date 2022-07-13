import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class LightTheme {
  static ThemeData data(BuildContext context) {
    return ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: LightAppColors.background,
        unselectedItemColor: LightAppColors.unSelectedNavtemColor,
        selectedItemColor: LightAppColors.primary,
      ),
      cardTheme: CardTheme(color: LightAppColors.cardColor, elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: LightAppColors.errorColor),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightAppColors.errorColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightAppColors.errorColor))),
      snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(color: Colors.white)),
      scaffoldBackgroundColor: LightAppColors.background,
      scrollbarTheme: ScrollbarThemeData(
        thumbColor:
            MaterialStateProperty.all(LightAppColors.primary.withAlpha(230)),
        radius: const Radius.circular(50),
        thickness: MaterialStateProperty.all(5),
      ),
      cardColor: LightAppColors.cardColor,
      iconTheme: const IconThemeData(color: Colors.black87),
      popupMenuTheme:
          const PopupMenuThemeData(enableFeedback: false, color: Colors.white),
      dividerColor: LightAppColors.dividerColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          inversePrimary: DarkAppColors.background,
          secondary: LightAppColors.secondary,
          primary: LightAppColors.primary,
          background: LightAppColors.background,
          error: LightAppColors.errorColor),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),
        side: BorderSide(color: LightAppColors.outlineButtonBorderCol),
        elevation: 0,
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              elevation: 0,
              primary: LightAppColors.primary,
              textStyle: const TextStyle(color: Colors.white))),
      appBarTheme: AppBarTheme(
        toolbarHeight: 60,
        iconTheme: IconThemeData(color: LightAppColors.textColor),
        elevation: 0,
        backgroundColor: LightAppColors.background,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: LightAppColors.background,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        titleTextStyle: TextStyle(
          color: LightAppColors.background,
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
        ),
      ),
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: "Poppins",
            bodyColor: LightAppColors.textColor,
            displayColor: LightAppColors.textColor,
          ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
