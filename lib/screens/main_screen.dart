import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/controller.dart';
import '../properties/props.dart';
import 'about_screen.dart';

class MainScreen extends StatefulWidget {
  static const routename = "MainScreen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _controller = Get.put(Controller());

  Timer? _timer;
  DateTime? _lastPressedAt;

  _selectDate() async {
    var _datePicker = await showDatePicker(
      context: context,
      firstDate: DateTime(1000),
      lastDate: DateTime(DateTime.now().year + 1000),
      initialDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green,
            ),
          ),
          child: child!,
        );
      },
    );

    if (_datePicker != null) {
      await _controller.fetchFutureTimes(_datePicker);
      _showFutureDialog(_controller.futureDate.value, _controller.futureDay.value);
    }
  }

  // var _dbHelper = DatabaseHelper();
  // var _notificationHelper = NotificationHelper();

  // var _dateTime = "", _day = "";

  // var _nextPrayer = "";
  // var _appVersion = "";

  // var _prayerTimes = [];
  // var _futureTimes = [];

  // _timeConverter(String time) {
  //   var parsedTime = DateFormat("HH:mm").parse(time);
  //   var formattedTime = DateFormat("hh:mm a").format(parsedTime).toUpperCase();
  //   return formattedTime;
  // }

  // DateTime _convertToDateTime(String time) {
  //   // Parsing the time in 24-hour format without AM/PM
  //   var parsedTime = DateFormat("HH:mm").parse(time);
  //   // Combining with the current date
  //   var now = DateTime.now();
  //   return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  // }

  // _loadFutureTimes(futureDate) async {
  //   var _formatedQueryDate = DateFormat("dd/MM").format(futureDate!);
  //   var _formattedFutureDate = DateFormat("dd-MM-yyyy").format(futureDate);
  //   var _formattedFutureDay = DateFormat("EEEE").format(futureDate);
  //
  //   var _data = await _dbHelper.rawQuery("select * from ${_dbHelper.tableName} where DATE='$_formatedQueryDate'");
  //
  //   setState(() => _futureTimes = _data);
  //
  //   _showFutureDialog(_formattedFutureDate, _formattedFutureDay);
  // }

  // _updateNextPrayer() {
  //   var _now = DateTime.now();
  //
  //   DateTime fajr = _convertToDateTime(_prayerTimes[0]["FAJR"]);
  //   DateTime duhur = _convertToDateTime(_prayerTimes[0]["DUHUR"]);
  //   DateTime asr = _convertToDateTime(_prayerTimes[0]["ASR"]);
  //   DateTime maghrib = _convertToDateTime(_prayerTimes[0]["MAGHRIB"]);
  //   DateTime isha = _convertToDateTime(_prayerTimes[0]["ISHA"]);
  //
  //   if (_now.isBefore(fajr)) {
  //     _nextPrayer = "FAJR";
  //   } else if (_now.isBefore(duhur)) {
  //     _nextPrayer = "DUHUR";
  //   } else if (_now.isBefore(asr)) {
  //     _nextPrayer = "ASR";
  //   } else if (_now.isBefore(maghrib)) {
  //     _nextPrayer = "MAGHRIB";
  //   } else if (_now.isBefore(isha)) {
  //     _nextPrayer = "ISHA";
  //   } else {
  //     _nextPrayer = "";
  //   }
  // }

  // _load() async {
  // var _info = await PackageInfo.fromPlatform();
  // var _now = DateTime.now();
  // var _formattedDate = DateFormat("dd-MM-yyyy").format(_now);
  // var _formattedDay = DateFormat("EEEE").format(_now);

  // setState(() {
  // _dateTime = _formattedDate;
  // _day = _formattedDay;
  // _appVersion = _info.version;
  // });

  // var _today = DateFormat("dd/MM").format(_now);
  // var _data = await _dbHelper.rawQuery("select * from ${_dbHelper.tableName} where DATE='$_today'");
  // setState(() {
  //   _prayerTimes = _data;
  //   _updateNextPrayer();
  // });

  // // todo : Set up the timer to update the next prayer time every seconds
  // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //   // logs("UI UPDATED : ${DateTime.now()}");
  //   setState(() => _updateNextPrayer());
  // });

  // try {
  //   _notificationHelper.showNotification(
  //     tr("notification_title"),
  //     "${tr(_nextPrayer.toLowerCase())} ${_timeConverter(_prayerTimes[0]["$_nextPrayer"])}",
  //   );
  // } catch (e) {}
  // }

  _periodicTimer() {
    if (_controller.nextPrayer.value == "finish") return;
    // todo : Set up the timer to update the next prayer time every seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // logs("UI UPDATED : ${DateTime.now()}");
      _controller.updateNextPrayer();
      setState(() {});
    });
  }

  _load() async {
    await _controller.fetchPrayerTimes();
    _periodicTimer();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          toast("Press back again to exit");
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Row(
              children: [
                Shimmer.fromColors(
                  child: Text(
                    "Kayal Pray",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  period: Duration(seconds: 2),
                ),
                SizedBox(width: 5),
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                ),
                // Text(" ❤️"),
              ],
            ),
            actions: [
              IconButton(
                tooltip: tr("language"),
                icon: Icon(
                  FontAwesomeIcons.language,
                ),
                onPressed: () {
                  _showLanguageDialog();
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: Container(
                padding: EdgeInsets.only(left: 17, bottom: 5),
                width: double.infinity,
                child: Text(
                  "${_controller.date.value} ${tr(_controller.day.value.toLowerCase())}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: Props.decoration,
            child: _controller.prayerTimes.length == 0
                ? _buildShimmerEffect()
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          _buildPrayerTimeCard("FAJR", "الفجر", _controller.prayerTimes[0]["FAJR"]),
                          SizedBox(height: 20),
                          _buildPrayerTimeCard("DUHUR", "الظهر", _controller.prayerTimes[0]["DUHUR"]),
                          SizedBox(height: 20),
                          _buildPrayerTimeCard("ASR", "العصر", _controller.prayerTimes[0]["ASR"]),
                          SizedBox(height: 20),
                          _buildPrayerTimeCard("MAGHRIB", "المغرب", _controller.prayerTimes[0]["MAGHRIB"]),
                          SizedBox(height: 20),
                          _buildPrayerTimeCard("ISHA", "العشاء", _controller.prayerTimes[0]["ISHA"]),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
          ),
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: Image.asset("assets/images/app_icon.png"),
                  accountName: Text(
                    "Kayal Pray",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    "kayalpatnam prayer times",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "About",
                    style: TextStyle(
                      fontSize: 18,
                      // color: Colors.black87,
                    ),
                  ),
                  leading: Icon(
                    FontAwesomeIcons.addressCard,
                    size: 24,
                    color: Colors.green,
                  ),
                  onTap: () {
                    Get.toNamed(AboutScreen.routename);
                  },
                ),
                Divider(),
                Spacer(),
                Text(
                  "V ${_controller.appVersion.value}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          ),
          // todo : basil
          floatingActionButton: FloatingActionButton(
            tooltip: tr("next_date_tool_tip"),
            backgroundColor: Colors.green,
            onPressed: () {
              _selectDate();
              // _controller.alertNotify();
            },
            child: Icon(Icons.date_range),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimeCard(String prayerName, String arabicName, String time) {
    bool isNextPrayer = _controller.nextPrayer.value == prayerName;
    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          height: 100,
          width: 30,
          child: Center(
            child: Icon(
              Icons.access_time,
              color: isNextPrayer ? Colors.green : null,
            ),
          ),
        ),
        trailing: isNextPrayer
            ? Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.mosque,
                  color: Colors.green,
                  size: 35,
                ),
              )
            : null,
        title: Text(
          "${tr(prayerName.toLowerCase())} ($arabicName)",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("${_controller.timeConverter(time)}"),
      ),
    );
  }

  Widget _buildFutureTimeCard(String prayerName, String arabicName, String time) {
    return Card(
      color: Colors.teal[100],
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "${tr(prayerName.toLowerCase())} ($arabicName)",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal[900],
          ),
        ),
        subtitle: Text(
          "${_controller.timeConverter(time)}",
          style: TextStyle(
            color: Colors.teal[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(
          Icons.access_time,
          color: Colors.teal[800],
        ),
      ),
    );
  }

  _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              tr('select_language'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: Colors.grey, height: 1),
              ListTile(
                leading: Icon(Icons.language, color: Colors.green),
                title: Text(
                  'தமிழ்',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Get.back();
                  context.setLocale(Locale('ta'));
                  Get.updateLocale(Locale('ta'));
                },
              ),
              Divider(color: Colors.grey, height: 1),
              ListTile(
                leading: Icon(Icons.language, color: Colors.blue),
                title: Text(
                  'English',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Get.back();
                  context.setLocale(Locale('en'));
                  Get.updateLocale(Locale('en'));
                },
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
            ],
          ),
        );
      },
    );
  }

  _showFutureDialog(date, day) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.teal[50],
          content: Container(
            height: 550,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "$date\n${tr(day.toLowerCase())}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildFutureTimeCard("FAJR", "الفجر", _controller.futureTimes[0]["FAJR"]),
                  _buildFutureTimeCard("DUHUR", "الظهر", _controller.futureTimes[0]["DUHUR"]),
                  _buildFutureTimeCard("ASR", "العصر", _controller.futureTimes[0]["ASR"]),
                  _buildFutureTimeCard("MAGHRIB", "المغرب", _controller.futureTimes[0]["MAGHRIB"]),
                  _buildFutureTimeCard("ISHA", "العشاء", _controller.futureTimes[0]["ISHA"]),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(tr("close")),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Placeholder count for shimmer effect
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16.0,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 12.0,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 80.0,
                          height: 12.0,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
