import 'package:translator/translator.dart';

class TranslateService {
  final _translator = GoogleTranslator();

  Future<String> translateText({required String text, required String toLong, from}) async {
    final result = await _translator.translate(text, from: from, to: toLong);
    return result.text;
  }
}
