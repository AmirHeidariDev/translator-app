import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator_v2/controllers/language_controller.dart';

final languageProvider = NotifierProvider<LanguageController, LanguageState>(() => LanguageController());
