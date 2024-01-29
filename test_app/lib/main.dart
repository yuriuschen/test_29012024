import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dependencies_registrator.dart';
import 'pages/home/home_page.dart';

void main() {
  DependenciesRegistrator().initializeDependencies();
  runApp(GetMaterialApp(home: HomePage()));
}
