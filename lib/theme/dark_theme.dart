import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class DarkTheme {
  static ThemeData data(BuildContext context) {
    return ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkAppColors.background,
        unselectedItemColor: DarkAppColors.unSelectedNavtemColor,
        selectedItemColor: DarkAppColors.primary,
      ),
      cardTheme: CardTheme(
        color: DarkAppColors.cardColor,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.white60),
          errorStyle: TextStyle(color: DarkAppColors.errorColor),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: DarkAppColors.errorColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: DarkAppColors.errorColor))),
      snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(color: Colors.black87)),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: DarkAppColors.background),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(DarkAppColors.secondary),
        radius: const Radius.circular(50),
        thickness: MaterialStateProperty.all(5),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      popupMenuTheme: const PopupMenuThemeData(
        enableFeedback: false,
        color: Colors.black,
      ),
      scaffoldBackgroundColor: DarkAppColors.background,
      dividerColor: DarkAppColors.dividerColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: DarkAppColors.secondary,
          primary: DarkAppColors.primary,
          background: DarkAppColors.background,
          error: DarkAppColors.errorColor),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),
        side: BorderSide(color: DarkAppColors.outlineButtonBorderCol),
        elevation: 0,
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              elevation: 0,
              primary: DarkAppColors.primary,
              textStyle: TextStyle(color: DarkAppColors.background))),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: DarkAppColors.textColor),
        elevation: 0,
        backgroundColor: DarkAppColors.background,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: DarkAppColors.background,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        titleTextStyle: TextStyle(
          color: DarkAppColors.background,
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
        ),
      ),
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: "Poppins",
            bodyColor: DarkAppColors.textColor,
            displayColor: DarkAppColors.textColor,
          ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
