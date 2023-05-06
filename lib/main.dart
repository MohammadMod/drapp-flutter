import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tandrustito/core/shared/close_keyboard.dart';
import 'package:tandrustito/core/shared/imports.dart';
import 'package:tandrustito/core/shared/local_favs.dart';
import 'package:tandrustito/core/shared/theme_lang_notifier.dart';
import 'package:tandrustito/features/account/controller.dart';
import 'package:tandrustito/features/chats/data_source/remote_chat.dart';
import 'package:tandrustito/features/doctors/presentation/controllers/doctors_controller.dart';
import 'package:tandrustito/features/doctors/presentation/controllers/favs_controller.dart';
import 'package:tandrustito/features/reklams/controller/reklam_notifier.dart';
import 'package:tandrustito/features/specialiests/precentation/controller/specialiests_controller.dart';
import 'package:tandrustito/firebase_options.dart';
import 'package:tandrustito/localization/app_local.dart';
import 'package:tandrustito/localization/halpers_consttansts.dart';
import 'package:tandrustito/localization/kurdish_cupertino_local.dart';
import 'package:tandrustito/localization/kurdish_local.dart';
import 'package:tandrustito/views/first_screen.dart';
import 'package:tandrustito/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHalper.instance.initDatas();
  await LocalFavs.instance.initDatas();
  await AccountNotifer.instance.getAccount();
  ThemeLangNotifier.instance.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runZonedGuarded<Future<void>>(() async {
    runApp(
      const MyApp(), // Wrap your app
    );
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeLangNotifier.instance),
        ChangeNotifierProvider(create: (_) => ReklamNotifiers.instance),
        ChangeNotifierProvider(create: (_) => RemoveCHatSource.instance),
        ChangeNotifierProvider(create: (_) => PharmaciesNotifer.instance),
        ChangeNotifierProvider(create: (_) => FavsNotifier.instance),
        ChangeNotifierProvider(create: (_) => LabsNotifer.instance),
        ChangeNotifierProvider(create: (_) => DoctorsNotifer.instance),
        ChangeNotifierProvider(create: (_) => CategoriesNotifer.instance),
        ChangeNotifierProvider(create: (_) => AccountNotifer.instance),
      ],
      child: Consumer<ThemeLangNotifier>(builder: (context, myType, child) {
        return MaterialApp(
          title: 'Medcal App',
          debugShowCheckedModeBanner: false,
          themeMode:
              myType.themeMode == true ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            primaryColor: primaryColor,
            inputDecorationTheme:
                const InputDecorationTheme(fillColor: openColor),
            appBarTheme:
                const AppBarTheme(elevation: 0, backgroundColor: primaryColor),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: primaryColor,
            inputDecorationTheme:
                const InputDecorationTheme(fillColor: openColor),
            appBarTheme:
                const AppBarTheme(elevation: 0, backgroundColor: primaryColor),
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            CkbWidgetLocalizations.delegate,
            CkbMaterialLocalizations.delegate,
            KurdishCupertinoLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          builder: (context, child) {
            return Material(
              child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    closeKeyBoard(context);
                  },
                  child: child),
            );
          },
          navigatorKey: Halper.i.navigatorKey,
          supportedLocales: supportedLocales,
          locale: getLocale(myType.lang),
          home: ScrollConfiguration(
              behavior: MyBehavior(), child: const FirstScreen()),
        );
      }),
    );
  }
}
