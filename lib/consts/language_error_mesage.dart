import 'package:translator_v2/controllers/language_controller.dart';

String languageErrorMesage({required LanguageError error}) {
  switch (error) {
    case LanguageError.toAutoNotAllowed:
      return "تشخیص خودکار فقط برای زبان مبدا قابل استفاده است";
    case LanguageError.connotSwapWhenAuto:
      return "وقتی زبان روی تشخیص خودکار است جابجایی ممکن نیست";
    case LanguageError.sameSourceAndTarget:
      return "زبان مبدا و مقصد نباید یکسان باشد ";
  }
}
