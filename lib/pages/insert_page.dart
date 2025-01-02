import 'package:accounting_app/Controller/account_type_controller.dart';
import 'package:accounting_app/Controller/calculator_controller.dart';
import 'package:accounting_app/config.dart';
import 'package:accounting_app/model/insert_type_list.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../Database/database_helper.dart';
import '../model/calculator_view.dart';

class InsertPage extends StatefulWidget {
  late DateTime currentDate = DateTime.now();

  InsertPage({required this.currentDate});
  @override
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  AccountTypeController accountTypeController = AccountTypeController();
  late String insertType;
  String transactionType = "支出";
  late IconData insertTypeIcon;
  TextEditingController noteController = TextEditingController();
  String inputExpression = "";
  FocusNode _noteFocusNode = FocusNode();
  CalculatorController calculatorController = CalculatorController();
  ColorConfig colorConfig = ColorConfig();
  @override
  void initState() {
    super.initState();
    insertType = accountTypeController.expenseTypeCategories[0];
    insertTypeIcon = accountTypeController.expenseIconCategories[0];
  }

  void _onTypeSelected(String type, IconData icon) {
    setState(() {
      insertType = type;
      insertTypeIcon = icon;
    });
  }

  List<String> get categories {
    if (transactionType == "支出") {
      return accountTypeController.expenseTypeCategories;
    } else {
      return accountTypeController.incomeTypeCategories;
    }
  }

  void updatePage() {
    print("update");
    setState(() {});
  }

  List<IconData> get iconCategories {
    if (transactionType == "支出") {
      return accountTypeController.expenseIconCategories;
    } else {
      return accountTypeController.incomeIconCategories;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("請檢查輸入"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('確定'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _insertAccount() async {
    final databaseHelper = DatabaseHelper();
    int parsedAmount;
    try {
      parsedAmount = double.parse(inputExpression).round();
    } catch (e) {
      print("wrong money");
      _showErrorDialog("金額錯誤");
      return;
    }

    int result = await databaseHelper.insertAccount(
        insertType,
        parsedAmount,
        transactionType == "支出" ? true : false,
        widget.currentDate.millisecondsSinceEpoch,
        noteController.text);

    if (result > 0) {
      Navigator.pop(context, "update");
    } else {
      _showErrorDialog("資料插入失敗，請檢查輸入");
    }
  }

  void onCalculatorPress(String value) {
    setState(() {
      if (value == "C") {
        inputExpression = "";
      } else if (value == "=") {
        try {
          Parser parser = Parser();
          Expression expression = parser.parse(inputExpression);
          ContextModel cm = ContextModel();
          double result = expression.evaluate(EvaluationType.REAL, cm);
          inputExpression = result.toStringAsFixed(0);
        } catch (e) {
          inputExpression = "Error";
        }
      } else if (value == "<") {
        if (inputExpression.isNotEmpty) {
          inputExpression =
              inputExpression.substring(0, inputExpression.length - 1);
        }
      } else {
        inputExpression += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorConfig.mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, "update"),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  insertType = accountTypeController.expenseTypeCategories[0];
                  insertTypeIcon =
                      accountTypeController.expenseIconCategories[0];
                  transactionType = "支出";
                });
              },
              child: Text(
                "支出",
                style: TextStyle(
                    color: transactionType == "支出" ? Colors.black : Colors.grey,
                    fontSize: 20),
              ),
            ),
            Text("|", style: TextStyle(color: Colors.white, fontSize: 20)),
            TextButton(
              onPressed: () {
                setState(() {
                  insertType = accountTypeController.incomeTypeCategories[0];
                  insertTypeIcon =
                      accountTypeController.incomeIconCategories[0];
                  transactionType = "收入";
                });
              },
              child: Text(
                "收入",
                style: TextStyle(
                  fontSize: 20,
                  color: transactionType == "收入" ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _insertAccount();
              },
              icon: const Icon(
                Icons.save,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InsertTypeList(
              onTypeSelected: _onTypeSelected,
              categories: categories,
              iconCategories: iconCategories,
              transactionType: transactionType,
              updatePage: updatePage,
            ),
          ),
          SizedBox(height: 16),
          Container(
            color: colorConfig.calculatorColor1,
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(insertTypeIcon),
                    Text(" $insertType  "),
                  ],
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "\$：$inputExpression",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(_noteFocusNode);
                    },
                    child: TextField(
                      controller: noteController,
                      focusNode: _noteFocusNode,
                      decoration: InputDecoration(
                        labelText: "備註",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: colorConfig.calculatorColor2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CalculatorView(onCalculatorPress: onCalculatorPress),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
