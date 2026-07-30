import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator_v2/controllers/translate_controller.dart';

final translateProvider = NotifierProvider<TranslateController, TranslateState>(() => TranslateController());
