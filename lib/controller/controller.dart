import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../model/db_model.dart';
import '../model/notification_model.dart';
import '../properties/props.dart';

class Controller extends GetxController {
  var appVersion = "".obs;
  var appPackageName = "".obs;

  var date = "".obs;
  var day = "".obs;
  var currentDateTime = DateTime.now().obs;
  var futureDate = "".obs;
  var futureDay = "".obs;

  var nextPrayer = "".obs;
  var prayerTimes = [].obs;
  var futureTimes = [].obs;

  var _dbHelper = DatabaseHelper();
  var _notificationHelper = NotificationHelper();

  _loadDefaults() async {
    var _info = await PackageInfo.fromPlatform();

    date.value = DateFormat("dd-MM-yyyy").format(currentDateTime.value);
    day.value = DateFormat("EEEE").format(currentDateTime.value);

    appVersion.value = _info.version;
    appPackageName.value = _info.packageName;
  }

  fetchPrayerTimes() async {
    await _loadDefaults();

    prayerTimes.clear();

    var _today = DateFormat("dd/MM").format(currentDateTime.value);
    var _data = await _dbHelper.rawQuery("select * from ${_dbHelper.tableName} where DATE='$_today'");

    prayerTimes.value = _data;

    updateNextPrayer();
  }

  DateTime _convertToDateTime(String time) {
    // Parsing the time in 24-hour format without AM/PM
    var parsedTime = DateFormat("HH:mm").parse(time);
    // Combining with the current date
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  }

  updateNextPrayer() {
    DateTime fajr = _convertToDateTime(prayerTimes[0]["FAJR"]);
    DateTime duhur = _convertToDateTime(prayerTimes[0]["DUHUR"]);
    DateTime asr = _convertToDateTime(prayerTimes[0]["ASR"]);
    DateTime maghrib = _convertToDateTime(prayerTimes[0]["MAGHRIB"]);
    DateTime isha = _convertToDateTime(prayerTimes[0]["ISHA"]);

    if (currentDateTime.value.isBefore(fajr)) {
      nextPrayer.value = "FAJR";
    } else if (currentDateTime.value.isBefore(duhur)) {
      nextPrayer.value = "DUHUR";
    } else if (currentDateTime.value.isBefore(asr)) {
      nextPrayer.value = "ASR";
    } else if (currentDateTime.value.isBefore(maghrib)) {
      nextPrayer.value = "MAGHRIB";
    } else if (currentDateTime.value.isBefore(isha)) {
      nextPrayer.value = "ISHA";
    } else {
      nextPrayer.value = "finish";
    }
    customlogs("Next Prayer : ${nextPrayer.value}");
  }

  fetchFutureTimes(date) async {
    var _formatedQueryDate = DateFormat("dd/MM").format(date!);
    futureDate.value = DateFormat("dd-MM-yyyy").format(date);
    futureDay.value = DateFormat("EEEE").format(date);

    var _data = await _dbHelper.rawQuery("select * from ${_dbHelper.tableName} where DATE='$_formatedQueryDate'");

    futureTimes.value = _data;
    customlogs(futureTimes.toString());
  }

  timeConverter(String time) {
    var parsedTime = DateFormat("HH:mm").parse(time);
    var formattedTime = DateFormat("hh:mm a").format(parsedTime).toUpperCase();
    return formattedTime;
  }

  alertNotify() {
    if (nextPrayer.value == "finish") return;

    _notificationHelper.showNotification(
      tr("notification_title"),
      "${tr(nextPrayer.value.toLowerCase())} ${timeConverter(prayerTimes[0]["${nextPrayer.value}"])}",
    );
  }
}
