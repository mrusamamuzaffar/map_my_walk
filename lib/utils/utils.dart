import 'package:flutter/material.dart';

import '../models/nav_bar_item_model.dart';
import '../painters/home.dart';
import '../painters/trophy.dart';
import '../screens/home/home.dart';
import '../screens/leader_board/leader_board.dart';

class Utils {
  static List<List<dynamic>> dashStats = [
    ["Calories", 400.0, "kcal"],
    ["Divider"],
    ['Speed Avg.', 3.0, 'km/h'],
    ["Divider"],
    ["Distance", 7.0, "Km"]
  ];

  static List<Widget> navBarScreens = [
    const HomeScreen(),
    LeaderboardPage(),
  ];

  static List<NavbarItemModel> navBarItem = [
    NavbarItemModel(
      label: "Home",
      icon: CustomPaint(
        painter: HomeIconPainter(),
        size: const Size(22, 22),
      ),
    ),
    NavbarItemModel(
      label: "Profile",
      icon: CustomPaint(
        painter: TrophyPainter(),
        size: const Size(22, 22),
      ),
    ),
  ];


}
