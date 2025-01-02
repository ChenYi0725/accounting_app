import 'package:accounting_app/model/init_insert_type.dart';
import 'package:accounting_app/Controller/calculator_controller.dart';
import 'package:accounting_app/config.dart';
import 'package:accounting_app/small_widget/insert_type_list.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../Database/database_helper.dart';
import '../model/calculator_view.dart';

class EditPage extends StatefulWidget {
  final id;

  EditPage({required this.id});
  @override
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<EditPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int currentDate = 0;
  String insertType = "種類";
  String transactionType = "支出";
  Icon insertTypeIcon = Icon(Icons.ice_skating);
  TextEditingController noteController = TextEditingController();
  String inputExpression = "";
  FocusNode _noteFocusNode = FocusNode();
  CalculatorController calculatorController = CalculatorController();
  ColorConfig colorConfig = ColorConfig();
  initInsertType accountTypeController = initInsertType();
  List<String> get categories {
    if (transactionType == "支出") {
      return accountTypeController.expenseTypeCategories;
    } else {
      return accountTypeController.incomeTypeCategories;
    }
  }

  List<IconData> get iconCategories {
    if (transactionType == "支出") {
      return accountTypeController.expenseIconCategories;
    } else {
      return accountTypeController.incomeIconCategories;
    }
  }

//-----------------
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void updatePage() {
    int a = 0;
    setState(() {});
  }

  void _loadData() async {
    final data = await databaseHelper.fetchAccountById(widget.id);
    if (data != null) {
      setState(() {
        transactionType = data['transactionType'] ?? "支出";
        insertType = data['type'] ?? "種類";
        insertTypeIcon = const Icon(Icons.abc);
        inputExpression = data['money']?.toString() ?? "";
        noteController.text = data['description'] ?? "";
        currentDate = data['date'] ?? "";
      });
    } else {
      _showErrorDialog("未找到指定的資料");
    }
  }

  void _onTypeSelected(String type, IconData icon) {
    setState(() {
      insertType = type;
      insertTypeIcon = Icon(icon);
    });
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
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
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
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    databaseHelper.deleteAccount(widget.id);
                    Navigator.pop(context, 'update');
                  },
                  icon: const Icon(
                    Icons.restore_from_trash,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    int parsedAmount;
                    try {
                      parsedAmount = double.parse(inputExpression).round();
                    } catch (e) {
                      _showErrorDialog("金額錯誤");
                      return;
                    }

                    databaseHelper.updateAccount(
                        widget.id,
                        insertType,
                        parsedAmount,
                        transactionType == "支出" ? true : false,
                        currentDate,
                        noteController.text);
                    Navigator.pop(context, 'update');
                  },
                  icon: const Icon(
                    Icons.save,
                    color: Colors.black,
                  )),
            ],
          )
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
            color: Colors.yellow[100],
            child: Row(
              children: [
                Row(
                  children: [
                    insertTypeIcon,
                    Text(" ${insertType}  "),
                  ],
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "\$：$inputExpression",
                    style: TextStyle(fontSize: 20),
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
                        border: OutlineInputBorder(),
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
              color: Colors.yellow,
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
