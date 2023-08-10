import 'flavor_config.dart';
import '../main_common.dart';
import 'package:flutter/material.dart';

void main() {
  mainCommon(
    FlavorConfig()
      ..appTitle = "Simpsons Viewer"
      ..flavorType = FlavorType.SimpsonsViewer
      ..theme = ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              backgroundColor: Colors.lightBlue,
            ),
      ),
  );
}
