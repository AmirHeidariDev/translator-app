import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator_v2/services/storage/local_storage_service.dart';
import 'package:translator_v2/services/storage/storage_key.dart';

//مدیریت استیت انتخاب زبان
class LanguageState {
  final String from, to;
  LanguageState({required this.from, required this.to});

  LanguageState copyWith({String? from, to}) {
    return LanguageState(from: from ?? this.from, to: to ?? this.to);
  }
}

//تغییر برای مبدا است یا مقصد
enum LanguageTarget { from, to }

//ارور های انتخاب زبان
enum LanguageError { toAutoNotAllowed, sameSourceAndTarget, connotSwapWhenAuto }

//کنترلر نوتیفایر
class LanguageController extends Notifier<LanguageState> {
  //پیشفرض زبان ها
  static const String _defultFrom = "auto";
  static const String _defultTo = "en";
  @override
  build() {
    return LanguageState(from: _defultFrom, to: _defultTo);
  }

  //خواندن زبان های انتخاب شده از استوریج
  Future<void> loadLanguageStorage() async {
    final savedFrom = await LocalStorageService.getString(StorageKey.fromLang) ?? _defultFrom;
    final savedTo = await LocalStorageService.getString(StorageKey.toLang) ?? _defultTo;

    //مقصد اتو نباشد
    final safeTo = (savedTo == "auto") ? _defultTo : savedTo;

    //ذخیره کردن  استیت کنترلر
    state = LanguageState(from: savedFrom, to: safeTo);
  }

  //ست کردن زبان ها با کد زبان
  LanguageError? setLanguage(LanguageTarget target, String code) {
    //مقصد اتو نباشد
    if (target == LanguageTarget.to && code == "auto") {
      return LanguageError.toAutoNotAllowed;
    }

    //انتخاب مبدا بود
    if (target == LanguageTarget.from) {
      //مخالف اتو باشد و با زبان مقصد برابر بود
      if (code != "auto" && code == state.to) {
        return LanguageError.sameSourceAndTarget;
      }

      //ذخیره کردن استیت و استوریج
      state = state.copyWith(from: code);
      LocalStorageService.setString(StorageKey.fromLang, code);
      return null;
    } else {
      //اتنتخاب مقصد بود
      //مبدا اتو نباشد و مقصد با زبان مبدا برابر بود
      if (state.from != "auto" && code == state.from) {
        return LanguageError.sameSourceAndTarget;
      }
      //در غیر اینصورت استیت ذخیره و استوریج ذخیره
      state = state.copyWith(to: code);
      LocalStorageService.setString(StorageKey.toLang, code);
      return null;
    }
  }

  //جابجایی زبان ها
  LanguageError? swap() {
    //مقصد اتو بود
    if (state.from == "auto") {
      return LanguageError.connotSwapWhenAuto;
    }
    //در نهاایت مبدا و مقصد جابجا شوند
    final newTo = state.from;
    final newFrom = state.to;

    //حتما مقصد اتو نباشد
    if (newTo == "auto") {
      return LanguageError.toAutoNotAllowed;
    }

    //استیت جدید ثبت شود
    state = LanguageState(from: newFrom, to: newTo);

    //استوریج هم ذخیره شود
    LocalStorageService.setString(StorageKey.fromLang, newFrom);
    LocalStorageService.setString(StorageKey.toLang, newTo);
    return null;
  }
}
