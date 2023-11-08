import 'package:flutter/material.dart';

//const Color PrimaryColor = Color(0xFF3884A0);
//const Color SecondaryColor = Color(0xFF67C8D5);
const Color SecondarySubColor = Color(0xFFF3F3F3);
const Color SubColor = Color(0xFFFFC413);

const Color PrimaryColor = Color(0xFFC90202);
const Color SecondaryColor = Colors.amber;
const Color blackYellow = Color(0xFFFBBC05);
const Color blackBlue = Color(0xFF001540);

const Color PrimaryText = Color(0xFF414449);
const Color titleSubText = Color(0xFF6C6C6C);
const Color BgColor = Color(0xFFFDFDFD);
const Color TextFiledColor = Color(0xFFEAEAEA);

const Color TableColor = Color(0xFF67C8D5);

const Color green = Color(0xFF497911);

//Row Light color FFE8E8

const Color redLight = Color(0xFFFFE8E8);
const Color greyLight = Color(0xFFF1F1F1);
const Color blueLight = Color(0xFFE4EDFC);
const Color BaseLight = Color(0xFFF6F6F6);
const Color yellowLight = Color(0xFFFFECCA);
const Color greenLight = Color(0xFFD4FFE2);
const Color appLight = Color(0xFFF8F8F8);

const Color textField = Color(0xFFE2E1E1);

//Mode Colors Table & Chair
//497911FF
const Color emptyTable = Color(0xFF1CB11F);
const Color fullTable =Color(0xFFFFBC00);
const Color freeTable = Color(0xFFFFBC00);
const Color reservedTable = PrimaryColor;

const Color emptyTableLight = greenLight;
const Color fullTableLight = yellowLight;
const Color freeTableLight = greyLight;
const Color reservedTableLight =  redLight;


const Color activeChair = fullTable;
const Color freeChair =  Color(0xFFC6C6C6);


class CustomColors {
  static Color primaryTextColor = Colors.white;
  static Color dividerColor = Colors.white54;
  static Color pageBackgroundColor = Color(0xFF2D2F41);
  static Color menuBackgroundColor = Color(0xFF242634);

  static Color clockBG = Color(0xFF444974);
  static Color clockOutline = Color(0xFFEAECFF);
  static Color secHandColor = Colors.orange;
  static Color minHandStatColor = Color(0xFF748EF6);
  static Color minHandEndColor = Color(0xFF77DDFF);
  static Color hourHandStatColor = Color(0xFFC279FB);
  static Color hourHandEndColor = Color(0xFFEA74AB);

}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = [Color(0xFF10C1C6), Color(0xFF49B0C4)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
  static List<Color> beamsGradient = [Color(0xFF006AA8) , Color(0xFF00CED5)];
  static List<Color> greenGradient = [Color(0xFF1FB7B6), Color(0xFF188785)];
  static List<Color> orangeGradient = [Color(0xFFFF784E), Color(0xFFE44F22)];
  static List<Color> orangeGradient1 = [Color(0xFFE44F22),Color(0xFFFF784E) ];
  static List<Color> pinkGradient = [Color(0xFFF6587D), Color(0xFFCC0031)];
  static List<Color> blueGradient = [Color(0xFF259CE2), Color(0xFF18DDFC)];
  static List<Color> yellowGradient = [Color(0xFFFFAE21), Color(0xFFE99E11)];
  static List<Color> yellowGradient1 = [Color(0xFFE99E11),Color(0xFFFFC353)];
  static List<Color> yellowGradient2 = [Color(0xFFFFDD00), Color(0xFFE59500)];
  static List<Color> redGradient = [Color(0xFFD20000), Color(0xFFFF3939)];
  static List<Color> redGradient3 = [Color(0xFFFF3636).withOpacity(0.9), Color(
      0xFF710000).withOpacity(0.8)];
  static List<Color> redGradient2 = [Color(0xFFEC9A05).withOpacity(0.9), Color(
      0xFF580000).withOpacity(0.7)];
  static List<Color> redGradient4 = [Color(0xFF710000).withOpacity(0.7), Color(
      0xFFFF3636).withOpacity(0.9)];
  static List<Color> yellowGradient4 = [Color(0xFF8E6300).withOpacity(0.7), Color(
      0xFFFFAB00)];

}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
    GradientColors(GradientColors.blueGradient),
    GradientColors(GradientColors.greenGradient),
    GradientColors(GradientColors.orangeGradient),
    GradientColors(GradientColors.orangeGradient1),
    GradientColors(GradientColors.pinkGradient),
    GradientColors(GradientColors.blueGradient),
    GradientColors(GradientColors.yellowGradient),
    GradientColors(GradientColors.redGradient),
    GradientColors(GradientColors.yellowGradient1),
    GradientColors(GradientColors.redGradient2),
    GradientColors(GradientColors.yellowGradient2),
    GradientColors(GradientColors.redGradient3),
    GradientColors(GradientColors.redGradient4),
    GradientColors(GradientColors.yellowGradient4)

  ];
}

class BeamsGradientTemplate {
  static List<GradientColors> gradientTemplate = [

    GradientColors(GradientColors.beamsGradient),
    GradientColors(GradientColors.greenGradient),
    GradientColors(GradientColors.orangeGradient),
    GradientColors(GradientColors.pinkGradient),
    GradientColors(GradientColors.blueGradient)

  ];
}

class UserGradientTemplate {
  static List<GradientColors> gradientTemplate = [

    GradientColors(GradientColors.pinkGradient),
    GradientColors(GradientColors.greenGradient),
    GradientColors(GradientColors.beamsGradient),
    GradientColors(GradientColors.orangeGradient),
    GradientColors(GradientColors.blueGradient),
    GradientColors(GradientColors.pinkGradient),
    GradientColors(GradientColors.greenGradient),
    GradientColors(GradientColors.beamsGradient),
    GradientColors(GradientColors.orangeGradient),
    GradientColors(GradientColors.blueGradient),
    GradientColors(GradientColors.pinkGradient),
    GradientColors(GradientColors.greenGradient),
    GradientColors(GradientColors.beamsGradient),
    GradientColors(GradientColors.orangeGradient),
    GradientColors(GradientColors.blueGradient),
    GradientColors(GradientColors.pinkGradient),
    GradientColors(GradientColors.greenGradient),
    GradientColors(GradientColors.beamsGradient),
    GradientColors(GradientColors.orangeGradient),
    GradientColors(GradientColors.blueGradient)

  ];
}


class ColorsList {
  static List<Color> gradientTemplate = [
    Color(0xFFE30031),
    Color(0xFF188785),
    Color(0xFFFFA738),
    Color(0xFF77DDFF),
    Color(0xFF748EF6),
    Color(0xFF6448FE),
    Color(0xFFEA74AB),


  ];
}