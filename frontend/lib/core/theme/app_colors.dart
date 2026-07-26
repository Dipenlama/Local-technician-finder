import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF3D5AF1);
  static const primaryDark = Color(0xFF263AA7);
  static const primarySoft = Color(0xFFE9EDFF);
  static const secondary = Color(0xFF11A88A);
  static const secondarySoft = Color(0xFFE4F8F3);
  static const accent = Color(0xFFFFB85C);
  static const canvas = Color(0xFFF6F8FC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF0F3F9);
  static const ink = Color(0xFF172033);
  static const inkMuted = Color(0xFF68738A);
  static const outline = Color(0xFFE3E8F2);
  static const success = Color(0xFF159A73);
  static const warning = Color(0xFFF29B38);
  static const danger = Color(0xFFE25757);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF526DF6), Color(0xFF3149C9)],
  );
}
