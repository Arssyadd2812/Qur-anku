import 'package:flutter/material.dart';
import 'package:belajar_flutter1/views/main_menu_page.dart';
import 'package:belajar_flutter1/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: AppTheme.theme,
    home: const MainMenuPage(),
    debugShowCheckedModeBanner: false,
  ));
}