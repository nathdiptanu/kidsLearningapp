import 'package:flutter/material.dart';

/// Original, quiet garden colours. Walls stay dark in every adventure.
class MazePalette {
  const MazePalette(
    this.name,
    this.icon,
    this.ground,
    this.tile,
    this.wall,
    this.player,
    this.flower,
  );

  final String name;
  final IconData icon;
  final Color ground, tile, wall, player, flower;

  static MazePalette forVariant(int variant) =>
      gardens[variant % gardens.length];

  static const gardens = [
    MazePalette(
      'Rainbow garden',
      Icons.local_florist_rounded,
      Color(0xFFF0FBF1),
      Color(0xFFD8F2DE),
      Color(0xFF24574B),
      Color(0xFF5B3CC4),
      Color(0xFFF16AA4),
    ),
    MazePalette(
      'Sunny meadow',
      Icons.wb_sunny_rounded,
      Color(0xFFFFFAE7),
      Color(0xFFFFEDBF),
      Color(0xFF65502A),
      Color(0xFF267C78),
      Color(0xFFF09A39),
    ),
    MazePalette(
      'Bluebell beach',
      Icons.water_rounded,
      Color(0xFFF0FAFF),
      Color(0xFFD8EFFB),
      Color(0xFF284F75),
      Color(0xFF6342B5),
      Color(0xFFEA70AB),
    ),
    MazePalette(
      'Berry blossom',
      Icons.spa_rounded,
      Color(0xFFFFF3F8),
      Color(0xFFFADDEA),
      Color(0xFF754064),
      Color(0xFF287C65),
      Color(0xFFE68B2D),
    ),
    MazePalette(
      'Twinkle garden',
      Icons.auto_awesome_rounded,
      Color(0xFFF7F3FF),
      Color(0xFFE8DFFA),
      Color(0xFF504076),
      Color(0xFF267C78),
      Color(0xFFEC8B4A),
    ),
  ];
}
