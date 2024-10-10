import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workmanager/workmanager.dart';
import 'controller/controller.dart';
import 'model/db_model.dart';
import 'model/notification_model.dart';
import 'properties/props.dart';
import 'screens/about_screen.dart';
import 'screens/main_screen.dart';
import 'package:get/get.dart';

var _controller = Get.put(Controller());

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await _controller.fetchPrayerTimes();
    _controller.alertNotify();

    customlogs("Called background task: $task");
    return Future.value(true);
  });
}

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
  var data = await _dbHelper.query();
  if (data.isEmpty) await _dbHelper.batch(Props.timings);

  // Workmanager Initialize
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask("workmanager_task", "prayer checking");

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kayal Pray",
      theme: ThemeData(
        useMaterial3: false,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      getPages: [
        GetPage(
          name: AboutScreen.routename,
          page: () => AboutScreen(),
        ),
      ],
      home: MainScreen(),
    );
  }
}
