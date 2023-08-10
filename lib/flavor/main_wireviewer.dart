import 'flavor_config.dart';
import '../main_common.dart';
import 'package:flutter/material.dart';

void main() {
  mainCommon(
    FlavorConfig()
      ..appTitle = "Wire Viewer"
      ..flavorType = FlavorType.WireViewer
      ..theme = ThemeData.light().copyWith(
        primaryColor: Colors.green,
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              backgroundColor: Colors.greenAccent,
            ),
      ),
  );
}
