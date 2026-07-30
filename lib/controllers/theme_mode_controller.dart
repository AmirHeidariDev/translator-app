import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator_v2/services/storage/local_storage_service.dart';
import 'package:translator_v2/services/storage/storage_key.dart';

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  Future<void> initLoadFromPref() async {
    final themeModeSaved = await LocalStorageService.getString(StorageKey.themeMode);

    state = switch (themeModeSaved) {
      "light" => ThemeMode.light,
      "dark" => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void setMode(ThemeMode themeMode) {
    state = themeMode;
    _saveMode(themeMode);
  }

  void _saveMode(ThemeMode themeMode) async {
    await LocalStorageService.setString(StorageKey.themeMode, themeMode.name);
  }
}
