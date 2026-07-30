import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator_v2/controllers/theme_mode_controller.dart';

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(() => ThemeModeController());
