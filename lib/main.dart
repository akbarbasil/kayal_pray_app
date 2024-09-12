import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helper/dbHelper.dart';
import 'helper/notification_helper.dart';
import 'props/props.dart';
import 'screens/about_screen.dart';
import 'screens/main_screen.dart';

NotificationHelper _notificationHelper = NotificationHelper();
DatabaseHelper _dbHelper = DatabaseHelper();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification and permissions
  await _notificationHelper.initializeNotification();
  await _notificationHelper.requestPermissions();

  // Ensure EasyLocalization is initialized
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  // Query database and insert if empty
  var _datas = await _dbHelper.query();
  if (_datas.isEmpty) await _dbHelper.batch(Props.timings);

  await Future.delayed(Duration(seconds: 1));

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ta')],
      path: 'assets/translations',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kayal Pray",
      theme: ThemeData(
        useMaterial3: false,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routes: {
        AboutScreen.routename: (c) => AboutScreen(),
      },
      home: MainScreen(),
    );
  }
}
