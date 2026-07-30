import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:translator_v2/consts/language_error_mesage.dart';
import 'package:translator_v2/consts/languages_list.dart';
import 'package:translator_v2/controllers/language_controller.dart';
import 'package:translator_v2/models/language_model.dart';
import 'package:translator_v2/providers/language_provider.dart';
import 'package:translator_v2/providers/theme_mode_provider.dart';
import 'package:translator_v2/providers/translate_provider.dart';

class TranslateScreen extends ConsumerStatefulWidget {
  const TranslateScreen({super.key});

  @override
  ConsumerState<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends ConsumerState<TranslateScreen> {
  @override
  void initState() {
    Future.microtask(() => ref.read(languageProvider.notifier).loadLanguageStorage());
    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();

  void _showError(BuildContext context, LanguageError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(languageErrorMesage(error: error), textAlign: TextAlign.right),
      ),
    );
  }

  final List<LanguageModel> toLanguagesItems = languagesList
      .where((element) => element.code != "auto")
      .toList();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    final langState = ref.watch(languageProvider);
    final translateState = ref.watch(translateProvider);

    final longController = ref.read(languageProvider.notifier);
    final translateController = ref.read(translateProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Translate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Center(
                              child: DropdownButton(
                                borderRadius: BorderRadius.circular(10),
                                icon: Icon(Icons.keyboard_arrow_down_outlined),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                isExpanded: true,
                                alignment: Alignment.center,
                                underline: SizedBox(),
                                value: langState.from,
                                items: languagesList
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.code,
                                        child: Text(e.name, overflow: TextOverflow.ellipsis),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  final error = longController.setLanguage(LanguageTarget.from, value!);
                                  if (error != null) {
                                    _showError(context, error);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              final error = ref.read(languageProvider.notifier).swap();

                              if (error != null) {
                                _showError(context, error);
                              }
                            },
                            child: Card(
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: Icon(Icons.change_circle_outlined),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Center(
                              child: DropdownButton(
                                borderRadius: BorderRadius.circular(10),
                                icon: Icon(Icons.keyboard_arrow_down_outlined),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.center,
                                underline: SizedBox(),
                                isExpanded: true,
                                value: langState.to,
                                items: toLanguagesItems
                                    .map((e) => DropdownMenuItem(value: e.code, child: Text(e.name)))
                                    .toList(),
                                onChanged: (value) {
                                  final error = longController.setLanguage(LanguageTarget.to, value!);
                                  if (error != null) {
                                    _showError(context, error);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Card(
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: TextField(
                        controller: textEditingController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          hint: Text('Enter your text'),
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          translateController.onTextChanged(value);
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: TextField(
                        decoration: InputDecoration(
                          hint: translateState.isLoading
                              ? LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 35)
                              : Text(translateState.output),
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          translateController.onTextChanged(value);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 4.5),
                  Center(
                    child: SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment(value: ThemeMode.system, label: Text('system')),
                        ButtonSegment(value: ThemeMode.light, label: Text('light')),
                        ButtonSegment(value: ThemeMode.dark, label: Text('dark')),
                      ],
                      selected: {themeMode},
                      onSelectionChanged: (index) {
                        ref.read(themeModeProvider.notifier).setMode(index.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
