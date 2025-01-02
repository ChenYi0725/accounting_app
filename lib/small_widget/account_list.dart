import 'package:accounting_app/Database/database_helper.dart';
import 'package:accounting_app/pages/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainPageAccountList extends StatefulWidget {
  MainPageAccountList({
    super.key,
    required this.currentDate,
    required this.timeUnit,
  });

  final DateTime currentDate;
  final int timeUnit;

  @override
  State<MainPageAccountList> createState() => _MainPageAccountListState();
}

class _MainPageAccountListState extends State<MainPageAccountList> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<int>> _fetchTimePeriod() async {
    DateTime currentDate = widget.currentDate;
    int timeIndex = widget.timeUnit;
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

    return [startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: _fetchTimePeriod(),
      builder: (context, timeSnapshot) {
        if (timeSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (timeSnapshot.hasError) {
          return const Center(child: Text('載入時間範圍時發生錯誤'));
        } else if (!timeSnapshot.hasData) {
          return const Center(child: Text('無法取得時間範圍'));
        }

        final timePeriod = timeSnapshot.data!;
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: databaseHelper.fetchAccountsByDateRange(
              timePeriod[0], timePeriod[1]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('載入資料時發生錯誤'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('本日還沒記帳'));
            } else {
              final accounts = snapshot.data!;
              return ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(id: account['_id']),
                        ),
                      ).then((result) {
                        if (result != null) {
                          setState(() {});
                        }
                      });
                    },
                    title: Text(
                      '類型: ${account['type']}',
                      style: TextStyle(
                          color: account['isExpense'] == 1
                              ? Colors.red
                              : Colors.green),
                    ),
                    subtitle: Text('金額: ${account['money']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                account['date']),
                          ),
                        ),
                        account['description'] != null
                            ? Text(account['description'])
                            : const SizedBox(),
                      ],
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
