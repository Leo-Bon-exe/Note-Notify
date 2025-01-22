import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'package:not_uygulamasi/models/note_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'home_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://drawable/icon',
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.teal,
        locked: false,
        importance: NotificationImportance.High,
        /*soundSource: 'resource://raw/res_custom_notification'*/ channelDescription:
            'This is The Description',
      ),
    ],
  );


  await Hive.initFlutter('uygulama');
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<bool>('bool');
  await Hive.openBox<Note>('deleted_notes');
  await Hive.openBox<Note>('notes');

  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
        Locale('ru'),
        Locale('pt'),
        Locale('no'),
        Locale('ko'),
        Locale('ja'),
        Locale('it'),
        Locale('id'),
        Locale('hi'),
        Locale('fr'),
        Locale('es'),
        Locale('el'),
        Locale('de'),
        Locale('da'),
        Locale('cs'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 3,
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.grey,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(background: Colors.grey),
        ),
        home: const HomePage(),
      );
    });
  }
}
