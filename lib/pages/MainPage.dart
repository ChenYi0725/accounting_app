import 'package:accounting_app/Database/database_helper.dart';
import 'package:accounting_app/config.dart';
import 'package:accounting_app/model/bar_code.dart';
import 'package:accounting_app/model/main_page_drawer.dart';
import 'package:accounting_app/model/summary.dart';
import 'package:accounting_app/pages/insert_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/account_list.dart';
import '../model/main_page_chart.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  ColorConfig colorConfig = ColorConfig();
  List<String> periods = ["日", "月", "年"];
  int timeIndex = 0;
  DateTime currentDate = DateTime.now();
  int totalExpense = 0;
  int totalIncome = 0;
  bool isChartShow = true;

  String getFormattedDate() {
    DateFormat dateFormat;
    if (periods[timeIndex] == "日") {
      dateFormat = DateFormat('yyyy-MM-dd');
    } else if (periods[timeIndex] == "月") {
      dateFormat = DateFormat('yyyy-MM');
    } else {
      dateFormat = DateFormat('yyyy');
    }
    setState(() {});
    return dateFormat.format(currentDate);
  }

  void _timeUnitLeft() {
    setState(() {
      timeIndex = (timeIndex - 1) % periods.length;
      _fetchTotalData();
    });
  }

  void _timeUnitRight() {
    setState(() {
      timeIndex = (timeIndex + 1) % periods.length;
      _fetchTotalData();
    });
  }

  void updateMainPage() {
    _fetchTotalData();
    setState(() {});
  }

  void _addDate() {
    setState(() {
      if (periods[timeIndex] == "日") {
        currentDate = currentDate.add(const Duration(days: 1)); // 增加一天
      } else if (periods[timeIndex] == "月") {
        currentDate = DateTime(
            currentDate.year, currentDate.month + 1, currentDate.day); // 增加一個月
      } else {
        currentDate = DateTime(
            currentDate.year + 1, currentDate.month, currentDate.day); // 增加一年
      }
      _fetchTotalData();
    });
  }

  void _minusDate() {
    setState(() {
      if (periods[timeIndex] == "日") {
        currentDate = currentDate.subtract(const Duration(days: 1)); // 減少一天
      } else if (periods[timeIndex] == "月") {
        currentDate = DateTime(
            currentDate.year, currentDate.month - 1, currentDate.day); // 減少一個月
      } else {
        currentDate = DateTime(
            currentDate.year - 1, currentDate.month, currentDate.day); // 減少一年
      }
      _fetchTotalData();
    });
  }

  void _fetchTotalData() async {
    DateTime startTime = DateTime(currentDate.year, 1, 1);
    DateTime endTime = DateTime(currentDate.year, 12, 31, 23, 59, 59);

    if (timeIndex == 0) {
      // 日
      startTime =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      endTime = DateTime(
          currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
    } else if (timeIndex == 1) {
      // 月
      startTime = DateTime(currentDate.year, currentDate.month, 1);
      endTime =
          DateTime(currentDate.year, currentDate.month + 1, 0, 23, 59, 59);
    } else {
      // 年
      startTime = DateTime(currentDate.year, 1, 1);
      endTime = DateTime(currentDate.year, 12, 31, 23, 59, 59);
    }

    int startTimeMillis = startTime.millisecondsSinceEpoch;
    int endTimeMillis = endTime.millisecondsSinceEpoch;

    final int fetchedTotalExpense = await databaseHelper.fetchTotalByDateRange(
        startTimeMillis, endTimeMillis, true);
    final int fetchedTotalIncome = await databaseHelper.fetchTotalByDateRange(
        startTimeMillis, endTimeMillis, false);

    setState(() {
      totalExpense = fetchedTotalExpense;
      totalIncome = fetchedTotalIncome;
    });
  }

  void _initDate() {
    currentDate = DateTime.now();
    _fetchTotalData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.dehaze),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _timeUnitLeft,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: "切換時間單位",
                ),
                Container(
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      periods[timeIndex],
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _timeUnitRight,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: "切換時間單位",
                ),
              ],
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
        backgroundColor: colorConfig.mainColor,
      ),
      drawer: MainPageDrawer(
        updateMainPage: updateMainPage,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Summary(summaryType: "支出", money: totalExpense),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: _minusDate,
                        icon: const Icon(Icons.arrow_left)),
                    TextButton(
                      onPressed: _initDate,
                      child: Text(
                        getFormattedDate(),
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    IconButton(
                        onPressed: _addDate,
                        icon: const Icon(Icons.arrow_right))
                  ],
                ),
                Summary(summaryType: "收入", money: totalIncome)
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onLongPress: () {
                isChartShow = !isChartShow;
                setState(() {});
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                isChartShow = !isChartShow;
                setState(() {});
              },
              child: Container(
                color: Colors.transparent,
                height: 200,
                child: isChartShow
                    ? DonutChart(
                        firstSectionValue: totalIncome.toDouble(),
                        secondSectionValue: totalExpense.toDouble(),
                        balance: (totalIncome - totalExpense),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 250,
                          child: BarCode(),
                        ),
                      ),
              ),
            ),
          ),
          Container(
            color: colorConfig.listColor2,
            height: 2,
          ),
          Expanded(
            child: Container(
              color: colorConfig.listColor,
              child: MainPageAccountList(
                currentDate: currentDate,
                timeUnit: timeIndex,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InsertPage(
                        currentDate: currentDate,
                      ))).then((result) async {
            _fetchTotalData();
            setState(() {});
          });
        },
        backgroundColor: colorConfig.secondColor,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
