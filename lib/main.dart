import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'firebase_options.dart';
import 'pages/home.dart';
import 'pages/app_settings.dart' show AppSettingsData, AppSettingsStore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppSettingsStore.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsStore.instance,
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Smart AgroSupport',
          locale: AppSettingsStore.localeFor(settings.selectedLanguage),
          supportedLocales: const [
            Locale('bn'),
            Locale('en'),
            Locale('hi'),
            Locale('ur'),
            Locale('ar'),
            Locale('es'),
            Locale('zh'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: settings.darkModeEnabled
              ? ThemeMode.dark
              : ThemeMode.light,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(settings.fontScale),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true)
              .copyWith(
                textTheme: ThemeData(
                  primarySwatch: Colors.green,
                  useMaterial3: true,
                ).textTheme.apply(fontSizeFactor: settings.fontScale),
              ),
          darkTheme:
              ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                colorSchemeSeed: Colors.green,
              ).copyWith(
                textTheme: ThemeData(
                  useMaterial3: true,
                  brightness: Brightness.dark,
                  colorSchemeSeed: Colors.green,
                ).textTheme.apply(fontSizeFactor: settings.fontScale),
              ),
          home: const _Preloader(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class _Preloader extends StatefulWidget {
  const _Preloader();
  @override
  State<_Preloader> createState() => _PreloaderState();
}

class _PreloaderState extends State<_Preloader> {
  static const _images = [
    'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1920&q=80',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final url in _images) {
      CachedNetworkImageProvider(url).resolve(const ImageConfiguration());
    }
  }

  @override
  Widget build(BuildContext context) => const HomePage();
}
