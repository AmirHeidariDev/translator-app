import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator_v2/providers/language_provider.dart';
import 'package:translator_v2/services/api/translate_service.dart';

class TranslateState {
  final String input, output;
  final String? error;
  final bool isLoading;

  TranslateState({required this.input, required this.output, this.error, required this.isLoading});

  factory TranslateState.initial() {
    return TranslateState(input: '', output: '', isLoading: false);
  }

  TranslateState copyWith({String? input, output, error, bool? isLoading}) {
    return TranslateState(
      input: input ?? this.input,
      output: output ?? this.output,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TranslateController extends Notifier<TranslateState> {
  final _translateService = TranslateService();
  Timer? _debounce;
  @override
  TranslateState build() {
    ref.onDispose(() => _debounce?.cancel());

    ref.listen(languageProvider, (previous, next) {
      if (state.input.trim().isNotEmpty) {
        Future.microtask(() => translateNow());
      }
    });

    return TranslateState.initial();
  }

  void onTextChanged(String text) {
    _debounce?.cancel();
    state = state.copyWith(input: text);
    final cleaned = text.trim();
    if (cleaned.isEmpty) {
      _debounce?.cancel();
      state = state.copyWith(output: '', isLoading: false);
    }

    _debounce = Timer(Duration(milliseconds: 50), () => translateNow());
  }

  Future<void> translateNow() async {
    final text = state.input.trim();
    if (text.isEmpty) state = state.copyWith(output: '', isLoading: false, error: null);

    final lang = ref.read(languageProvider);

    state = state.copyWith(isLoading: true);
    try {
      final out = await _translateService.translateText(text: state.input, from: lang.from, toLong: lang.to);
      state = state.copyWith(output: out, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(error: 'ترجمه انجام نشد اینترنت را بررسی کن', isLoading: false, output: '');
    }
  }

  void swopTexts() {
    final currentInput = state.input;
    final currentOutput = state.output;

    state = state.copyWith(output: currentInput, input: currentOutput, error: null);
  }
}
