import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator_v2/screens/translate_screen.dart';
import 'package:translator_v2/theme/theme_helper.dart';
import 'package:translator_v2/providers/theme_mode_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    Future.microtask(() => ref.read(themeModeProvider.notifier).initLoadFromPref());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Flutter translator',
      themeAnimationStyle: AnimationStyle(duration: Duration(milliseconds: 350), curve: Curves.easeInOutExpo),
      theme: ThemeDataHelper.lightTheme,
      darkTheme: ThemeDataHelper.darkTheme,
      themeMode: themeMode,
      home: TranslateScreen(),
    );
  }
}
