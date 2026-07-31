import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:translator_v2/consts/language_error_mesage.dart';
import 'package:translator_v2/consts/languages_list.dart';
import 'package:translator_v2/controllers/language_controller.dart';
import 'package:translator_v2/controllers/translate_controller.dart';
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

  TextEditingController textEditingInPuotController = TextEditingController();
  TextEditingController textEditingOutPuotController = TextEditingController();

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

    final longController = ref.read(languageProvider.notifier);
    final translateController = ref.read(translateProvider.notifier);

    ref.listen<TranslateState>(
      translateProvider,
      (previous, next) => textEditingOutPuotController.text = next.output,
    );

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
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

                              if (error == null) {
                                ref.read(translateProvider.notifier).swopTexts();
                                final res = ref.watch(translateProvider);
                                textEditingInPuotController.text = res.input;
                                textEditingOutPuotController.text = res.output;
                              } else {
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
                        controller: textEditingInPuotController,
                        textDirection: langState.from == "fa" || langState.from == "ar"
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        decoration: InputDecoration(
                          hint: Text('Enter your text'),
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            textEditingOutPuotController.text = "";
                          }
                          translateController.onTextChanged(value);
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          TextField(
                            controller: textEditingOutPuotController,
                            textDirection: langState.from == "fa" || langState.from == "ar"
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                            readOnly: true,
                            onChanged: (value) {
                              translateController.onTextChanged(value);
                            },
                          ),
                          if (ref.watch(translateProvider).isLoading)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.lime, size: 70),
                              ),
                            ),
                        ],
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
